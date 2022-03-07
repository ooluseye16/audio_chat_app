import 'package:audio_chat_app/models/messages.dart';
import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(
      {Key? key,
      required this.contactId,
      required this.uid,
      required this.conversationId,
      this.displayName})
      : super(key: key);
  //final UserDetails contact;
  final String contactId;
  final String uid;
  final String? displayName;
  final String conversationId;

  final List<Message> listOfMessages = [];
  final textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          displayName ?? '',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FirebaseAnimatedList(
                controller: _scrollController,
                query: FirebaseDatabase.instance
                    .ref("messages")
                    .child(conversationId)
                    .ref
                    .orderByChild('timestamp'),
                itemBuilder: (context, snapshot, animation, index) {
                  final json = snapshot.value as Map<dynamic, dynamic>;
                  final message = Message.fromJson(json..values);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: message.idTo == uid
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey,
                        padding: const EdgeInsets.all(8.0),
                        constraints: const BoxConstraints(maxWidth: 200.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(message.content!),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              DateFormat.jm().format(message.date),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  );
                },
              ),
              //
              // StreamBuilder(
              //   stream: FirebaseDatabase.instance
              //       .ref("messages")
              //       .child(conversationId)
              //       .ref
              //       .orderByChild('timestamp')
              //       .limitToFirst(20)
              //       .onValue,
              //   builder:
              //       (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
              //         listOfMessages.clear();
              //     if (snapshot.hasData) {
              //       var values =
              //           snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
              //       if (values != null) {
              //         log(values.toString());
              //         values.forEach((key, value) {

              //           listOfMessages.add(Message.fromJson(value));
              //         });

              //         //listOfMessages.clear();
              //       }

              //       return ListView.builder(
              //         padding: const EdgeInsets.all(10.0),
              //         itemBuilder: (BuildContext context, int index) =>
              //             Text(listOfMessages[index].message!),
              //         itemCount: listOfMessages.length,
              //         reverse: true,
              //         // controller: listScrollController,
              //       );
              //     } else {
              //       return Container();
              //     }
              //   },
              // )
            ),
            SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // Edit text
                      Flexible(
                        child: TextField(
                          //autofocus: true,
                          maxLines: 1,
                          controller: textEditingController,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Type your message...',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.send, size: 25),
                          onPressed: () =>
                              onSendMessage(textEditingController.text),
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                height: 100.0)
          ],
        ),
      ),
    );
  }

  onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      DatabaseRepository.sendMessage(
        Message(
            date: DateTime.now(),
            timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
            content: content,
            idTo: contactId),
        conversationId,
      );
      // listScrollController.animateTo(0.0,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
