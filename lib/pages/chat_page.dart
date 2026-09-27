import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
class ChatPage extends StatefulWidget {
  final String conversationId;
  final String nom;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.nom,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController =
      TextEditingController();
final ScrollController scrollController =
    ScrollController();
   @override
void initState() {
  super.initState();

  FirebaseFirestore.instance
      .collection('conversations')
      .doc(widget.conversationId)
      .update({
    'nonLu': 0,
  });

  final uid =
      FirebaseAuth.instance.currentUser!.uid;

  FirebaseFirestore.instance
      .collection('messages')
      .where(
        'conversationId',
        isEqualTo: widget.conversationId,
      )
      .get()
      .then((snapshot) {
    for (var doc in snapshot.docs) {
      final data =
          doc.data() as Map<String, dynamic>;

      if (data['expediteurId'] != uid) {
        doc.reference.update({
          'lu': true,
        });
      }
    }
  });
}
  Future<void> envoyerMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    final texte = messageController.text.trim();

    await FirebaseFirestore.instance
        .collection('messages')
        .add({
      'conversationId': widget.conversationId,
      'expediteurId': uid,
      'texte': texte,
      'date': Timestamp.now(),
       'lu': false,
    });

 final conversation = await FirebaseFirestore.instance
    .collection('conversations')
    .doc(widget.conversationId)
    .get();

final data =
    conversation.data() as Map<String, dynamic>;

final participants =
    List<String>.from(data['participants']);

String destinataireId = '';

for (var id in participants) {
  if (id != uid) {
    destinataireId = id;
    break;
  }
}

await FirebaseFirestore.instance
    .collection('conversations')
    .doc(widget.conversationId)
    .update({
  'dernierMessage': texte,
  'date': Timestamp.now(),
  'nonLu': FieldValue.increment(1),
  'nonLuPour': destinataireId,
  'dernierExpediteur': uid,
});
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,

    appBar: AppBar(
  backgroundColor: Colors.orange,
  title: StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationId)
        .snapshots(),
    builder: (context, convSnapshot) {

      if (!convSnapshot.hasData) {
        return Text(widget.nom);
      }

      final convData =
          convSnapshot.data!.data()
              as Map<String, dynamic>;

      final uid =
          FirebaseAuth.instance.currentUser!.uid;

      final participants =
          List<String>.from(
        convData['participants'] ?? [],
      );

      String autreUtilisateur = '';

      for (var id in participants) {
        if (id != uid) {
          autreUtilisateur = id;
          break;
        }
      }

      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(autreUtilisateur)
            .snapshots(),
        builder: (context, userSnapshot) {

          bool enLigne = false;

          if (userSnapshot.hasData &&
              userSnapshot.data!.exists) {

            final userData =
                userSnapshot.data!.data()
                    as Map<String, dynamic>;

            enLigne =
                userData['enLigne'] ?? false;
          }

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                widget.nom,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              Text(
                enLigne
                    ? "🟢 En ligne"
                    : "⚫ Hors ligne",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          );
        },
      );
    },
  ),
),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
             stream: FirebaseFirestore.instance
    .collection('messages')
    .where(
      'conversationId',
      isEqualTo: widget.conversationId,
    )
    .orderBy('date')
    .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Aucun message",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                final messages =
                    snapshot.data!.docs;
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (scrollController.hasClients) {
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }
});
                return ListView.builder(
  controller: scrollController,
  padding: const EdgeInsets.all(10),
  itemCount: messages.length,
  itemBuilder: (context, index) {
                    final data =
                        messages[index].data()
                            as Map<String, dynamic>;

                    final estMoi =
                        data['expediteurId'] ==
                            uid;

                    return Align(
                      alignment: estMoi
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(
                          vertical: 4,
                        ),

                        padding:
                            const EdgeInsets.all(
                          12,
                        ),

                        decoration:
                            BoxDecoration(
                          color: estMoi
                              ? Colors.orange
                              : Colors.grey[800],

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),

                        child: Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      data['texte'] ?? '',
      style: const TextStyle(
        color: Colors.white,
      ),
    ),

    const SizedBox(height: 4),

  Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      data['date'] != null
          ? TimeOfDay.fromDateTime(
              (data['date'] as Timestamp).toDate(),
            ).format(context)
          : '',
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 10,
      ),
    ),

    const SizedBox(width: 4),

    Icon(
      data['lu'] == true
          ? Icons.done_all
          : Icons.done,
      size: 14,
      color: data['lu'] == true
          ? Colors.blue
          : Colors.white70,
    ),
  ],
),
  ],
),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            color: Colors.black,

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        messageController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        const InputDecoration(
                      hintText:
                          "Écrire un message...",
                      hintStyle:
                          TextStyle(
                        color:
                            Colors.white70,
                      ),
                    ),

                    onSubmitted: (_) =>
                        envoyerMessage(),
                  ),
                ),

            IconButton(
  icon: const Icon(
    Icons.photo,
    color: Colors.orange,
  ),
  onPressed: () async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Photo sélectionnée : ${image.name}",
          ),
        ),
      );
    }
  },
),   

IconButton(
  onPressed: () {
    // message vocal
  },
  icon: const Icon(
    Icons.mic,
    color: Colors.orange,
  ),
),

IconButton(
  onPressed: envoyerMessage,
  icon: const Icon(
    Icons.send,
    color: Colors.orange,
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}