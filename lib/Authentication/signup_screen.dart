import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/Authentication/signin_screen.dart';
import 'package:fyp2/Models/security_question.dart';
import '../API/api.dart';
import '../Models/user_model.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();

}

class _signUpScreenState extends State<signUpScreen> {
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final securityQuestionAnswerController = new TextEditingController();
  final securityQuestions = new TextEditingController();
  final _formSignUpKey = GlobalKey<FormState>();
  String error_message = "";
  String error_pwd = "";
  String? errorMessage;
  bool _obscurePassword = true; // State for password visibility
  bool _obscuredconfirmpwd = true;
  List<String> questions = [];

  @override
  void initState() {
    fetchQuestions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/signup.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              bottom: MediaQuery.of(context).size.height * 0.05,
            ),
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04),
              child: Form(
                key: _formSignUpKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome To Heaven Of Recipes',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 24,
                          // letterSpacing: 2,
                        ),
                      ),
                      // SizedBox(height: 15,),
                      // Text("  Enter your Data",style: TextStyle(
                      //   color: Color.fromRGBO(0, 49, 67, 100),
                      //   fontSize: 10,
                      //   fontWeight: FontWeight.w200,
                      // ),),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: firstNameEditingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Firstname',
                            prefixIcon: Icon(
                              Icons.account_circle_rounded,
                              color: Colors.black,
                            )),
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("First Name cannot be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid name(Min. 3 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstNameEditingController.text = value!;
                        },
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Colors.black,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstNameEditingController.text = value!;
                        },
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: passwordEditingController,
                        obscureText: _obscurePassword,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstNameEditingController.text = value!;
                        },
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: confirmPasswordEditingController,
                        obscureText: _obscuredconfirmpwd,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Confirm Password',
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            // Eye icon button for password visibility toggle
                            icon: Icon(_obscuredconfirmpwd
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscuredconfirmpwd = !_obscuredconfirmpwd;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (confirmPasswordEditingController.text !=
                              passwordEditingController.text) {
                            return "Password don't match";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          confirmPasswordEditingController.text = value!;
                        },
                      ),
                      SizedBox(height: 5),

                      DropdownSearch(

                          items: questions,
                          dropdownBuilder: (context, selectedItem) {
                            return Text(
                              selectedItem ?? "Select Security Question",
                              style: TextStyle(fontSize: 16),
                            );
                          },
                          compareFn: (item1, item2) {
                            return true;
                          },
                          onChanged: (value) {
                            securityQuestions.text = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Security Question is required';
                            }
                            return null;
                          },
                          popupProps: const PopupProps.menu(
                            isFilterOnline: true,
                            showSelectedItems: true,
                          ),
                        ),

                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: securityQuestionAnswerController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Security Question Answer',
                          prefixIcon: Icon(
                            Icons.security,
                            color: Colors.black,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Security Question cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          securityQuestionAnswerController.text = value!;
                        },
                      ),

                      // SizedBox(height: 5,),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(150, 107, 241, 39),
                            minimumSize: Size(200, 40),
                          ),
                          onPressed: () {
                            signUp(emailEditingController.text,
                                passwordEditingController.text);
                          },
                          child: const Text(
                            "Sign Up",
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          const Text(
                            'Already have a account',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(0, 49, 67, 100),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => signInScreen(),
                                    ));
                              },
                              child: const Text(
                                "Sign In here",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formSignUpKey.currentState!.validate()) {
      User user = User(username:firstNameEditingController.text,email: emailEditingController.text,password: passwordEditingController.text,usecurityQuestion: securityQuestions.text,uanswer: securityQuestionAnswerController.text,isAdmin: false);
      int check = await Api.addUser(user);
      if(check==205){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Taken"),
            content: Text("Please enter another email"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }if(check==200){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sign Up Successfull"),
              content: Text("You can sign in using your email"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => signInScreen(),
                      ),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }
  Future<void> fetchQuestions() async {
    List<securityQuestion> Question = await Api.fetchQuestions();
    setState(() {
      questions = Question.map((ing) => ing.question).toList();
    });
  }
}
