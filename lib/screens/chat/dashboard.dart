import 'package:chat_application_iub_cse464/const_config/color_config.dart';
import 'package:chat_application_iub_cse464/screens/auth/sign_up.dart';
import 'package:chat_application_iub_cse464/screens/chat/chat_tabs/chats.dart';
import 'package:chat_application_iub_cse464/screens/chat/chat_tabs/discover.dart';
import 'package:chat_application_iub_cse464/screens/chat/chat_tabs/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../const_config/text_config.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 1;
  final pageViewController = PageController(initialPage: 1);

  User? user = FirebaseAuth.instance.currentUser;//getting the user id


  @override
  void initState() {
    // TODO: implement initState
    updateLastLoginTimeAndIsActive(user!);


    /// This function runs after the widget is build....
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //
    //   pageViewController.jumpToPage(1);
    // });
    super.initState();
  }

  Future<void> updateLastLoginTimeAndIsActive(User user) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    print("------------------------------------------------");
    print(formattedDate);
    print("------------------------------------------------");

    print("------------------------user Id----------------------");
    print(user.uid);

    String userId = "";
    userId = user.uid;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'last_login': formattedDate,
        'is_active': true,
      });
    } catch (error) {
      print('Failed to update last login time: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,top: 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome to", style: TextDesign().dashboardWidgetTitle),
                    Text("Chat META", style: TextDesign().popHead.copyWith(color: MyColor.primary, fontSize: 22)),
                  ],
                ),

                if(selectedIndex == 2)
                IconButton(
                    onPressed: (){
                      final auth = FirebaseAuth.instance;
                      auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignUp()), (route) => false);
                    },
                    icon: const Icon(Icons.logout)
                )
              ],
            ),
            const SizedBox(height: 15,),
            Expanded(
              child: PageView(
                controller: pageViewController,
                onPageChanged: (value){
                  setState(() {
                    selectedIndex = value;
                  });
                },
                children: const [
                  DiscoverPage(),
                  ChatsPage(),
                  ProfilePage(),
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: FlashyTabBar(
          selectedIndex: selectedIndex,
          showElevation: true,
          backgroundColor: MyColor.white,
          onItemSelected: (index) {
            setState(() {
              if((selectedIndex-index).abs()>1)
                {
                  pageViewController.jumpToPage(index);
                }
              pageViewController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              selectedIndex = index;
            });
          },
          items: [
            FlashyTabBarItem(
              icon: const FaIcon(FontAwesomeIcons.solidCompass,color: MyColor.primary),
              title: const Text('Discover'),
            ),
            FlashyTabBarItem(
              icon: const FaIcon(FontAwesomeIcons.solidMessage,color: MyColor.primary),
              title: const Text('Chat'),
            ),
            FlashyTabBarItem(
              icon: const FaIcon(FontAwesomeIcons.solidUser,color: MyColor.primary),
              title: const Text('Profile'),
            ),
          ],
        ),
      ),
      
    );
  }
}
