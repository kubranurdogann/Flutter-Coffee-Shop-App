import 'package:coffee_shop_app/models/coffee.dart';
import 'package:coffee_shop_app/models/coffee_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> removeFromCart(Coffee coffee) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;

      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(coffee.id)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successfully removed from cart!"),
          ),
        );

        // Remove the coffee item from the local cart
        Provider.of<CoffeeShop>(context, listen: false).removeItemFromCart(coffee);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to remove item: $e"),
          ),
        );
      }
    }
  }

  Future<void> increaseQuantity(Coffee coffee) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;

      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(coffee.id)
            .update({
          'quantity': FieldValue.increment(1),
        });

        Provider.of<CoffeeShop>(context, listen: false).increaseQuantity(coffee);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update quantity: $e"),
          ),
        );
      }
    }
  }

  Future<void> decreaseQuantity(Coffee coffee) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;

      try {
        if (coffee.quantity > 1) {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .doc(coffee.id)
              .update({
            'quantity': FieldValue.increment(-1),
          });

          Provider.of<CoffeeShop>(context, listen: false).decreaseQuantity(coffee);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update quantity: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: IconThemeData(
          color: Colors.brown[100],
        ),
        title: Text(
          "Your Cart",
          style: TextStyle(color: Colors.brown[100]),
        ),
      ),
      body: Center(
        child: Consumer<CoffeeShop>(
          builder: (context, value, child) => Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.brown[100]),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.userCart.length,
                        itemBuilder: (context, index) {
                          Coffee eachCoffee = value.userCart[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                title: Text(
                                  eachCoffee.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${eachCoffee.price.toString()}tl",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      children: [
                                        Text("Adet: "),
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () => decreaseQuantity(eachCoffee),
                                        ),
                                        Text("${eachCoffee.quantity}"),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () => increaseQuantity(eachCoffee),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                leading: Image.asset(eachCoffee.imagePath),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => removeFromCart(eachCoffee),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total: ${value.total.toString()}"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.brown,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 100, right: 100),
                        child: Text(
                          "Buy it",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown[100]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
