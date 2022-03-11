import 'dart:async';

import 'package:audio_chat_app/models/messages.dart';
import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:firebase_database/firebase_database.dart';
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

  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } else {
      Timer(const Duration(milliseconds: 200), () => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref("messages")
                  .child(conversationId)
                  .orderByChild('timestamp')
                  .onValue,
              builder: (BuildContext context,
                  AsyncSnapshot<DatabaseEvent> snapshot) {
                //print(snapshot.data?.snapshot.value);
                List<Message> messages = [];
                if (snapshot.data?.snapshot.value != null) {
                  final json =
                      snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                  json.forEach(
                      (key, value) => messages.add(Message.fromJson(value)));
                  return ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) => MessageCard(
                      message: messages[index],
                      uid: uid,
                    ),
                  );
                } else {
                  return ListView();
                }
              },
            )),
            Row(
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
                    onPressed: () => onSendMessage(textEditingController.text),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      _scrollToBottom();
      // _scrollController.animateTo(
      //   _scrollController.position.maxScrollExtent,
      //   curve: Curves.easeInOut,
      //   duration: const Duration(milliseconds: 200),
      // );
      DatabaseRepository.sendMessage(
        Message(
            date: DateTime.now(),
            timeStamp: (0 - DateTime.now().millisecondsSinceEpoch).toString(),
            content: content,
            idTo: contactId),
        conversationId,
      );
      FocusManager.instance.primaryFocus?.unfocus();
      // listScrollController.animateTo(0.0,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.message,
    required this.uid,
  }) : super(key: key);

  final Message message;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: message.idTo == uid
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Align(
            alignment:
                (message.idTo == uid ? Alignment.topLeft : Alignment.topRight),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (message.idTo == uid
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                message.content!,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Text(
            DateFormat.jm().format(message.date),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
// FirebaseAnimatedList(
//                 controller: _scrollController,
//                 shrinkWrap: true,
//                 reverse: true,
//                 query: FirebaseDatabase.instance
//                     .ref("messages")
//                     .child(conversationId)
//                     .orderByChild('timestamp'),
//                 itemBuilder: (context, snapshot, animation, index) {
//                   final json = snapshot.value as Map<dynamic, dynamic>;
//                   final message = Message.fromJson(json..values);
//                   return MessageCard(message: message, uid: uid);
//                 },
//               ),