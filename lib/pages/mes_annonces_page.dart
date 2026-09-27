import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_annonce_page.dart';
class MesAnnoncesPage extends StatelessWidget {
  const MesAnnoncesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Mes annonces"),
        backgroundColor: Colors.orange,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
    .collection('annonces')
    .where(
      'vendeurId',
      isEqualTo: uid,
    )
    .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Aucune annonce publiée",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          final annonces =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: annonces.length,

            itemBuilder: (context, index) {
              final annonce =
                  annonces[index];

              final data =
                  annonce.data()
                      as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.all(10),

                child: ListTile(
                  title: Text(
                    data['titre'] ?? '',
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        "${data['prix']} FCFA",
                      ),
                      Text(
                        data['categorie'] ??
                            '',
                      ),
                    ],
                  ),

                 trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [

    IconButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
     onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditAnnoncePage(
        annonceId: annonce.id,
        annonce: data,
      ),
    ),
  );
},
    ),

    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () async {
        await FirebaseFirestore.instance
            .collection('annonces')
            .doc(annonce.id)
            .delete();

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Annonce supprimée",
            ),
          ),
        );
      },
    ),
  ],
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