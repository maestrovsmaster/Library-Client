import 'package:flutter/material.dart';
import 'package:leeds_library/data/models/reader.dart';


class ReaderWidget extends StatelessWidget {
  final Reader reader;
  final ValueChanged<Reader> onSelect;
  final onShowSelectButton;

  const ReaderWidget({
    super.key,
    required this.reader,
    required this.onSelect,
    this.onShowSelectButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ліва частина: дані
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reader.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    reader.phoneNumber,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 2),
                  Text(
                    reader.email,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),

            if (onShowSelectButton)
            ElevatedButton(
              onPressed: () => onSelect(reader),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              child: Text("Вибрати"),
            ),
          ],
        ),
      ),
    );
  }
}
