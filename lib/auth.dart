import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/Accountsetup.dart';
import 'package:page_transition/page_transition.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final phonenumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpass = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  void dispose() {
    // TODO: implement dispose
    password.dispose();
    confirmpass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 246, 249),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Center(
                child: Text(
                  "LifeLine",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: ListView(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Hey, Hello 👋",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 28),
                    child: Text(
                      "Enter Your information to create an account",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          xInputfield(
                            label: 'Number',
                            icon: Icons.phone,
                            Hinttext: "Enter Your Phone Number",
                            controller: phonenumber,
                            txtinputtype: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (value.length < 11) {
                                return 'Please enter 11 digit number';
                              }
                              return null;
                            },
                          ),
                          xInputfield(
                            label: 'Email',
                            Hinttext: 'Enter Email',
                            icon: Icons.email,
                            controller: email,
                            txtinputtype: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required.";
                              }

                              // Regular expression for a valid email address
                              const emailRegex =
                                  r"^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+";

                              if (!RegExp(emailRegex).hasMatch(value)) {
                                return "Invalid email format.";
                              }

                              return null; // Valid email
                            },
                          ),
                          xInputfield(
                            label: 'Password',
                            Hinttext: 'Enter Your Password',
                            icon: Icons.lock,
                            controller: password,
                            isObscure: true,
                            txtinputtype: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required.";
                              }

                              // Basic password requirements
                              bool hasUppercase =
                                  RegExp(r'[A-Z]').hasMatch(value);
                              bool hasLowercase =
                                  RegExp(r'[a-z]').hasMatch(value);
                              bool hasDigit = RegExp(r'[0-9]').hasMatch(value);

                              if (!hasUppercase || !hasLowercase || !hasDigit) {
                                return "Password must contain at least one uppercase letter, \n one lowercase letter, one digit";
                              }

                              if (value.length < 8) {
                                return "Password must be at least 8 characters long.";
                              }

                              return null; // Valid password
                            },
                          ),
                          xInputfield(
                            label: 'ConfirmPassword',
                            Hinttext: 'Enter Your Password',
                            icon: Icons.lock,
                            controller: confirmpass,
                            isObscure: true,
                            txtinputtype: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm password is required.";
                              }

                              if (value != password.text) {
                                return "Passwords do not match.";
                              }

                              return null; // Valid confirmation
                            },
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "By clicking the Create button, you agree to ",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                                TextSpan(
                                  text: "Terms of Service",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                                TextSpan(
                                  text: ".",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Container(
                              height: 67,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: const Color.fromARGB(255, 221, 12, 12),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text,
                                      )
                                          .then((value) {
                                        users
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.uid)
                                            .set({'Phone': phonenumber.text});
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                child: const Accountsetup()));
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(e.code),
                                      ));
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                },
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 200),
                                child: const Login()));
                      },
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                          text: "Already have an Account? ",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        TextSpan(
                          text: " Login",
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ])),
                    ),
                  ),
                  const Spacer()
                ]),
              ),
            ],
          ),
        ));
  }
}

class xInputfield extends StatelessWidget {
  const xInputfield(
      {super.key,
      required this.label,
      required this.Hinttext,
      required this.icon,
      required this.controller,
      this.txtinputtype = TextInputType.text,
      this.isObscure = false,
      this.validator});
  final String label, Hinttext;
  final IconData icon;
  final isObscure;
  final txtinputtype;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty.";
    }
    return null; // Valid input
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: isObscure,
        controller: controller,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          labelText: label,
          hintText: Hinttext,
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none, // Transparent border in normal state
            borderRadius: BorderRadius.circular(15.0),
          ),
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          focusedBorder: OutlineInputBorder(
            // Set border for focused state
            borderSide:
                const BorderSide(color: Colors.grey), // Choose desired color
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        keyboardType: txtinputtype, // Set keyboard type (e.g., email, number)
        validator: validator ?? defaultValidator,
        onSaved: (value) {},
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final password = TextEditingController();
    final phonenumber = TextEditingController();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 246, 249),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Center(
                child: Text(
                  "LifeLine",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: ListView(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Welcome back 👋",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 28),
                    child: Text(
                      "Enter Your Credentials",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  xInputfield(
                    label: 'Number',
                    icon: Icons.phone,
                    Hinttext: "Enter Your Phone Number",
                    controller: phonenumber,
                    txtinputtype: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 11) {
                        return 'Please enter 11 digit number';
                      }
                      return null;
                    },
                  ),
                  xInputfield(
                    label: 'Password',
                    Hinttext: 'Enter Your Password',
                    icon: Icons.lock,
                    controller: password,
                    isObscure: true,
                    txtinputtype: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required.";
                      }

                      // Basic password requirements
                      bool hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
                      bool hasLowercase = RegExp(r'[a-z]').hasMatch(value);
                      bool hasDigit = RegExp(r'[0-9]').hasMatch(value);

                      if (!hasUppercase || !hasLowercase || !hasDigit) {
                        return "Password must contain at least one uppercase letter, \n one lowercase letter, one digit";
                      }

                      if (value.length < 8) {
                        return "Password must be at least 8 characters long.";
                      }

                      return null; // Valid password
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Container(
                      height: 67,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        color: const Color.fromARGB(255, 221, 12, 12),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: const Signup()));
                      },
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                          text: "Don't have an Account? ",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        TextSpan(
                          text: " Sign Up",
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ])),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}
