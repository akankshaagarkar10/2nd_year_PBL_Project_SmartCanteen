import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbl_studentend_clubbed/main_drawer.dart';

class OnGoingOrders extends StatelessWidget {
  static const routeName = 'OnGoingOrders';

  final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
      .collection('Orders')
      .orderBy('PlacedAt', descending: false)
      .snapshots();
  Future<void> batchDelete() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final orders = FirebaseFirestore.instance.collection('Orders');

    return orders.get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        var placedById = document.get('PlacedById');
        deletePersonOrders(placedById);
        batch.delete(document.reference);
      }

      return batch.commit();
    });
  }

  Future<void> deletePersonOrders(String uid) async {
    WriteBatch newBatch = FirebaseFirestore.instance.batch();
    final userOrders = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('orders');

    return userOrders.get().then((value) {
      for (var userOrder in value.docs) {
        newBatch.delete(userOrder.reference);
      }

      return newBatch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('On-going Orders'),
      ),
      drawer: MainDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          //In case orders loading

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          var orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(
              child: Text('No orders yet'),
            );
          }
          //return list when fetched
          return ListView.builder(
            itemBuilder: ((context, index) {
              var data = orders[index].data() as Map<String, dynamic>;
              return _buildListTile(
                  context,
                  index,
                  data['ImageUrl'],
                  data['ItemName'],
                  data['OrderId'],
                  data['PlacedBy'],
                  data['PlacedAt'],
                  orders[index].id,
                  data['PlacedById']);
            }),
            itemCount: orders.length,
          );
        }),
        stream: _orderStream,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await batchDelete();
      //     await deletePersonOrders(uid);
      //   },
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.done),
      // ),
    );
  }
}

Widget _buildListTile(
    BuildContext context,
    int index,
    String imageUrl,
    String itemName,
    int orderId,
    String placedBy,
    Timestamp placedAt,
    String orderUid,
    String personUid) {
  Future<void> _listItemDismissed(String orderUid, String uid) async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(orderUid.toString())
        .delete();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('orders')
        .where('OrderId', isEqualTo: orderId)
        .get()
        .then((value) async {
      for (var userOrder in value.docs) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('orders')
            .doc(userOrder.id)
            .delete();
      }
    });
  }

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 30,
              ),
              const SizedBox(
                width: 15,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Container(
                        child: Text(
                          itemName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                    ),
                    Text(placedAt.toDate().toLocal().toString()),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '#${index + 1}',
                style: const TextStyle(
                    fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Placed by $placedBy',
            style:
                TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15),
          ),
          const Divider(
            color: Colors.red,
          )
        ],
      ),
    ),
  );
}
