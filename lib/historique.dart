import 'package:flutter/material.dart';

import 'nouveau.dart';
import 'utils/functions.dart';

class Historique extends StatefulWidget {
  const Historique({Key? key}) : super(key: key);

  @override
  _HistoriqueState createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    print(notes);
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    notes = await loadNotes();
    setState(() {});
  }

  void onSave(String titre, String contenu, DateTime now, [int? index]) {
    setState(() {
      if (index != null) {
        // Modification d'une note existante à l'index
        notes[index] = {
          'titre': titre,
          'contenu': contenu,
          'dateTime': now.toIso8601String(),
        };
        print('Note modifiée à l\'index $index');
      } else {
        // Ajout d'une nouvelle note
        notes.add({
          'titre': titre,
          'contenu': contenu,
          'dateTime': now.toIso8601String(),
        });
        print('Nouvelle note ajoutée');
      }
    });
  }

  void _editer(String titre, String contenu, DateTime dateTime, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Nouveau(
          onSave: (title, content, dateTime, [index]) =>
              _ajoumodif(title, content, dateTime, index),
          titre: titre,
          contenu: contenu,
          existeNotes: notes,
          status: true,
          indexNote: index,  // Passer l'index pour modification
        ),
      ),
    );
  }

  void _ajoumodif(String titre, String contenu, DateTime dateTime, [int? index]) {
    setState(() {
      print("here");
      if (index != null) {
        print('update');
        notes[index] = {
          'titre': titre,
          'contenu': contenu,
          'dateTime': dateTime.toIso8601String(),
        };
      } else {
        notes.add({
          'titre': titre,
          'contenu': contenu,
          'dateTime': dateTime.toIso8601String(),
        });
      }
      triDate(notes);
      enregistrer(notes);
    });
  }

  void _supprimer(int index) async {
    bool? confirmer = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content:
          const Text('Êtes-vous sûr de vouloir supprimer cette note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirmer == true) {
      setState(() {
        notes.removeAt(index);
        triDate(notes); // Trier les notes après suppression
        enregistrer(notes);
      });
    }
  }

  void _supprimerTout() async {
    bool? confirmer = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content:
          const Text('Êtes-vous sûr de vouloir supprimer toutes les notes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirmer == true) {
      setState(() {
        notes.clear();
        enregistrer(notes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent.withOpacity(0.5),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever,
                color: Colors.blueAccent.withOpacity(0.5)),
            onPressed: _supprimerTout,
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
        child: Text("Aucune note n'a encore été enregistrée"),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          String titre = note['titre'] ?? '';
          String contenu = note['contenu'] ?? '';
          DateTime dateTime = DateTime.tryParse(note['dateTime'] ?? '') ??
              DateTime.now();
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(titre.isEmpty ? contenu : titre),
              subtitle: Text(
                '${dateTime.toLocal().toString().split(' ')[1].split('.')[0]} '
                    '${dateTime.toLocal().toString().split(' ')[0]}',
              ),
              // Supprimez l'icône d'édition et utilisez onTap
              onTap: () {
                _editer(
                  note['titre'],
                  note['contenu'],
                  DateTime.parse(note['dateTime']),
                  index,
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.delete,
                    color: Colors.blueAccent.withOpacity(0.5)),
                onPressed: () {
                  _supprimer(index);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Nouveau(
                onSave: _ajoumodif,
                existeNotes: notes,
                status: false,
              ),
            ),
          );
        },
        backgroundColor: Colors.blueAccent.withOpacity(0.5), // Arrière-plan vert
        child: const Icon(Icons.add),
      ),
    );
  }
}
