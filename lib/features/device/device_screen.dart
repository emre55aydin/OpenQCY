import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/qcy/anc.dart';
import '../../core/qcy/product_features.dart';
import '../../l10n/app_strings.dart';
import '../../models/device_info.dart';
import '../../models/session.dart';
import '../../providers/providers.dart';
import '../../widgets/anc_selector.dart';
import '../../widgets/auto_off_selector.dart';
import '../../widgets/battery_ring.dart';
import '../../widgets/eq_preset_selector.dart';
import '../../widgets/settings_ui.dart';

class DeviceScreen extends ConsumerStatefulWidget {
  const DeviceScreen({super.key});

  @override
  ConsumerState<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends ConsumerState<DeviceScreen> {
  bool _ancBusy = false;

  Future<void> _run(Future<void> Function() action, String label) async {
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.actionFailed(label, e))),
        );
      }
    }
  }

  Future<void> _setAnc(AncMode mode) async {
    if (_ancBusy) return;
    setState(() => _ancBusy = true);
    HapticFeedback.lightImpact();
    await _run(() => ref.read(bleControllerProvider).setAncMode(mode), 'ANC');
    if (mounted) setState(() => _ancBusy = false);
  }

  Future<void> _renameDevice() async {
    final session = ref.read(bleControllerProvider).session;
    if (session == null) return;
    final strings = context.strings;
    final controller = TextEditingController(text: session.device.displayName);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.renameDevice),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: strings.deviceName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(strings.save),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    await _run(
      () => ref.read(bleControllerProvider).setDeviceName(name),
      strings.rename,
    );
  }

  Future<void> _showFindEarbuds() async {
    final strings = context.strings;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.findEarbuds,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.findEarbudsDescription,
                  style: Theme.of(sheetContext).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _run(
                    () => ref.read(bleControllerProvider).setFindEarbuds(true),
                    strings.findEarbuds,
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(strings.startLocating),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _run(
                    () => ref.read(bleControllerProvider).setFindEarbuds(false),
                    strings.stop,
                  ),
                  icon: const Icon(Icons.stop),
                  label: Text(strings.stop),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _goBack() async {
    await ref.read(bleControllerProvider).softDisconnect();
    if (mounted) context.pop();
  }

  Future<void> _disconnect() async {
    await ref.read(bleControllerProvider).disconnect();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final ble = ref.watch(bleControllerProvider);
    final session = ble.session;
    final scheme = Theme.of(context).colorScheme;
    final strings = context.strings;

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.device)),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: Text(strings.backToScan),
          ),
        ),
      );
    }

    final connected = session.phase == ConnectionPhase.connected;
    final interactive = connected && !session.isBusy;
    final features = featuresForVendor(session.device.vendorId);
    final s = session.settings;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(bleControllerProvider).softDisconnect();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(session.device.displayName),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
          ),
          actions: [
            IconButton(
              onPressed: interactive ? () => ble.refreshStatus() : null,
              icon: const Icon(Icons.refresh),
              tooltip: strings.scanAgain,
            ),
            IconButton(
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings_outlined),
              tooltip: strings.settings,
            ),
            IconButton(
              onPressed: connected ? _disconnect : null,
              icon: const Icon(Icons.link_off),
              tooltip: strings.disconnect,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _StatusBanner(session: session),
            const SizedBox(height: 20),
            _BatteryCard(battery: session.battery),
            if (session.firmware != null) ...[
              const SizedBox(height: 8),
              Text(
                'Firmware ${strings.left} ${session.firmware!.left}'
                '${session.firmware!.right != null ? ' · ${strings.right} ${session.firmware!.right}' : ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            SectionHeader(
              title: strings.noiseControl,
              subtitle: strings.noiseControlSubtitle,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AncSelector(
                  selected: session.ancMode,
                  busy: _ancBusy || !interactive,
                  onSelected: _setAnc,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: strings.equalizer),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: EqPresetSelector(
                  presets: features.eqPresets,
                  selectedIndex: s.eqPresetIndex,
                  enabled: interactive,
                  onSelected: (i) => _run(
                    () => ref.read(bleControllerProvider).setEqPreset(i),
                    'EQ',
                  ),
                ),
              ),
            ),
            if (features.eq != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: interactive
                      ? () => context.push('/device/eq')
                      : null,
                  icon: const Icon(Icons.tune),
                  label: Text(strings.customizeBands),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SectionHeader(title: strings.audio),
            SettingsCard(
              children: [
                ListTile(
                  title: Text(strings.volume),
                  subtitle: Text(
                    '${strings.left} ${s.volumeLeft}% · ${strings.right} ${s.volumeRight}%',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: s.volumeLeft.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: '${strings.left} ${s.volumeLeft}',
                          onChanged: interactive
                              ? (v) => ref
                                  .read(bleControllerProvider)
                                  .setVolume(v.round(), s.volumeRight)
                              : null,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: s.volumeRight.toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: '${strings.right} ${s.volumeRight}',
                          onChanged: interactive
                              ? (v) => ref
                                  .read(bleControllerProvider)
                                  .setVolume(s.volumeLeft, v.round())
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                if (features.channelBalance)
                  ListTile(
                    title: Text(strings.channelBalance),
                    subtitle: Slider(
                      value: s.soundBalance.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: s.soundBalance == 50
                          ? strings.center
                          : s.soundBalance < 50
                              ? strings.left
                              : strings.right,
                      onChanged: interactive
                          ? (v) => ref
                              .read(bleControllerProvider)
                              .setSoundBalance(v.round())
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (features.hasKeyFunctions) ...[
              SectionHeader(
                title: strings.controls,
                subtitle: strings.controlsSubtitle,
              ),
              SettingsCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.touch_app_outlined),
                    title: Text(strings.touchControls),
                    subtitle: Text(strings.tapTypes),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: interactive
                        ? () => context.push('/device/keys')
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            if (features.autoOffTimer != null) ...[
              SectionHeader(
                title: strings.power,
                subtitle: strings.powerSubtitle,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AutoOffSelector(
                    selectedMinutes: s.autoOffMinutes,
                    disabledMinutes: features.autoOffTimer!.disabledMinutes,
                    enabled: interactive,
                    onSelected: (m) => _run(
                      () =>
                          ref.read(bleControllerProvider).setAutoOffMinutes(m),
                      strings.autoPowerOff,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            SectionHeader(title: strings.features),
            SettingsCard(
              children: [
                SwitchListTile(
                  title: Text(strings.gamingMode),
                  subtitle: Text(strings.lowLatency),
                  value: s.gameMode,
                  onChanged: interactive
                      ? (v) => _run(
                            () =>
                                ref.read(bleControllerProvider).setGameMode(v),
                            strings.gamingMode,
                          )
                      : null,
                ),
                if (features.ldac)
                  SwitchListTile(
                    title: const Text('LDAC'),
                    subtitle: Text(strings.highQualityCodec),
                    value: s.ldac,
                    onChanged: interactive
                        ? (v) => _run(
                              () => ref.read(bleControllerProvider).setLdac(v),
                              'LDAC',
                            )
                        : null,
                  ),
                if (features.sleepMode)
                  SwitchListTile(
                    title: Text(strings.sleepMode),
                    value: s.sleepMode,
                    onChanged: interactive
                        ? (v) => _run(
                              () =>
                                  ref.read(bleControllerProvider).setSleepMode(v),
                              strings.sleepMode,
                            )
                        : null,
                  ),
                if (features.spatialAudio)
                  SwitchListTile(
                    title: Text(strings.spatialAudio),
                    value: s.spatialAudio,
                    onChanged: interactive
                        ? (v) => _run(
                              () => ref
                                  .read(bleControllerProvider)
                                  .setSpatialAudio(v),
                              strings.spatialAudio,
                            )
                        : null,
                  ),
                if (features.inEarDetection)
                  SwitchListTile(
                    title: Text(strings.inEarDetection),
                    value: s.inEarDetection,
                    onChanged: interactive
                        ? (v) => _run(
                              () => ref
                                  .read(bleControllerProvider)
                                  .setInEarDetection(v),
                              strings.inEarDetection,
                            )
                        : null,
                  ),
                if (features.dualDevice)
                  SwitchListTile(
                    title: Text(strings.dualDeviceConnection),
                    value: s.dualDevice,
                    onChanged: interactive
                        ? (v) => _run(
                              () =>
                                  ref.read(bleControllerProvider).setDualDevice(v),
                              strings.dualDeviceConnection,
                            )
                        : null,
                  ),
                if (features.findEarphone)
                  ListTile(
                    leading: const Icon(Icons.location_searching),
                    title: Text(strings.findEarbuds),
                    onTap: interactive ? _showFindEarbuds : null,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SectionHeader(title: strings.device),
            SettingsCard(
              children: [
                if (features.deviceRename)
                  ListTile(
                    leading: const Icon(Icons.drive_file_rename_outline),
                    title: Text(strings.rename),
                    onTap: interactive ? _renameDevice : null,
                  ),
                ListTile(
                  leading: Icon(Icons.restart_alt, color: scheme.error),
                  title: Text(strings.resetToDefaults),
                  onTap: interactive
                      ? () async {
                          if (await confirmAction(
                            context,
                            title: strings.resetSettingsTitle,
                            message: strings.resetSettingsMessage,
                            confirm: strings.reset,
                            cancel: strings.cancel,
                          )) {
                            await _run(
                              () => ref
                                  .read(bleControllerProvider)
                                  .resetToDefault(),
                              strings.reset,
                            );
                          }
                        }
                      : null,
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: scheme.error),
                  title: Text(strings.factoryReset),
                  onTap: interactive
                      ? () async {
                          if (await confirmAction(
                            context,
                            title: strings.factoryResetTitle,
                            message: strings.factoryResetMessage,
                            confirm: strings.reset,
                            cancel: strings.cancel,
                            destructive: true,
                          )) {
                            await _run(
                              () => ref
                                  .read(bleControllerProvider)
                                  .factoryReset(),
                              strings.factoryReset,
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
            if (session.errorMessage != null) ...[
              const SizedBox(height: 16),
              MaterialBanner(
                content: Text(
                  strings.localizeErrorMessage(session.errorMessage!),
                ),
                actions: [
                  TextButton(
                    onPressed: () => _run(
                      () => session.phase == ConnectionPhase.error
                          ? ble.retryReconnect()
                          : ble.connect(session.device),
                      strings.reconnect,
                    ),
                    child: Text(strings.retry),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BatteryCard extends StatelessWidget {
  const _BatteryCard({required this.battery});

  final BatteryLevels? battery;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: battery == null
            ? const Center(child: CircularProgressIndicator())
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BatteryRing(
                    label: strings.leftEarbud,
                    level: battery!.left,
                    charging: battery!.leftCharging,
                  ),
                  BatteryRing(
                    label: strings.rightEarbud,
                    level: battery!.right,
                    charging: battery!.rightCharging,
                  ),
                  if (battery!.hasCase)
                    BatteryRing(
                      label: strings.caseLabel,
                      level: battery!.caseLevel!,
                      charging: battery!.caseCharging,
                      icon: Icons.inventory_2_outlined,
                    ),
                ],
              ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.session});

  final DeviceSession session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final strings = context.strings;
    final (label, color, icon) = switch (session.phase) {
      ConnectionPhase.connected => (
          strings.connected,
          scheme.primaryContainer,
          Icons.link,
        ),
      ConnectionPhase.connecting => (
          session.statusMessage == null
              ? strings.connecting
              : strings.localizeStatusMessage(session.statusMessage),
          scheme.secondaryContainer,
          Icons.bluetooth_connected,
        ),
      ConnectionPhase.reconnecting => (
          session.statusMessage == null
              ? strings.reconnecting
              : strings.localizeStatusMessage(session.statusMessage),
          scheme.secondaryContainer,
          Icons.bluetooth_searching,
        ),
      ConnectionPhase.error => (
          strings.error,
          scheme.errorContainer,
          Icons.error_outline,
        ),
      ConnectionPhase.disconnected => (
          strings.disconnected,
          scheme.surfaceContainerHighest,
          Icons.link_off,
        ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (session.phase == ConnectionPhase.reconnecting ||
              session.phase == ConnectionPhase.connecting)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.onSurface,
                ),
              ),
            )
          else
            Icon(icon, color: scheme.onSurface),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            session.device.modelName,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
