import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'meal.dart';
import 'meal_item.dart';
import 'meal_detail_screen.dart';

class CartScreen extends StatefulWidget {
  List<Meal> cartMeals;
  Function orderPlaced;
  CartScreen(this.cartMeals, this.orderPlaced);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> uploadOrder(
      FirebaseFirestore ref, BuildContext context, String uid) async {
    String userName;
    
    try {
      userName = await ref
          .collection('Users')
          .doc(uid)
          .get()
          .then((value) => value.data()!['Name']);
    } catch (e) {
      userName = 'Anonymous';
    }

    for (int index = 0; index < widget.cartMeals.length; index++) {
      
     var res= await ref.collection('Orders').add({
        'ItemName': widget.cartMeals[index].title,
        'ImageUrl': widget.cartMeals[index].imageUrl,
        'OrderId': 1,
        'PlacedBy': userName,
        'PlacedById': uid,
        'PlacedAt': Timestamp.now(),
        'PrepTime': widget.cartMeals[index].duration,
        'Price': 100 //change this to variable price of your choice
      });

      await ref.collection('Users').doc(uid).collection('cart').add({
        'ItemName': widget.cartMeals[index].title,
        'ImageUrl': widget.cartMeals[index].imageUrl,
        'OrderId': res.id,
        'PlacedBy': userName,
        'PlacedById': uid,
        'PlacedAt': Timestamp.now(),
        'PrepTime': widget.cartMeals[index].duration,
        'Price': 100
      });

      await ref.collection('Users').doc(uid).collection('orders').doc(res.id).set({
        'ItemName': widget.cartMeals[index].title,
        'ImageUrl': widget.cartMeals[index].imageUrl,
        'OrderId': res.id,
        'PlacedBy': userName,
        'PlacedById': uid,
        'PlacedAt': Timestamp.now(),
        'PrepTime': widget.cartMeals[index].duration,
        'Price': 100
      });

      
    }
    widget.orderPlaced();
    widget.cartMeals.clear(); //clear offline list
    await batchDelete(uid);
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Order Placed Successfully")));
    });
  }

  Future<void> batchDelete(String uid) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final orders = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('cart');
    return orders.get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        batch.delete(document.reference);
      }

      return batch.commit();
    });
  }



  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    if (widget.cartMeals.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No Items in cart'),
        ),
      );
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await uploadOrder(firestore, context, uid);
            
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.save),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('cart')
                .snapshots(),
            builder: (ctx, snapshot) {
              if (widget.cartMeals.isEmpty) {
                return const Center(
                  child: Text('No items in cart'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              // cartMeals =  snapshot.data!.docs.map((DocumentSnapshot document) {
              //   Map<String, dynamic> data =
              //       document.data()! as Map<String, dynamic>;
              //   return MealItem(id: data[''], title: data['ItemName'], imageUrl: data['ImageUrl'], affordability: Affordability.Affordable, complexity: Complexity.Simple, duration: 20,);
              // }).toList();

              return Container(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return MealItem(
                        id: widget.cartMeals[index].id,
                        title: widget.cartMeals[index].title,
                        imageUrl: widget.cartMeals[index].imageUrl,
                        affordability: widget.cartMeals[index].affordability,
                        complexity: widget.cartMeals[index].complexity,
                        duration: widget.cartMeals[index].duration);
                  },
                  itemCount: widget.cartMeals.length,
                ),
              );
            }),
      );
    }
  }
}
