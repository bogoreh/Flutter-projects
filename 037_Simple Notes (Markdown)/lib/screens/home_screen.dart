import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  final TextEditingController _searchController = TextEditingController();
  List<Note> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _searchController.addListener(_filterNotes);
  }

  void _loadNotes() {
    // For demo purposes, we'll create some sample notes
    // In a real app, you'd load from shared preferences or database
    setState(() {
      notes = [
        Note(
          id: '1',
          title: 'Welcome Note',
          content: '''
# Welcome to Simple Notes!

This is a **markdown** notes app.

## Features:
- Create notes
- Edit in markdown
- Beautiful preview
- Search functionality

*Enjoy using the app!*
          ''',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Note(
          id: '2',
          title: 'Shopping List',
          content: '''
## Grocery List

- [ ] Milk
- [ ] Eggs
- [ ] Bread
- [ ] Fruits
  - Apples
  - Bananas
  - Oranges

> Don't forget the discounts!
          ''',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
      filteredNotes = notes;
    });
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredNotes = notes;
      });
    } else {
      setState(() {
        filteredNotes = notes.where((note) {
          return note.title.toLowerCase().contains(query) ||
              note.content.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  void _addNewNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(
          onSave: (newNote) {
            setState(() {
              notes.insert(0, newNote);
              _filterNotes();
            });
          },
        ),
      ),
    );
  }

  void _editNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(
          note: note,
          onSave: (updatedNote) {
            setState(() {
              final index = notes.indexWhere((n) => n.id == updatedNote.id);
              if (index != -1) {
                notes[index] = updatedNote;
                _filterNotes();
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteNote(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notes.removeWhere((note) => note.id == id);
                _filterNotes();
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No notes found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return NoteCard(
                        note: note,
                        onTap: () => _editNote(note),
                        onDelete: () => _deleteNote(note.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}