import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/contacts.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  Stream chatRooms;
  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
          child: StreamBuilder(
        stream: chatRooms,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat(
                                      chatRoomId: snapshot.data.documents[index]
                                          .data["chatRoomId"],
                                      username: snapshot.data.documents[index]
                                          .data['chatRoomId']
                                          .toString(),
                                    )));
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.white10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Icon(Icons.person)),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "${snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(Constants.myName, "")}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.contact_phone),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Contacts()));
        },
      ),
    );
  }
}

//Widget chatRoomsList() {
//  Stream chatRooms;
//  return
//    StreamBuilder(
//    stream: chatRooms,
//    builder: (context, snapshot) {
//      return snapshot.hasData
//          ? ListView.builder(
//              itemCount: snapshot.data.documents.length,
//              shrinkWrap: true,
//              itemBuilder: (context, index) {
//                return GestureDetector(
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => Chat(
//                                  chatRoomId: snapshot
//                                      .data.documents[index].data["chatRoomId"],
//                                  username: snapshot
//                                      .data.documents[index].data['chatRoomId']
//                                      .toString(),
//                                )));
//                  },
//                  child: Card(
//                    elevation: 2,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(20)),
//                    color: Colors.white10,
//                    child: Container(
//                      padding:
//                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                      child: Row(
//                        children: [
//                          Container(
//                              height: 30,
//                              width: 30,
//                              decoration: BoxDecoration(
//                                  color: Colors.purple,
//                                  borderRadius: BorderRadius.circular(30)),
//                              child: Icon(Icons.person)),
//                          SizedBox(
//                            width: 15,
//                          ),
//                          Text(
//                            "${snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(Constants.myName, "")}",
//                            style: TextStyle(color: Colors.white, fontSize: 16),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                );
//
//              })
//          : Container();
//    },
//  );

//class ChatsHome extends StatelessWidget {
//  final String userName;
//  final String chatRoomId;
//
//  ChatsHome({this.userName, @required this.chatRoomId});
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: () {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => Chat(
//                      chatRoomId: chatRoomId,
//                      username: userName,
//                    )));
//      },
//      child: Card(
//        elevation: 2,
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//        color: Colors.white10,
//        child: Container(
//          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//          child: Row(
//            children: [
//              Container(
//                  height: 30,
//                  width: 30,
//                  decoration: BoxDecoration(
//                      color: Colors.purple,
//                      borderRadius: BorderRadius.circular(30)),
//                  child: Icon(Icons.person)),
//              SizedBox(
//                width: 15,
//              ),
//              Text(
//                userName,
//                style: TextStyle(color: Colors.white, fontSize: 16),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//              ChatsHome(
////              userName: snapshot.data.documents[index].data['chatRoomId']
////                  .toString()
////                  .replaceAll("_", "")
////                  .replaceAll(Constants.myName, ""),
////              chatRoomId:
////              snapshot.data.documents[index].data["chatRoomId"],
////            );
