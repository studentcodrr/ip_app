import 'package:flutter/material.dart';

class InlineTextEditor extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function(String) onSave;

  const InlineTextEditor({
    super.key,
    required this.text,
    required this.style,
    required this.onSave,
  });

  @override
  State<InlineTextEditor> createState() => _InlineTextEditorState();
}

class _InlineTextEditorState extends State<InlineTextEditor> {
  late TextEditingController _ctrl;
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.text);
    
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        _save();
      }
    });
  }

  void _save() {
    if (_ctrl.text != widget.text) {
      widget.onSave(_ctrl.text);
    }
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return SizedBox(
        height: 30,
        width: double.infinity, 
        child: TextField(
          controller: _ctrl,
          focusNode: _focusNode,
          autofocus: true,
          style: widget.style,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 12),
            border: UnderlineInputBorder(),
            isDense: true,
          ),
          onSubmitted: (_) => _save(),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _ctrl.text = widget.text;
        setState(() => _isEditing = true);
      },
      child: Container(
        color: Colors.transparent,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 30),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.text.isEmpty ? "Untitled" : widget.text,
          style: widget.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}