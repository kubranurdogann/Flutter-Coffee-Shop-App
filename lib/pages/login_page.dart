import 'package:coffee_shop_app/pages/shop_page.dart';
import 'package:coffee_shop_app/pages/signup_page.dart';
import 'package:coffee_shop_app/models/coffee_shop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false; // Yükleme durumu için değişken

// Giriş işlemi
  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Yükleme başladığını belirtir
      });

      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        // Kullanıcı girişini gerçekleştir
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          // Giriş başarılı olduğunda kullanıcı kimliğini al
          String userId = userCredential.user!.uid;

          // Sepeti sıfırladıktan sonra sepet verilerini yükle
          Provider.of<CoffeeShop>(context, listen: false).clearCart();

          await Provider.of<CoffeeShop>(context, listen: false)
              .loadCartFromFirestore(userId);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login successful!"),
            ),
          );

          // Giriş başarılı, ana sayfaya yönlendirilebilir
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShopPage()),
          );
        }
      } catch (e) {
        // Giriş başarısızsa kullanıcıya hata mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login failed: $e"),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Yükleme tamamlandığında durumu resetler
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Column(
        children: [
          SizedBox(height: 25),
          Center(
            child: Image.asset(
              "lib/images/cofee1.png",
              height: 175,
            ),
          ),
          SizedBox(height: 25),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.brown[500], // Renk isteğe göre değiştirilebilir
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60), // Sağ üst köşe yuvarlatılmış
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[100],
                      ),
                    ),
                    Text(
                      "Sign in to continue",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown[100],
                      ),
                    ),
                    SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EMAIL",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.brown[100],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.brown[100],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
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
                                fontSize: 14,
                                color: Colors.brown[100],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.brown[100],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true, // Şifreyi gizli gösterir
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    _isLoading
                        ? CircularProgressIndicator() // Yükleme göstergesi
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.brown[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 100, right: 100),
                              child: GestureDetector(
                                onTap: () => login(context),
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.brown[800],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        "Sign Up!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown[100],
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
