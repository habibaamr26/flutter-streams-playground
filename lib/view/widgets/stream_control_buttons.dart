import 'package:flutter/material.dart';
import 'package:stream_test/view_model/blog_view_model.dart';

enum StreamAction { pause, resume, cancel }

/// Pause / Resume / Cancel. Only one can be selected at a time.
class StreamControlButtons extends StatefulWidget {
  final BlogViewModel blogViewModel;

  const StreamControlButtons({super.key, required this.blogViewModel});

  @override
  State<StreamControlButtons> createState() => _StreamControlButtonsState();
}

class _StreamControlButtonsState extends State<StreamControlButtons> {
  StreamAction? _selectedAction;

  void _onActionPressed(StreamAction action) {
    final viewModel = widget.blogViewModel;

    switch (action) {
      case StreamAction.pause:
        viewModel.pauseStream();
      case StreamAction.resume:
        viewModel.resumeStream();
      case StreamAction.cancel:
        viewModel.cancelStream();
    }

    setState(() => _selectedAction = action);
  }

  @override
  Widget build(BuildContext context) {
    // After cancel the stream is closed, so all buttons are disabled.
    final isClosed = widget.blogViewModel.isClosed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _StreamActionButton(
              label: 'Pause',
              icon: Icons.pause,
              isSelected: _selectedAction == StreamAction.pause,
              onPressed:
                  isClosed ? null : () => _onActionPressed(StreamAction.pause),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StreamActionButton(
              label: 'Resume',
              icon: Icons.play_arrow,
              isSelected: _selectedAction == StreamAction.resume,
              onPressed:
                  isClosed ? null : () => _onActionPressed(StreamAction.resume),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StreamActionButton(
              label: 'Cancel',
              icon: Icons.close,
              isSelected: _selectedAction == StreamAction.cancel,
              onPressed:
                  isClosed ? null : () => _onActionPressed(StreamAction.cancel),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreamActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onPressed;

  const _StreamActionButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      icon: Icon(icon),
      label: FittedBox(child: Text(label)),
    );
  }
}
