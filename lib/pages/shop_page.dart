import 'package:coffee_shop_app/models/coffee.dart';
import 'package:coffee_shop_app/models/coffee_shop.dart';
import 'package:coffee_shop_app/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    void addToCart(Coffee coffee) {
      Provider.of<CoffeeShop>(context, listen: false).addItemtoCart(coffee);

      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            "Successfully added to cart!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Consumer<CoffeeShop>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(
            "How do you like your coffee?",
            style: TextStyle(
                fontSize: 16,
                color: Colors.brown[100],
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
              },
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      color: Colors.brown[100], size: 28),
                  Positioned(
                    child: Badge(
                      label: Text(
                          Provider.of<CoffeeShop>(context, listen: false)
                              .userCart
                              .length
                              .toString()),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Center(
          child: Expanded(
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
                        itemCount: value.coffeeShop.length,
                        itemBuilder: (context, index) {
                          Coffee eachCoffee = value.coffeeShop[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    eachCoffee.name,
                                    style: TextStyle(
                                        color: Colors.brown[800],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("${eachCoffee.price}tl",
                                      style: TextStyle(color: Colors.brown)),
                                ),
                                leading: Image.asset(
                                  eachCoffee.imagePath,
                                  width: 100,
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.navigate_next,
                                    color: Colors.brown[800],
                                  ),
                                  onPressed: () {
                                    addToCart(eachCoffee);
                                  },
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
        ),
      ),
    );
  }
}
