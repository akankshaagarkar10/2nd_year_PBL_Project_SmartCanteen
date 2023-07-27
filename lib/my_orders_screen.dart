import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  String uid;
  MyOrdersScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.uid)
            .collection('orders')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error Occured'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Orders !'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final listData =
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                return _buildOrderTile(
                    context,
                    listData['ImageUrl'],
                    listData['ItemName'],
                    listData['OrderId'],
                    listData['PlacedBy'],
                    listData['PlacedAt'],
                    listData['PlacedById']);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Widget _buildOrderTile(BuildContext context, String imageUrl, String itemName,
    String orderId, String placedBy, Timestamp placedAt, String placedById) {
  return SizedBox(
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
              const SizedBox(
                width: 20,
              ),
              const Text(
                '22min',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(
            color: Colors.red,
          )
        ],
      ),
    ),
  );
}
