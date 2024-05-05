import 'package:chat_application_iub_cse464/const_config/color_config.dart';
import 'package:chat_application_iub_cse464/const_config/text_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_avatar/random_avatar.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.scaffoldColor,
      body: UserList(),
    );
  }
}

class UserList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsers(),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
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
              var user = users[index].data() as Map<String, dynamic>;
              return UserListItem(
                name: user['name'] as String,
                email: user['email'] as String,
                lastLogin: user['last_login'] as String?, // Nullable
                isActive: user['is_active'] as bool?, // Nullable
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

class UserListItem extends StatelessWidget {
  final String name;
  final String email;
  final String? lastLogin; // Nullable
  final bool? isActive; // Nullable

  const UserListItem({
    required this.name,
    required this.email,
    required this.lastLogin,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RandomAvatar(
        name,
        trBackground: false,
        height: 50,
        width: 50,
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(email),
          if (lastLogin != null) Text('Last Login: $lastLogin'),
          if (isActive != null) Text('Active: $isActive ? "Yes" : "No"'),
        ],
      ),
    );
  }
}