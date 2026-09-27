import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_page.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Recherche"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Rechercher une annonce...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('annonces')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final annonces = snapshot.data!.docs.where((doc) {
                  final data =
                      doc.data() as Map<String, dynamic>;

                  final titre =
                      (data['titre'] ?? '')
                          .toString()
                          .toLowerCase();

                  final categorie =
                      (data['categorie'] ?? '')
                          .toString()
                          .toLowerCase();

                  final prix =
                      (data['prix'] ?? '')
                          .toString()
                          .toLowerCase();

                  return titre.contains(searchText) ||
                      categorie.contains(searchText) ||
                      prix.contains(searchText);
                }).toList();

                if (annonces.isEmpty) {
                  return const Center(
                    child: Text(
                      "Aucun résultat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: annonces.length,
                  itemBuilder: (context, index) {
                   final doc = annonces[index];
final annonce = doc.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
     builder: (_) => DetailsPage(
  annonceId: doc.id,
  vendeurId: annonce['vendeurId'] ?? '',
  vendeurNom: annonce['vendeurNom'] ?? 'Utilisateur',
  ville: annonce['ville'] ?? '',
  title: annonce['titre'] ?? '',
  price: "${annonce['prix']} FCFA",
  description: annonce['description'] ?? '',
  telephone: annonce['telephone'] ?? '',
  whatsapp: annonce['whatsapp'] ?? ''
),
    ),
  );
},
                        leading: const Icon(
                          Icons.store,
                          color: Colors.orange,
                        ),
                        title: Text(
                          annonce['titre'] ?? '',
                        ),
                        subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("${annonce['prix']} FCFA"),

    Text(
      annonce['categorie'] ?? '',
    ),
Text(
  annonce['ville'] ?? '',
),
    const SizedBox(height: 5),

    Row(
      children: [
        const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 16,
        ),

        const SizedBox(width: 4),

        Text(
          "${annonce['favoris'] ?? 0}",
        ),

        const SizedBox(width: 15),

        const Icon(
          Icons.remove_red_eye,
          color: Colors.orange,
          size: 16,
        ),

        const SizedBox(width: 4),

        Text(
          "${annonce['vues'] ?? 0}",
        ),
      ],
    ),
  ],
),
                           
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}