import 'package:chat_application_iub_cse464/screens/auth/sign_up.dart';
import 'package:chat_application_iub_cse464/screens/chat/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../const_config/color_config.dart';
import '../../const_config/text_config.dart';
import '../../services/utils/helper_functions.dart';
import '../../services/utils/validators.dart';
import '../../widgets/custom_buttons/Rouded_Action_Button.dart';
import '../../widgets/input_widgets/password_input_field.dart';
import '../../widgets/input_widgets/simple_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;



  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColor.scaffoldColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text("Welcome to", style: TextDesign().dashboardWidgetTitle),
                  Text("Chat META", style: TextDesign().popHead.copyWith(color: MyColor.primary, fontSize: 22)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: MyColor.white, borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
              
                        SimpleInputField(
                          controller: emailController,
                          backgroundColor: MyColor.scaffoldColor,
                          hintText: "Enter email",
                          needValidation: true,
                          errorMessage: "",
                          validatorClass: ValidatorClass().validateEmail,
                          fieldTitle: "Email",
                        ),
                        const SizedBox(height: 5),
                        PasswordInputField(
                          password: passwordController,
                          backgroundColor: MyColor.scaffoldColor,
                          fieldTitle: "Password",
                          hintText: "*******",
                        ),
              
                        const SizedBox(height: 20),
                        RoundedActionButton(
                            onClick: ()async {
                              FocusScope.of(context).unfocus();
                              if(formKey.currentState!.validate())
                              {
                                await auth.signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()
                                ).then((value) async {
                                  if(value.user != null)
                                  {
                                    showSnackBar(
                                        context: context,
                                        title: "Successful",
                                        height: 200,
                                        message: "Welcome to Chat META",
                                        failureMessage: false
                                    );
                                    // Update last login time in Firestore
                                    // print("------------------------user Id----------------------");
                                    // print(user?.uid);

                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()), (route) => false);
                                  }
                                  else
                                  {
                                    showSnackBar(
                                        context: context,
                                        title: "Error",
                                        height: 200,
                                        message: "Please try again later",
                                        failureMessage: true
                                    );
                                  }
                                });
                              }
                            },
                            width: size.width * 0.8,
                            label: "Login Now"
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextDesign().bodyTextSmall.copyWith(color: MyColor.disabled),
                            ),
                            InkWell(
                                onTap: () {
                                  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignUp()), (route) => false);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignUp()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child:Text("Sign Up Now!",
                                      style: TextDesign().pageTitle.copyWith(color: MyColor.primary, fontSize: 13)),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
