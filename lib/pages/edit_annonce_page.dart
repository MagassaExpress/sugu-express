import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAnnoncePage extends StatefulWidget {
  final String annonceId;
  final Map<String, dynamic> annonce;

  const EditAnnoncePage({
    super.key,
    required this.annonceId,
    required this.annonce,
  });

  @override
  State<EditAnnoncePage> createState() =>
      _EditAnnoncePageState();
}

class _EditAnnoncePageState
    extends State<EditAnnoncePage> {
  late TextEditingController titreController;
  late TextEditingController prixController;
  late TextEditingController telephoneController;
  late TextEditingController whatsappController;
  late TextEditingController descriptionController;

  late String categorie;

  @override
  void initState() {
    super.initState();

    titreController = TextEditingController(
      text: widget.annonce['titre'] ?? '',
    );

    prixController = TextEditingController(
      text: widget.annonce['prix'].toString(),
    );

    telephoneController = TextEditingController(
      text: widget.annonce['telephone'] ?? '',
    );

    whatsappController = TextEditingController(
      text: widget.annonce['whatsapp'] ?? '',
    );

    descriptionController =
        TextEditingController(
      text: widget.annonce['description'] ?? '',
    );

    categorie =
        widget.annonce['categorie'] ?? 'Auto';
  }

  Future<void> modifierAnnonce() async {
    await FirebaseFirestore.instance
        .collection('annonces')
        .doc(widget.annonceId)
        .update({
      'titre': titreController.text.trim(),
      'prix': int.tryParse(
            prixController.text.trim(),
          ) ??
          0,
      'telephone':
          telephoneController.text.trim(),
      'whatsapp':
          whatsappController.text.trim(),
      'description':
          descriptionController.text.trim(),
      'categorie': categorie,
    });

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Annonce modifiée avec succès",
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          "Modifier annonce",
        ),
        backgroundColor: Colors.orange,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: titreController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "Titre",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: prixController,
              keyboardType:
                  TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "Prix",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  telephoneController,
              keyboardType:
                  TextInputType.phone,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "Téléphone",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  whatsappController,
              keyboardType:
                  TextInputType.phone,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "WhatsApp",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: categorie,
              dropdownColor: Colors.black,
              style: const TextStyle(
                color: Colors.white,
              ),
              items: const [
                DropdownMenuItem(
                  value: "Auto",
                  child: Text("Auto"),
                ),
                DropdownMenuItem(
                  value: "Moto",
                  child: Text("Moto"),
                ),
                DropdownMenuItem(
                  value: "Immobilier",
                  child: Text("Immobilier"),
                ),
                DropdownMenuItem(
                  value: "Élevage",
                  child: Text("Élevage"),
                ),
                DropdownMenuItem(
                  value: "Services",
                  child: Text("Services"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  categorie = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  descriptionController,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: modifierAnnonce,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange,
                ),
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}