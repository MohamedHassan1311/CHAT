import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String username;

  Chat({this.chatRoomId, this.username});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: snapshot.data.documents[index].data["message"],
                    isMe: Constants.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now(),
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}"),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          addMessage();
                        },
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.send,
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    this.message,
    this.isMe,
  });

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe
                  ? Colors.black
                  : Theme.of(context).accentTextTheme.title.color,
            ),
          ),
        ),
      ],
    );
  }
}

//class MessageTile extends StatelessWidget {
//  final String message;
//  final bool sendByMe;
//
//  MessageTile({@required this.message, @required this.sendByMe});
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.only(
//          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
//      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
//      child: Container(
//        margin:
//            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
//        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
//        decoration: BoxDecoration(
//            borderRadius: sendByMe
//                ? BorderRadius.only(
//                    topLeft: Radius.circular(23),
//                    topRight: Radius.circular(23),
//                    bottomLeft: Radius.circular(23))
//                : BorderRadius.only(
//                    topLeft: Radius.circular(23),
//                    topRight: Radius.circular(23),
//                    bottomRight: Radius.circular(23)),
//            gradient: LinearGradient(
//              colors: sendByMe
//                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
//                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
//            )),
//        child: Text(message,
//            textAlign: TextAlign.start,
//            style: TextStyle(
//                color: Colors.white,
//                fontSize: 16,
//                fontFamily: 'OverpassRegular',
//                fontWeight: FontWeight.w300)),
//      ),
//    );
//  }
//}
