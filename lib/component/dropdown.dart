import 'package:flutter/material.dart';

class LanguageDropdown extends StatefulWidget {
  final List<String> options;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const LanguageDropdown({
    super.key,
    required this.options,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.pink],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          dropdownColor: Colors.purple, // dropdown menu background
          style: const TextStyle(
            fontFamily: "Outfit",
            fontWeight: FontWeight.w600,
            color: Colors.white, // text color
            fontSize: 16,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => selectedValue = newValue);
              widget.onChanged(newValue);
            }
          },
          items: widget.options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Colors.white), // visible text
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
