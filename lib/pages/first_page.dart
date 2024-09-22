// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:coffee_shop_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[100],
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
                child: Image.asset(
              "lib/images/cofee1.png",
              height: 250,
            )),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
              "Brew Day",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800]),
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "How do you like your coffee?",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.brown[800]),
            )),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                color: Colors.brown,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 100, right: 100),
                  child: Text(
                    "Enter Shop",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown[100]),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
