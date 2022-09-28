import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ChatScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  final _authentication = FirebaseAuth.instance;

  void _tryValidation(){
    final isValid = formKey.currentState!.validate();
    if(isValid){
      formKey.currentState!.save();
      print(formKey.currentState);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Stack(
            children: [
              Positioned(
                child: Container(
                  color: Colors.transparent,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
              Positioned(
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.android,
                          size: 80,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Welcome to my Firest App',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20
                          ),
                          child: TextFormField(
                            onChanged: (value){
                              userEmail = value;
                            },
                            onSaved: (value){
                              userEmail = value!;
                            },
                            validator: (value){
                              if(value != null || value!.contains('@')){
                                return null;
                              }
                              return 'Please check your email';
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                    Icons.email
                                ),
                                hintText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  ),
                                )
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20
                          ),
                          child: TextFormField(
                            onChanged: (value){
                              userPassword = value;
                            },
                            onSaved: (value){
                              userPassword = value!;
                            },
                            validator: (value){
                              if(value != null || value!.length < 6){
                                return null;
                              }
                              return 'Please check your password';
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                  Icons.password_rounded
                              ),
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)
                                  ),
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                borderSide: BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        ElevatedButton.icon(
                          onPressed: ()async{
                            _tryValidation();

                            try {
                              final newUser = await _authentication.createUserWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword,
                              );

                              if(newUser.user != null){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return ChatScreen();
                                }));
                              }
                            }catch(e){
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please check your email and password'),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text(
                            'Sign-up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          style: ElevatedButton.styleFrom(

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}
