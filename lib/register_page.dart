import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_navigation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  final prenomController =
      TextEditingController();

  final nomController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final telephoneController =
      TextEditingController();

  final villeController =
      TextEditingController();

  String role = "Acheteur";

  bool masquerMotDePasse = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Créer un compte",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            TextField(
              controller: prenomController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                labelText: "Prénom",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: nomController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                labelText: "Nom",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: telephoneController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                labelText: "Téléphone",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: villeController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                labelText:
                    "Ville / Quartier",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  passwordController,
              obscureText:
                  masquerMotDePasse,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  InputDecoration(
                labelText:
                    "Mot de passe",
                labelStyle:
                    const TextStyle(
                  color: Colors.white,
                ),
                suffixIcon:
                    IconButton(
                  icon: Icon(
                    masquerMotDePasse
                        ? Icons
                            .visibility
                        : Icons
                            .visibility_off,
                    color:
                        Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      masquerMotDePasse =
                          !masquerMotDePasse;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            DropdownButtonFormField<
                String>(
              value: role,
              dropdownColor:
                  Colors.black,
              style: const TextStyle(
                color: Colors.white,
              ),
              items: const [
                DropdownMenuItem(
                  value: "Acheteur",
                  child:
                      Text("Acheteur"),
                ),
                DropdownMenuItem(
                  value: "Vendeur",
                  child:
                      Text("Vendeur"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.orange,
                ),

                onPressed: () async {
                  if (prenomController
                          .text
                          .trim()
                          .isEmpty ||
                      nomController
                          .text
                          .trim()
                          .isEmpty ||
                      telephoneController
                          .text
                          .trim()
                          .isEmpty ||
                      villeController
                          .text
                          .trim()
                          .isEmpty ||
                      emailController
                          .text
                          .trim()
                          .isEmpty ||
                      passwordController
                          .text
                          .trim()
                          .isEmpty) {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Veuillez remplir tous les champs",
                        ),
                      ),
                    );
                    return;
                  }

                  try {
                    UserCredential
                        userCredential =
                        await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                      email:
                          emailController
                              .text
                              .trim(),
                      password:
                          passwordController
                              .text
                              .trim(),
                    );

                   await FirebaseFirestore.instance
    .collection('utilisateurs')
    .doc(userCredential.user!.uid)
    .set({
  "nom": nomController.text.trim(),
  "telephone": telephoneController.text.trim(),
  "ville": villeController.text.trim(),
  "email": emailController.text.trim(),
  "role": role,
  "photoProfil": "",
  "enLigne": true,
  "dateCreation": Timestamp.now(),
});

                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Compte créé avec succès",
                        ),
                      ),
                    );

                    Navigator
                        .pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MainNavigation(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          e.message ??
                              "Erreur",
                        ),
                      ),
                    );
                  }
                },

                child: const Text(
                  "Créer mon compte",
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