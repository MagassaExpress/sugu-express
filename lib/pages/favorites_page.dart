import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Mes favoris"),
      ),

      body: StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance
    .collection('favoris')
    .where('userId', isEqualTo: uid)
    .snapshots(), 

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Aucun favori",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          final favoris = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoris.length,

            itemBuilder: (context, index) {
              final favori = favoris[index];

              final data =
                  favori.data()
                      as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  title: Text(
                    data['titre'] ?? '',
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
  "${data['prix']} FCFA",
),
                      Text(
                        data['telephone'] ?? '',
                      ),
                    ],
                  ),

                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
onPressed: () async {
  if (data['annonceId'] != null) {
    await FirebaseFirestore.instance
        .collection('annonces')
        .doc(data['annonceId'])
        .update({
      'favoris': FieldValue.increment(-1),
    });
  }

  await FirebaseFirestore.instance
      .collection('favoris')
      .doc(favori.id)
      .delete();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "Favori supprimé",
      ),
    ),
  );
},
                    
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}