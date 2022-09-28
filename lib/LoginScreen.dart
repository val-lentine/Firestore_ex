import 'package:flutter/material.dart';
import 'package:real_ex/ChatScreen.dart';
import 'package:real_ex/SignupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showSpinner = false;
  final formKeys = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  final _authentication = FirebaseAuth.instance;

  void _tryValidation(){
    final isValid = formKeys.currentState!.validate();
    if(isValid){
      formKeys.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogIn'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
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
                    key: formKeys,
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
                            setState(() {
                              showSpinner = true;
                            });
                            _tryValidation();

                            try{
                              final newUser = await _authentication.signInWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword,
                              );

                              if(newUser.user != null){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return ChatScreen();
                                }));

                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            }catch(e){
                              print(e);
                            }
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text(
                            'Sign-in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          style: ElevatedButton.styleFrom(

                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return SignupScreen();
                            }));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Register now',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold
                              )
                            ),
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
      ),
    );
  }
}
