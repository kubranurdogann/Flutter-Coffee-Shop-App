import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(SignUpPage());

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController birthController = TextEditingController();

  bool _isLoading = false;
  // Add this variable to manage the loading state
  Future<void> signup(BuildContext context) async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final FirebaseFirestore _firestore = FirebaseFirestore.instance;

        // Check if email is already in use
        final signInMethods =
            await _auth.fetchSignInMethodsForEmail(emailController.text.trim());
        if (signInMethods.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User already exists with this email!"),
            ),
          );
          setState(() {
            _isLoading = false; // Reset loading state
          });
          return;
        }

        // Create user with Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Save user data to Firestore
        if (userCredential.user != null) {
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'birth_date': birthController.text.trim(),
            'uid': userCredential.user!.uid,
          }).then((_) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("User created and data saved successfully!"),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );

            await userCredential.user
                ?.updateProfile(displayName: nameController.text.trim());
            await userCredential.user?.reload();
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Firestore error: $error"),
              ),
            );
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Authentication error: $e"),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.brown[800],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.brown[500],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  children: [
                    Text(
                      "Create new Account",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[100]),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NAME",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.brown[100]),
                            ),
                            Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.brown[100],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "EMAIL",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.brown[100]),
                            ),
                            Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.brown[100],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email is required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "PASSWORD",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.brown[100]),
                            ),
                            Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.brown[100],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length < 6) {
                                      return "Password must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "DATE OF BIRTH",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.brown[100]),
                            ),
                            Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.brown[100],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: birthController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your birth date';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.brown[100],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 100,
                                              right: 100),
                                          child: GestureDetector(
                                            onTap: () => signup(context),
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.brown[800]),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
