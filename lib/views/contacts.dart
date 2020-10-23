//import 'package:chatapp/helper/constants.dart';
//import 'package:chatapp/models/user_model.dart.dart';
//import 'package:chatapp/services/database.dart';
//import 'package:chatapp/views/chat.dart';
//import 'package:chatapp/widget/widget.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//
//class Search extends StatefulWidget {
//  @override
//  _SearchState createState() => _SearchState();
//}
//
//class _SearchState extends State<Search> {
//  DatabaseMethods databaseMethods = new DatabaseMethods();
//  bool isLoading = false;
//  bool haveUserSearched = false;
//  List<UserModel> users = [];
//
//  /// 1.create a chatroom, send user to the chatroom, other userdetails
//  sendMessage(String userName) {
//    List<String> users = [Constants.myName, userName];
//
//    String chatRoomId = getChatRoomId(Constants.myName, userName);
//
//    Map<String, dynamic> chatRoom = {
//      "users": users,
//      "chatRoomId": chatRoomId,
//    };
//
//    databaseMethods.addChatRoom(chatRoom, chatRoomId);
//
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => Chat(
//                  chatRoomId: chatRoomId,
//                )));
//  }
//
//  getChatRoomId(String a, String b) {
//    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
//      return "$b\_$a";
//    } else {
//      return "$a\_$b";
//    }
//  }
//
//  Widget userCard(String userName, String userEmail) {
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//      child: Row(
//        children: [
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Text(
//                userName,
//                style: TextStyle(color: Colors.white, fontSize: 16),
//              ),
//              Text(
//                userEmail,
//                style: TextStyle(color: Colors.white, fontSize: 16),
//              )
//            ],
//          ),
//          Spacer(),
//          GestureDetector(
//            onTap: () {
//              sendMessage(userName);
//            },
//            child: Container(
//              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//              decoration: BoxDecoration(
//                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
//              child: Text(
//                "Message",
//                style: TextStyle(color: Colors.white, fontSize: 16),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: appBarMain(context),
//        body: StreamBuilder(
//          stream: Firestore.instance.collection('users').snapshots(),
//          builder: (context, snap) {
//            if (snap.hasData) {
//              for (var doc in snap.data.documents) {
//                var data = doc.data;
//                users.add(UserModel(
//                    userName: data['userEmail'], userEmail: data['userEmail']));
//              }
//            }
//            return ListView.builder(
//                shrinkWrap: true,
//                itemCount: users.length,
//                itemBuilder: (context, index) {
//                  return userCard(
//                    users[index].userName,
//                    users[index].userEmail,
//                  );
//                });
//          },
//        ));
//  }
//}
//
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot ResultSnapshot;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    contacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: userList(),
            ),
    );
  }

  contacts() async {
    setState(() {
      isLoading = true;
    });
    await databaseMethods.loedContact().then((snapshot) {
      ResultSnapshot = snapshot;
      print("$ResultSnapshot");
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget userList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ResultSnapshot.documents.length,
        itemBuilder: (context, index) {
          return userCard(
            userName: ResultSnapshot.documents[index].data["userName"],
          );
        });
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }

  Widget userCard({String userName}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(24)),
                child: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      sendMessage(userName);
                    }))
          ],
        ),
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
//StreamBuilder(
//stream: Firestore.instance.collection('users').snapshots(),
//builder: (context, snap) {
//if (snap.hasData) {
//for (var doc in snap.data.documents) {
//var data = doc.data;
//users.add(UserModel(
//userName: data['userEmail'], userEmail: data['userEmail']));
//}
//}
//return ListView.builder(
//shrinkWrap: true,
//itemCount: users.length,
//itemBuilder: (context, index) {
//return userCard(
//users[index].userName,
//users[index].userEmail,
//);
//});
//},
//)
