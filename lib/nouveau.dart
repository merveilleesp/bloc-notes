import 'package:flutter/material.dart';

class Nouveau extends StatefulWidget {
  final Function(String, String, DateTime, [int?]) onSave;
  final String? titre;
  final String? contenu;
  final List<Map<String, dynamic>> existeNotes;
  final bool? status;
  final int? indexNote;


  const Nouveau({
    Key? key,
    required this.onSave,
    this.titre,
    this.contenu,
    required this.existeNotes,
    this.status,
    this.indexNote,
  }) : super(key: key);

  @override
  _NouveauState createState() => _NouveauState();
}

class _NouveauState extends State<Nouveau> {
  late TextEditingController _titreController;
  late TextEditingController _contenuController;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.titre ?? '');
    _contenuController = TextEditingController(text: widget.contenu ?? '');
  }

  void _save() {
    String titre = _titreController.text;
    String contenu = _contenuController.text;
    DateTime now = DateTime.now();

    // Vérifier si le titre et le contenu sont vides
    if (titre.isEmpty && contenu.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: const Text('Votre note est vide.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Si l'index est passé, on modifie la note, sinon on ajoute une nouvelle note
    if (widget.status == true && widget.indexNote != null) {
      // Modifier la note existante
      widget.onSave(titre, contenu, now, widget.indexNote);
      print('Note modifiée');
    } else {
      // Ajouter une nouvelle note
      widget.onSave(titre, contenu, now);
      print('Nouvelle note ajoutée');
    }

    Navigator.pop(context);  // Fermer l'écran après l'enregistrement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                hintText: 'Titre',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: TextField(
                controller: _contenuController,
                decoration: const InputDecoration(
                  hintText: 'Écrivez votre note ici...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
