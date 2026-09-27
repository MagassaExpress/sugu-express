import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mes_annonces_page.dart';
import '../login_page.dart';
import 'favorites_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Mon Profil"),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(uid)
            .get(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Utilisateur introuvable",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                const SizedBox(height: 20),

              CircleAvatar(
  radius: 60,
  backgroundColor: Colors.orange,
  backgroundImage:
      data['photoProfil'] != null &&
              data['photoProfil'] != ''
          ? NetworkImage(
              data['photoProfil'],
            )
          : null,
  child:
      data['photoProfil'] == null ||
              data['photoProfil'] == ''
          ? const Icon(
              Icons.person,
              size: 70,
              color: Colors.white,
            )
          : null,
),

                const SizedBox(height: 15),

             Text(
  data['nom'] ?? 'Utilisateur',
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

                const SizedBox(height: 8),

                Text(
                  data['email'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (data['enLigne'] ?? false)
                        ? Colors.green
                        : Colors.grey,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    (data['enLigne'] ?? false)
                        ? "En ligne"
                        : "Hors ligne",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Téléphone : ${data['telephone'] ?? ''}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Ville : ${data['ville'] ?? ''}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Dernière connexion : ${data['derniereConnexion'] != null ? (data['derniereConnexion'] as Timestamp).toDate().toString().substring(0,16) : '-'}",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    data['role'] ?? 'Acheteur',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore
                      .instance
                      .collection('annonces')
                      .where(
                        'vendeurId',
                        isEqualTo: uid,
                      )
                      .snapshots(),

                  builder: (context, snapshot) {

                    final total =
                        snapshot.hasData
                            ? snapshot
                                .data!
                                .docs
                                .length
                            : 0;

                    return Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        15,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.orange,
                        borderRadius:
                            BorderRadius
                                .circular(10),
                      ),
                      child: Text(
                        "Mes annonces : $total",
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      // Page Modifier Profil
    },
    icon: const Icon(
      Icons.edit,
      color: Colors.white,
    ),
    label: const Text(
      "Modifier mon profil",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
    ),
  ),
),

const SizedBox(height: 20),
                _menu(
                  Icons.favorite,
                  "Mes favoris",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FavoritesPage(),
                      ),
                    );
                  },
                ),

                _menu(
                  Icons.shopping_bag,
                  "Mes annonces",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MesAnnoncesPage(),
                      ),
                    );
                  },
                ),

                _menu(
                  Icons.settings,
                  "Paramètres",
                ),

                _menu(
                  Icons.help_outline,
                  "Aide",
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton.icon(
                    icon:
                        const Icon(Icons.logout),

                    label: const Text(
                      "Déconnexion",
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.orange,
                    ),

                    onPressed: () async {

                      await FirebaseFirestore
                          .instance
                          .collection(
                              'utilisateurs')
                          .doc(uid)
                          .update({
                        'enLigne': false,
                        'derniereConnexion':
                            Timestamp.now(),
                      });

                      await FirebaseAuth
                          .instance
                          .signOut();

                      Navigator
                          .pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menu(
    IconData icon,
    String titre, {
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(
          icon,
          color: Colors.orange,
        ),

        title: Text(titre),

        trailing: const Icon(
          Icons.arrow_forward_ios,
        ),
      ),
    );
  }
}