import 'package:flutter/material.dart';

import '../core/qcy/key_function.dart';
import '../l10n/app_strings.dart';

class AutoOffSelector extends StatelessWidget {
  const AutoOffSelector({
    super.key,
    required this.selectedMinutes,
    required this.disabledMinutes,
    required this.enabled,
    required this.onSelected,
  });

  final int? selectedMinutes;
  final int disabledMinutes;
  final bool enabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final current = selectedMinutes ?? disabledMinutes;
    final normalized = current >= disabledMinutes ? disabledMinutes : current;
    final strings = context.strings;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: strings.autoPowerOff,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: autoOffPresetMinutes.contains(normalized)
              ? normalized
              : disabledMinutes,
          items: [
            for (final m in autoOffPresetMinutes)
              DropdownMenuItem(
                value: m,
                child: Text(strings.autoOffMinutes(m)),
              ),
          ],
          onChanged: enabled ? (v) => onSelected(v ?? disabledMinutes) : null,
        ),
      ),
    );
  }
}
