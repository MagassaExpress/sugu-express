import 'package:flutter/material.dart';
import 'publish_page.dart';
import 'widgets/banner_slider.dart';
import 'widgets/category_card.dart';
import 'widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String recherche = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HEADER

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "IKA SUGU",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Le marché du Mali",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    const Icon(
                      Icons.notifications,
                      color: Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // RECHERCHE

               TextField(
  onChanged: (value) {
    setState(() {
      recherche = value.toLowerCase();
    });
  },
  decoration: InputDecoration(
    hintText: "Que recherchez-vous ?",
    filled: true,
    fillColor: Colors.white,
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
),

                const SizedBox(height: 20),

                // BANNIERE

                const BannerSlider(),

                const SizedBox(height: 25),

                const Text(
                  "Catégories",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                GridView.count(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,

                  children: const [

                    CategoryCard(
                      icon: Icons.pets,
                      title: "Élevage",
                    ),

                    CategoryCard(
                      icon: Icons.directions_car,
                      title: "Auto",
                    ),

                    CategoryCard(
                      icon: Icons.motorcycle,
                      title: "Moto",
                    ),

                    CategoryCard(
                      icon: Icons.house,
                      title: "Immobilier",
                    ),

                    CategoryCard(
                      icon: Icons.car_rental,
                      title: "Location",
                    ),

                    CategoryCard(
                      icon: Icons.checkroom,
                      title: "Mode",
                    ),

                    CategoryCard(
                      icon: Icons.build,
                      title: "Services",
                    ),

                    CategoryCard(
                      icon: Icons.work,
                      title: "Emploi",
                    ),
                  ],
                ),

                const SizedBox(height: 25),

Container(
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white10,
    borderRadius: BorderRadius.circular(15),
  ),
  child: const Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Column(
        children: [
          Icon(Icons.verified, color: Colors.orange),
          SizedBox(height: 5),
          Text(
            "Vendeurs\nVérifiés",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      Column(
        children: [
          Icon(Icons.location_on, color: Colors.orange),
          SizedBox(height: 5),
          Text(
            "Près de\nchez vous",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      Column(
        children: [
          Icon(Icons.support_agent, color: Colors.orange),
          SizedBox(height: 5),
          Text(
            "Support\n24/7",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ],
  ),
),

const SizedBox(height: 25),
                const Text(
                  "Annonces Premium",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 220,

                  child: ListView(
                    scrollDirection:
                        Axis.horizontal,

                    children: const [

  ProductCard(
    title: "Vache gestante",
    price: "850 000 FCFA",
    icon: Icons.pets,
  ),

  ProductCard(
    title: "Toyota Prado",
    price: "32 000 000 FCFA",
    icon: Icons.directions_car,
  ),

  ProductCard(
    title: "Villa à louer",
    price: "500 000 FCFA",
    icon: Icons.house,
  ),

  ProductCard(
    title: "Moto TVS",
    price: "1 200 000 FCFA",
    icon: Icons.motorcycle,
  ),
],
                  ),
                ),

                const SizedBox(height: 25),

              const Text(
  "Dernières annonces",
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('annonces')
      .orderBy(
        'date',
        descending: true,
      )
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
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Aucune annonce disponible",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    final annonces = snapshot.data!.docs;

    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: annonces.length,
     itemBuilder: (context, index) {
final doc = annonces[index];
final annonce = doc.data() as Map<String, dynamic>;
 

final titre =
    (annonce['titre'] ?? '')
        .toString()
        .toLowerCase();

final categorie =
    (annonce['categorie'] ?? '')
        .toString()
        .toLowerCase();

final prix =
    (annonce['prix'] ?? '')
        .toString()
        .toLowerCase();

if (recherche.isNotEmpty &&
    !titre.contains(recherche) &&
    !categorie.contains(recherche) &&
    !prix.contains(recherche)) {
  return const SizedBox.shrink();
} 

  return Card(
          margin:
              const EdgeInsets.only(bottom: 10),
          child: ListTile(
  onTap: () async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final dejaVu = await FirebaseFirestore.instance
      .collection('vues')
      .where('userId', isEqualTo: uid)
      .where('annonceId', isEqualTo: annonces[index].id)
      .get();

  if (dejaVu.docs.isEmpty) {
    await FirebaseFirestore.instance
        .collection('vues')
        .add({
      'userId': uid,
      'annonceId': annonces[index].id,
      'date': Timestamp.now(),
    });

    await FirebaseFirestore.instance
        .collection('annonces')
        .doc(annonces[index].id)
        .update({
      'vues': FieldValue.increment(1),
    });
  }

  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailsPage(
      annonceId: doc.id,
     vendeurId: annonce['vendeurId'] ?? '', 
      vendeurNom: annonce['vendeurNom'] ?? '',
      ville: annonce['ville'] ?? '',
      title: annonce['titre'] ?? '',
      price: "${annonce['prix']} FCFA",
      description: annonce['description'] ?? '',
      telephone: annonce['telephone'] ?? '',
      whatsapp: annonce['whatsapp'] ?? '',
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
    Text(
      "${annonce['prix']} FCFA",
    ),

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
          size: 18,
        ),

        const SizedBox(width: 4),

        Text(
          "${annonce['favoris'] ?? 0}",
        ),

        const SizedBox(width: 15),

        const Icon(
          Icons.remove_red_eye,
          color: Colors.orange,
          size: 18,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}