import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore =FirebaseFirestore.instance;
User? loggedInUser;
class ChatScreen extends StatefulWidget {
 static String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final _auth =FirebaseAuth.instance;
  final messageTextController=TextEditingController();
  String messageText='';
  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
    final user =await _auth.currentUser;
    if(user!=null){
       loggedInUser=user;
       print(loggedInUser!.email);
    }
  }
  Future<void> getMessagesstream() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _firestore.collection('messages').get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> messages =
        querySnapshot.docs;

    for (var message in messages) {
      print(message.data());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
               // getMessagesstream();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
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
            MessageStream(),
                Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                        {'text':messageText,
                        'sender': loggedInUser!.email},
                      );
                      //Implement send functionality.
                    },
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
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          if (snapshot.hasError) {
            // Handle the error case
            return Text('Error: ${snapshot.error}');
          }
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageBubbles=[];
          for(var message in messages){
            final messageData=message.data() as Map<String, dynamic>;
            final messageText=messageData['text'];
            final messageSender=messageData['sender'];

            final currentUser=loggedInUser!.email;
            if(currentUser==messageSender){

            }

            final messageBubble= MessageBubble(
                sender: messageSender,
                text: messageText,
            isMe:currentUser==messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child:ListView(
              reverse: true,
              padding:EdgeInsets.symmetric(horizontal:10,vertical: 10.0 ),
              children: messageBubbles,
            ),
          );
        }
    );
  }
}
class MessageBubble extends StatelessWidget{
  MessageBubble({required this.sender,required this.text,required this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,style: TextStyle(
            fontSize: 12.0,
            color: Colors.black87
          ),),
          Material(
          borderRadius: isMe?BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0))
            :BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0)),
          elevation: 5.0,
          color:isMe? Colors.lightBlueAccent:Colors.black54,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0 ),
            child: Text(
              text ,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ),]
      ),
    );
  }
}
//StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//   stream: _firestore.collection('messages').snapshots(),
//   builder:(context, snapshot){
//     if (snapshot.hasData) {
//       final messages=snapshot.data;
//       // Process and display the data
//       return Flexible(
//         child: ListView.builder(
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             //:Colors.lightBlueAccent;
//             var messageData = snapshot.data!.docs[index].data();
//             // Render the message using messageData
//             var message = messageData?['text'] as String? ?? '';
//             var Messagesender = messageData?['sender'] as String? ?? '';
//             return Expanded(
//               child: ListTile(
//                // color :Colors.lightBlueAccent,
//               title: Text('$message from $Messagesender',
//               style:TextStyle(
//                  fontSize:20.0,
//                )
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     } else if (snapshot.hasError) {
//       // Handle error state
//       return Text('Error: ${snapshot.error}');
//     }
//     else {
//       // Handle loading state
//       return CircularProgressIndicator();
//     }
//   },
// ),