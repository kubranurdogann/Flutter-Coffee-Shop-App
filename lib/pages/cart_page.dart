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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Your Cart"),
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
                                    Text("Adet:${eachCoffee.quantity}")
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
