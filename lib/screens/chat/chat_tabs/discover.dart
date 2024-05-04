import 'package:chat_application_iub_cse464/const_config/color_config.dart';
import 'package:chat_application_iub_cse464/const_config/text_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.scaffoldColor,
      body: UserList()
      // Center(
      //   //child: Text("Updates Coming soon....",style: TextDesign().bodyTextSmall,),
      // ),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsers(),
      builder: (context, AsyncSnapshot
      <List<DocumentSnapshot>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        List<DocumentSnapshot> users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            //var user = users[index].data();
            var user = users[index].data() as Map<String, dynamic>;
            return ListTile(
              // title: Text(user!['name']),
              // subtitle: Text(user['email']),
              title: Text(user['name'] as String),
            );
          },
        );
      }
    },
    );
  }

  Future<List<DocumentSnapshot>> getUsers() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs;
  }
}
