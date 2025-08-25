import 'package:flutter/material.dart';

class DateTimeField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String? errorText; // 👈

  const DateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.errorText,
  });

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final txt = (value == null)
        ? 'Sélectionner'
        : "${_two(value!.day)}/${_two(value!.month)}/${value!.year} • ${_two(value!.hour)}:${_two(value!.minute)}";
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.schedule_outlined),
          border: const OutlineInputBorder(),
          errorText: errorText, // 👈 affiche l'erreur
        ),
        child: Text(txt),
      ),
    );
  }
}
