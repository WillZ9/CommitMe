import 'package:flutter/material.dart';
import 'package:commit_me/authentication/loginScreen.dart';
import '/db/DatabaseHelperCommit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPassword = TextEditingController();
  final emailTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Uuid uuid = const Uuid();
  bool isVisible = false;

  /*bool emailRepeat(String? email) {
    for (String i in emailList) {
      if (email == i) {
        return true;
      }
    }
    return false;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "Register Account",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 58, 62, 183)
                            .withOpacity(0.2)),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: emailTextController,
                      validator: (value) {
                        if (value!.isEmpty || !EmailValidator.validate(value)) {
                          return "email is invalid";
                        } /*else if (emailRepeat(value)) {
                          return "email in use!";
                        }*/
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                    ),
                  ),
                  //username field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 58, 62, 183)
                            .withOpacity(0.2)),
                    child: TextFormField(
                        cursorColor: Colors.white,
                        controller: usernameTextController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "username is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.man),
                          border: InputBorder.none,
                          hintText: "Username",
                        )),
                  ),
                  //Password field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 58, 62, 183)
                            .withOpacity(0.2)),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: passwordTextController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password is required";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  //toggle button
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 58, 62, 183)
                            .withOpacity(0.2)),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: confirmPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password is required";
                        } else if (passwordTextController.text !=
                            confirmPassword.text) {
                          return "passwords don't match";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),

                  const SizedBox(height: 10),
                  //Login button
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 58, 62, 183)),
                    child: TextButton(
                        /*final result = await db.signup(User(
                          email: emailTextController.text,
                          username: usernameTextController.text,
                          password: passwordTextController.text,
                        ));

                        if (result == -1) {
                          // Display an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email already exists. Choose a different email."),
                            ),
                          );
                        } else {
                          // Signup successful, navigate to the login screen or perform other actions
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        }
                        */
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            DatabaseHelper()
                                .signup(User(
                                    email: emailTextController.text,
                                    username: usernameTextController.text,
                                    uid: uuid.v1(),
                                    password: passwordTextController.text))
                                .whenComplete(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            });
                          }
                        },
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            //Navigate to log in screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            )
                          )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
