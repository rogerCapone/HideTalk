import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/pages/chats/chat/chat.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  String deletingChat = null;
  bool dragged = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
          stream: Global.appRef.userAppData,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.data() != null) {
              if (snapshot.data.data()['contacts'].length != 0) {
                return Container(
                  decoration: BoxDecoration(color: kSecondaryColor),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.data()['contacts'].length,
                          itemBuilder: (context, i) {
                            print(
                                snapshot.data.data()['contacts'][i].toString());

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatDetailPage(
                                          image:
                                              snapshot.data.data()['contacts']
                                                  [i]['photoUrl'],
                                          userName:
                                              snapshot.data.data()['contacts']
                                                  [i]['userName'],
                                          userUid: snapshot.data
                                              .data()['contacts'][i]['uid'],
                                        )),
                              ),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        snapshot.data.data()['contacts'][i]
                                            ['userName'],
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(
                                      height: getProportionateScreenHeight(10),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      height: getProportionateScreenHeight(225),
                                      width: getProportionateScreenWidth(225),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(snapshot.data
                                                      .data()['contacts'][i]
                                                  ['photoUrl']))),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(25),
                                    ),
                                    // Icon(
                                    //   Icons.cancel,
                                    //   color: kPrimaryColor,
                                    // )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                    child: Text(
                  'You dont have any contacts :___(',
                  style: TextStyle(color: kPrimaryColor),
                ));
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
