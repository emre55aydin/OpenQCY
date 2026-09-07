import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_strings.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ble = ref.watch(bleControllerProvider);
    final saved = ble.lastDevice;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(strings.autoReconnect),
            subtitle: Text(strings.autoReconnectSubtitle),
            value: ble.autoReconnect,
            onChanged: (v) => ble.setAutoReconnect(v),
          ),
          if (saved != null)
            ListTile(
              title: Text(strings.savedDevice(saved.name)),
              subtitle: Text(saved.id),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  await ble.clearSavedDevice();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.savedDeviceCleared)),
                    );
                  }
                },
              ),
            ),
          const Divider(),
          ListTile(
            title: Text(strings.aboutOpenQcy),
            subtitle: Text(strings.aboutDescription),
          ),
        ],
      ),
    );
  }
}
