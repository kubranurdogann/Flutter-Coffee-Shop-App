import 'package:coffee_shop_app/models/coffee.dart';
import 'package:coffee_shop_app/models/coffee_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    void removeFromCart(Coffee coffee) {
      Provider.of<CoffeeShop>(context, listen: false)
          .removeItemFromCart(coffee);

      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            "Successfully removed from cart!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Consumer<CoffeeShop>(
      builder: (context, value, child) => Expanded(
        child: Container(
          decoration: BoxDecoration(color: Colors.brown[100]),
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text(
                    "Your Cart",
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 78, 52, 46)),
                  ),
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
                          padding: const EdgeInsets.all(5),
                          child: ListTile(
                            title: Text(eachCoffee.name),
                            subtitle: Text(eachCoffee.price),
                            leading: Image.asset(eachCoffee.imagePath),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => removeFromCart(eachCoffee),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
