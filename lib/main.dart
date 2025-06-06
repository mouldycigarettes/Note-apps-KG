import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Catatan',
      home: NoteListPage(),
    );
  }
}

// Model Catatan
class Note {
  String id;
  String title;
  String content;

  Note({required this.id, required this.title, required this.content});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
      );
}

// Helper Penyimpanan Lokal
class NoteStorage {
  static const String _prefsKey = 'notes';

  static Future<List<Note>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contents = prefs.getString(_prefsKey);
      if (contents == null) return [];
      final loaded = json.decode(contents);
      if (loaded is List) {
        return loaded
            .map((item) => Note.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      return [];
    } catch (e) {
      // print("Error loading notes: $e");
      return [];
    }
  }

  static Future<void> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = json.encode(notes.map((note) => note.toJson()).toList());
      await prefs.setString(_prefsKey, notesJson);
    } catch (e) {
      // print("Error saving notes: $e");
    }
  }
}

// Halaman Daftar Catatan
class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Note> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final loadedNotes = await NoteStorage.loadNotes();
    setState(() {
      notes = loadedNotes;
      isLoading = false;
    });
  }

  void _addNote(Note newNote) {
    setState(() {
      notes.add(newNote);
    });
    NoteStorage.saveNotes(notes);
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
    NoteStorage.saveNotes(notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Catatan')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(child: Text('Belum ada catatan'))
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(notes[index].title),
                      subtitle: Text(
                        notes[index].content.length > 50
                            ? '${notes[index].content.substring(0, 50)}...'
                            : notes[index].content,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNote(index),
                      ),
                      onTap: () async {
                        final updatedNote = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailPage(note: notes[index]),
                          ),
                        );
                        if (updatedNote != null && updatedNote is Note) {
                          setState(() {
                            notes[index] = updatedNote;
                          });
                          NoteStorage.saveNotes(notes);
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteDetailPage()),
          );
          if (newNote != null) {
            _addNote(newNote);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Halaman Detail Catatan
class NoteDetailPage extends StatefulWidget {
  final Note? note;
  NoteDetailPage({this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (titleController.text.isEmpty && contentController.text.isEmpty) {
                return; // Tidak menyimpan jika kosong
              }
              if (widget.note == null) {
                // Tambah catatan baru
                String id = uuid.v4();
                Note newNote = Note(
                  id: id,
                  title: titleController.text,
                  content: contentController.text,
                );
                Navigator.pop(context, newNote);
              } else {
                // Edit catatan yang ada
                widget.note!.title = titleController.text;
                widget.note!.content = contentController.text;
                Navigator.pop(context, widget.note);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Isi Catatan'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}