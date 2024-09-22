import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/models/coffee.dart';
import 'package:coffee_shop_app/models/coffee_shop.dart';
import 'package:coffee_shop_app/pages/cart_page.dart';
import 'package:coffee_shop_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool isLoading = true; // Yüklenme durumu

  @override
  void initState() {
    super.initState();
    _loadCoffeeData();
  }



  Future<void> _loadCoffeeData() async {
    // FirebaseAuth ile oturum açmış kullanıcıyı al
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? currentUser = _auth.currentUser;
    try {
      await Provider.of<CoffeeShop>(context, listen: false)
          .fetchCoffeeData(currentUser!.uid);
    } catch (e) {
      // Hata durumunu yönet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load coffee data: $e"),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Veriler yüklendiğinde loading durumu güncellenir
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = _auth.currentUser;
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.brown[100], // Geri simgesinin rengini beyaz yapar
          ),
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
        drawer: Drawer(
          backgroundColor: Colors.brown[800],
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Yuvarlak yapar
                    border: Border.all(
                        color: Colors.grey,
                        width: 4), // Çerçeve rengi ve kalınlığı
                    image: DecorationImage(
                      image: AssetImage('lib/images/profile.png'),
                      fit: BoxFit.cover, // Resmi kapsayacak şekilde ayarlar
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text('${currentUser?.displayName ?? "no name"}'
                ,style: TextStyle(color: Colors.brown[200],fontSize: 18, ),),
                Text('${currentUser?.email}'
                ,style: TextStyle(color: Colors.brown[200],fontSize: 17, ),),
                SizedBox(height: 50,),
                Container(
                            decoration: BoxDecoration(
                              color: Colors.brown[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 100, right: 100),
                              child: GestureDetector(
                                onTap: () => logout(context),
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.brown[800],
                                  ),
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Yüklenme göstergesi
            : Center(
                child: Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.brown[100]),
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          Expanded(
                            child: ListView.builder(
                              itemCount: value.coffeeShop.length,
                              itemBuilder: (context, index) {
                                Coffee eachCoffee = value.coffeeShop[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18, right: 18),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: const EdgeInsets.only(bottom: 5),
                                    padding: EdgeInsets.all(5),
                                    child: ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          eachCoffee.name,
                                          style: TextStyle(
                                              color: Colors.brown[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text("${eachCoffee.price}tl",
                                            style:
                                                TextStyle(color: Colors.brown)),
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
                                          showQuantityDialog(
                                              context, eachCoffee);
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

void showQuantityDialog(BuildContext context, Coffee eachCoffee) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Center(
                child: Text(eachCoffee.name,
                    style: TextStyle(color: Colors.brown[800]))),
            content: Container(
              height: 200,
              width: 100,
              child: Column(
                children: [
                  Image.asset(
                    eachCoffee.imagePath,
                    width: 100,
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            Provider.of<CoffeeShop>(context, listen: false)
                                .decreaseQuantity(eachCoffee);
                          });
                        },
                      ),
                      Text("${eachCoffee.quantity}"),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            Provider.of<CoffeeShop>(context, listen: false)
                                .increaseQuantity(eachCoffee);
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("İngredients:"),
                        Text(eachCoffee.ingredients),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  addToCart(context, eachCoffee);
                },
                child: Text(
                  "Add to Cart!",
                  style: TextStyle(color: Colors.brown[800]),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void addToCart(BuildContext context, Coffee coffee) {
  final coffeeShop = Provider.of<CoffeeShop>(context, listen: false);

  // Firestore'a kaydetmek için kullanıcı kimliğini al
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = _auth.currentUser;

  if (currentUser != null) {
    String userId = currentUser.uid;
    coffeeShop.addItemtoCart(coffee, userId);

    // Başarı mesajı
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.brown,
        title: Text(
          "Successfully added to cart!",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  } else {
    // Kullanıcı null ise hata mesajı
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error: User not logged in!"),
      ),
    );
  }
}

Future<void> saveCartToFirestore(String userId, List<Coffee> cartItems) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    // Önce kullanıcının mevcut sepetini temizle
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    // Ardından her kahve öğesini kullanıcının sepet koleksiyonuna ekle
    for (var coffee in cartItems) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(coffee.id) // Belge kimliği olarak coffee id kullanılır
          .set(coffee.toMap());
    }

    print("Cart saved successfully!");
  } catch (e) {
    print("Failed to save cart: $e");
  }
}

Future<void> logout(BuildContext context) async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? currentUser = _auth.currentUser;

    // Sepet ve ürün miktarlarını sıfırla
    Provider.of<CoffeeShop>(context, listen: false).resetQuantities();

    // Kullanıcıyı çıkış yap
    await _auth.signOut();

    // Kullanıcıyı giriş ekranına yönlendir
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Tüm geçmiş sayfaları temizle
    );

    // Başarı mesajı
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Successfully logged out!"),
      ),
    );
  } catch (e) {
    // Hata durumunu yönet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to log out: $e"),
      ),
    );
  }
}
