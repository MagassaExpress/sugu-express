import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final titreController = TextEditingController();
  final prixController = TextEditingController();
  final descriptionController = TextEditingController();
  final telephoneController = TextEditingController();
  final whatsappController = TextEditingController();
final villeController = TextEditingController();
  String categorie = "Auto";

  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Publier une annonce"),
        backgroundColor: Colors.orange,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: titreController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Titre",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: prixController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Prix",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: telephoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Téléphone",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: whatsappController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "WhatsApp",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

          const SizedBox(height: 15),

TextField(
  controller: villeController,
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
    labelText: "Ville / Quartier",
    labelStyle: TextStyle(color: Colors.white),
  ),
),

const SizedBox(height: 15),

DropdownButtonFormField<String>(
              value: categorie,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
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
              controller: descriptionController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () async {
                  if (titreController.text.trim().isEmpty ||
                      prixController.text.trim().isEmpty ||
                      telephoneController.text.trim().isEmpty ||
                      whatsappController.text.trim().isEmpty ||
                      descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Veuillez remplir tous les champs",
                        ),
                      ),
                    );
                    return;
                  }

                  try {
                  final uid = FirebaseAuth.instance.currentUser!.uid;

final userDoc = await FirebaseFirestore.instance
    .collection('utilisateurs')
    .doc(uid)
    .get();

final userData =
    userDoc.data() as Map<String, dynamic>;


final vendeurNom =
    "${userData['prenom'] ?? ''} ${userData['nom'] ?? ''}";

final vendeurEmail =
    userData['email'] ?? '';
                   await firebaseService.annonces().add({
  "titre": titreController.text.trim(),
  "prix": int.tryParse(
        prixController.text.trim(),
      ) ??
      0,
  "telephone": telephoneController.text.trim(),
  "whatsapp": whatsappController.text.trim(),
  "description": descriptionController.text.trim(),
  "categorie": categorie,
"ville": villeController.text.trim(),
 "vendeurId": uid,
  "vendeurNom": vendeurNom,
"vendeurEmail": vendeurEmail,
  "date": Timestamp.now(),
  "vues": 0,
  "favoris": 0,
});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Annonce publiée avec succès",
                        ),
                      ),
                    );

                    titreController.clear();
                    prixController.clear();
                    telephoneController.clear();
                    whatsappController.clear();
                    villeController.clear();
                    descriptionController.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Erreur : $e",
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Publier",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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