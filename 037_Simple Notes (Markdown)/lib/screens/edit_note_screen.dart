import 'package:flutter/material.dart';
import '../models/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const EditNoteScreen({
    super.key,
    this.note,
    required this.onSave,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isPreview = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final now = DateTime.now();
    final note = widget.note?.copyWith(
          title: title,
          content: content,
          updatedAt: now,
        ) ??
        Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          createdAt: now,
          updatedAt: now,
        );

    widget.onSave(note);
    Navigator.pop(context);
  }

  Widget _buildPreview(String content) {
    final lines = content.split('\n');
    return ListView.builder(
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];
        return _buildPreviewLine(line);
      },
    );
  }

  Widget _buildPreviewLine(String line) {
    if (line.startsWith('# ')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          line.substring(2),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (line.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          line.substring(3),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (line.startsWith('### ')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          line.substring(4),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (line.startsWith('> ')) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          line.substring(2),
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey.shade700,
          ),
        ),
      );
    } else if (line.startsWith('- [ ] ')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2.0),
              child: Icon(Icons.check_box_outline_blank, 
                  size: 16, color: Colors.grey.shade600),
            ),
            Expanded(
              child: Text(line.substring(6)),
            ),
          ],
        ),
      );
    } else if (line.startsWith('- ')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2.0),
              child: Text('•', style: TextStyle(color: Colors.grey.shade600)),
            ),
            Expanded(
              child: _buildInlineFormatting(line.substring(2)),
            ),
          ],
        ),
      );
    } else if (line.trim().isEmpty) {
      return const SizedBox(height: 8.0);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: _buildInlineFormatting(line),
      );
    }
  }

  Widget _buildInlineFormatting(String text) {
    // Simple inline formatting parser
    final spans = <TextSpan>[];
    final pattern = RegExp(r'(\*\*.*?\*\*|\*.*?\*|`.*?`)');
    final matches = pattern.allMatches(text);
    
    int currentPosition = 0;
    
    for (final match in matches) {
      // Add normal text before the match
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: text.substring(currentPosition, match.start),
          style: const TextStyle(fontSize: 16),
        ));
      }
      
      final matchedText = match.group(0)!;
      final content = matchedText.substring(1, matchedText.length - 1);
      
      if (matchedText.startsWith('**')) {
        spans.add(TextSpan(
          text: content,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ));
      } else if (matchedText.startsWith('*')) {
        spans.add(TextSpan(
          text: content,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ));
      } else if (matchedText.startsWith('`')) {
        spans.add(TextSpan(
          text: content,
          style: TextStyle(
            backgroundColor: Colors.grey.shade200,
            fontFamily: 'monospace',
            fontSize: 16,
          ),
        ));
      }
      
      currentPosition = match.end;
    }
    
    // Add remaining text
    if (currentPosition < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPosition),
        style: const TextStyle(fontSize: 16),
      ));
    }
    
    return spans.isEmpty 
        ? Text(text, style: const TextStyle(fontSize: 16))
        : RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: Icon(_isPreview ? Icons.edit : Icons.preview),
            onPressed: () {
              setState(() {
                _isPreview = !_isPreview;
              });
            },
            tooltip: _isPreview ? 'Edit mode' : 'Preview mode',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: 'Save note',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Note title...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Markdown Tips (only show in edit mode)
            if (!_isPreview) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Markdown Tips:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 8,
                  children: const [
                    _MarkdownChip(text: '# Header'),
                    _MarkdownChip(text: '## Subheader'),
                    _MarkdownChip(text: '**Bold**'),
                    _MarkdownChip(text: '*Italic*'),
                    _MarkdownChip(text: '- List'),
                    _MarkdownChip(text: '> Quote'),
                    _MarkdownChip(text: '- [ ] Task'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Content Area (Edit or Preview)
            Expanded(
              child: _isPreview
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: _contentController.text.isEmpty
                          ? Center(
                              child: Text(
                                'Start typing to see preview...',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : _buildPreview(_contentController.text),
                    )
                  : TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Write your markdown note here...\n\nExamples:\n# Heading\n**Bold text**\n*Italic text*\n- List item\n> Blockquote\n- [ ] Task item',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

class _MarkdownChip extends StatelessWidget {
  final String text;

  const _MarkdownChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.grey.shade100,
    );
  }
}