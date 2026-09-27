import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';
class DetailsPage extends StatelessWidget {
  final String annonceId;
  final String vendeurNom;
  final String ville;
  final String title;
  final String price;
  final String description;
  final String telephone;
  final String whatsapp;
final String vendeurId;
 const DetailsPage({
  super.key,
  required this.annonceId,
  required this.vendeurNom,
   required this.ville,
  required this.title,
  required this.price,
  required this.description,
  required this.telephone,
  required this.whatsapp,
  required this.vendeurId,
});
  Future<void> appeler() async {
    final Uri url = Uri(
      scheme: 'tel',
      path: telephone,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> ouvrirWhatsapp() async {
    final Uri url = Uri.parse(
      'https://wa.me/$whatsapp',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
Future<void> ajouterVue() async {
  await FirebaseFirestore.instance
      .collection('annonces')
      .doc(annonceId)
      .update({
    'vues': FieldValue.increment(1),
  });
}
 Future<void> ajouterAuxFavoris() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final existe = await FirebaseFirestore.instance
      .collection('favoris')
      .where('userId', isEqualTo: uid)
      .where('annonceId', isEqualTo: annonceId)
      .get();

  if (existe.docs.isNotEmpty) {
    return;
  }

  await FirebaseFirestore.instance
      .collection('favoris')
      .add({
    'userId': uid,
    'annonceId': annonceId,
    'titre': title,
    'prix': price,
    'description': description,
    'telephone': telephone,
    'whatsapp': whatsapp,
    'date': Timestamp.now(),
  });

  await FirebaseFirestore.instance
      .collection('annonces')
      .doc(annonceId)
      .update({
    'favoris': FieldValue.increment(1),
  });
}
Future<void> ouvrirConversation(
    BuildContext context) async {
  final uid =
      FirebaseAuth.instance.currentUser!.uid;

  final resultat = await FirebaseFirestore
      .instance
      .collection('conversations')
      .where(
        'participants',
        arrayContains: uid,
      )
      .get();

  String? conversationId;

  for (var doc in resultat.docs) {
    final data =
        doc.data() as Map<String, dynamic>;

    final participants =
        List<String>.from(
      data['participants'] ?? [],
    );
if (participants.contains(uid) &&
    participants.contains(vendeurId)) {
  conversationId = doc.id;
  break;
}
   
  }

 if (conversationId == null) {

  final userDoc = await FirebaseFirestore.instance
      .collection('utilisateurs')
      .doc(uid)
      .get();

  final userData =
      userDoc.data() as Map<String, dynamic>;

  final monNom =
      "${userData['prenom'] ?? ''} ${userData['nom'] ?? ''}";

  final nouvelleConversation =
      await FirebaseFirestore.instance
          .collection('conversations')
          .add({
    'vendeurId': vendeurId,

    'participants': [
      uid,
      vendeurId,
    ],

    'nomVendeur': vendeurNom,
    'nomAcheteur': monNom,

    'dernierMessage': '',
    'date': Timestamp.now(),

    'nonLu': 0,
    'nonLuPour': '',

    'dernierExpediteur': '',
  });

 
    conversationId =
        nouvelleConversation.id;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ChatPage(
        conversationId: conversationId!,
        nom: vendeurNom,
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Détails"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                price,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),


const SizedBox(height: 10),

Text(
  "Vendeur : $vendeurNom",
  style: const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 8),

Text(
  "Localisation : $ville",
  style: const TextStyle(
    color: Colors.white70,
    fontSize: 16,
  ),
),
const SizedBox(height: 15),
              const SizedBox(height: 15),

StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('annonces')
      .doc(annonceId)
      .snapshots(),
  builder: (context, snapshot) {

    int favoris = 0;
    int vues = 0;

    if (snapshot.hasData &&
        snapshot.data!.exists) {
      final data =
          snapshot.data!.data()
              as Map<String, dynamic>;

      favoris = data['favoris'] ?? 0;
      vues = data['vues'] ?? 0;
    }

    return Row(
      children: [
        const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        const SizedBox(width: 5),
        Text(
          "$favoris favoris",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 25),

        const Icon(
          Icons.remove_red_eye,
          color: Colors.orange,
        ),
        const SizedBox(width: 5),
        Text(
          "$vues vues",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  },
),

const SizedBox(height: 20),
              Text(
                "Téléphone : $telephone",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

            Text(
  "WhatsApp : $whatsapp",
  style: const TextStyle(
    color: Colors.white,
    fontSize: 16,
  ),
),

const SizedBox(height: 20),

const Text(
  "Description",
  style: TextStyle(
    color: Colors.orange,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Text(
  description,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 16,
  ),
),

const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
               onPressed: () async {
  await ajouterAuxFavoris();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Annonce ajoutée aux favoris ❤️",
      ),
    ),
  );
},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Ajouter aux favoris",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 20),
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      ouvrirConversation(context);
    },
    icon: const Icon(
      Icons.message,
      color: Colors.white,
    ),
    label: const Text(
      "Contacter le vendeur",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
    ),
  ),
),

const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: appeler,
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Appeler",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: ouvrirWhatsapp,
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "WhatsApp",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}