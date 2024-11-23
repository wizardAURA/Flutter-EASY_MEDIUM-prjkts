//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_messaging_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
User? LoggedInUser;


class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

   String? meesageText;
   final textClear = TextEditingController();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curUser();
  }
  void curUser() async{
    try{
    final user = await _auth.currentUser;
   if(user != null){
    LoggedInUser = user;
    print(LoggedInUser?.email);
   }}
        catch(e){
      print(e);
        }
  }
  void messagesStream()async{
      await for( var snapshots in _fireStore.collection('messages').snapshots()){
        for(var messages in snapshots.docs ){
          print(messages.data());
        }
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            streamMessage(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textClear,
                      onChanged: (value) {
                        meesageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textClear.clear();
                      _fireStore.collection('messages').add({
                        'Text': meesageText,
                        'Sender': LoggedInUser?.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });},
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageBubble extends StatelessWidget {
  messageBubble({
    required this.sender,required this.text, required this.isME
});
  final String sender;
  final String text;
  final bool isME;


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: isME? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10
          ),),
          Material(
            borderRadius:isME? BorderRadius.only(topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25)) : BorderRadius.only(topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25.0)),
            elevation: 5.0,
            color: isME? Colors.blue: Colors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ),),
              )),
        ],
      ),
    );
  }
}
class streamMessage extends StatelessWidget {
  const streamMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(stream: _fireStore.collection('messages').orderBy('timestamp').snapshots(),
        builder: (context,snapshot){
          if (snapshot.hasData){
            final messages = snapshot.data?.docs.reversed;
            List<messageBubble>messageWidgets = [];
            for(var message in messages! ){
              final messageDatat = message.data() as Map<String,dynamic>;
              final messageText = messageDatat['Text'];
              final messageDatas =  message.data() as Map<String,dynamic>;
              final messagesender = messageDatas['Sender'];
              final currentUser  = LoggedInUser?.email;
              final messageWidget = messageBubble(sender: messagesender, text: messageText, isME: currentUser == messagesender);



              messageWidgets.add(messageWidget);
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: ListView(
                  reverse: true,
                  children: messageWidgets,
                ),
              ),
            );
          }else {
            // Loading state
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
