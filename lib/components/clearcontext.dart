import 'package:flutter/material.dart';

class ClearContextCard extends StatefulWidget {
  const ClearContextCard({super.key});

  @override
  State<ClearContextCard> createState() => _ClearContextCardState();
}

class _ClearContextCardState extends State<ClearContextCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: ElevatedButton(
        // onPressed: () {},
        onPressed: _addSeparator,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wrap_text),
            Text('  Clear Context'),
          ],
        ),
      ),
    );
  }

  void _addSeparator() {
    // todo
  }
}
