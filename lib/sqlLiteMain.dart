

import 'package:flutter/material.dart';
import 'package:tasks/sqlLite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<Map<String, dynamic>> notes = [];
  _loadNotes() async {
    Dbhelper dbhelper = Dbhelper();
    final notelist = await dbhelper.quaryAll();
    setState(() {
      notes = notelist;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notes[index]['title']),
                    subtitle: Text(notes[index]['content']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        Dbhelper dbhelper = Dbhelper();
                        await dbhelper.delete(notes[index]['id']);
                        _loadNotes();
                      },
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'content',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Dbhelper dbhelper = Dbhelper();
                  Note note = Note(
                    id: notes.length + 1,
                    title: _titleController.text,
                    desscription: _contentController.text,
                  );
                  dbhelper.insert(note);
                  _loadNotes();
                },
                child: const Text('Add Note'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}