import 'package:flutter/material.dart';

class EditBlogDialog extends StatefulWidget {
  final String initialText;
  final ValueChanged<String> onSave;

  const EditBlogDialog({
    super.key,
    required this.initialText,
    required this.onSave,
  });

  @override
  State<EditBlogDialog> createState() => _EditBlogDialogState();
}

class _EditBlogDialogState extends State<EditBlogDialog> {
  // Starts with the old text so the user edits it instead of retyping.
  late final TextEditingController _textController =
      TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_textController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Data'),
      content: TextField(
        controller: _textController,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter new data'),
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Update')),
      ],
    );
  }
}
