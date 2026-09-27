import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Colors.orange,
      ),

      body: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
    .collection('conversations')
    .where(
      'participants',
      arrayContains: uid,
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
            return const Center(
              child: Text(
                "Aucune conversation",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          final conversations =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,

            itemBuilder: (context, index) {
              final doc =
                  conversations[index];

              final data =
                  doc.data()
                      as Map<String, dynamic>;
String nomAffiche = '';

if (data['vendeurId'] == uid) {
  nomAffiche =
      data['nomAcheteur'] ?? 'Utilisateur';
} else {
  nomAffiche =
      data['nomVendeur'] ?? 'Utilisateur';
}
              return Card(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor:
                        Colors.orange,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),

                 title: Text(nomAffiche),

                subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      data['dernierMessage'] ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),

    if (data['date'] != null)
      Text(
        TimeOfDay.fromDateTime(
          (data['date'] as Timestamp).toDate(),
        ).format(context),
        style: const TextStyle(
          fontSize: 11,
          color: Colors.grey,
        ),
      ),
  ],
),
             trailing:
    data['nonLu'] != null &&
    data['nonLu'] > 0 &&
    data['nonLuPour'] == uid
        ? CircleAvatar(
            radius: 12,
            backgroundColor: Colors.red,
            child: Text(
              data['nonLu'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )
        : const Icon(
            Icons.arrow_forward_ios,
          ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                     builder: (_) => ChatPage(
  conversationId: doc.id,
  nom: nomAffiche,
), 
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}