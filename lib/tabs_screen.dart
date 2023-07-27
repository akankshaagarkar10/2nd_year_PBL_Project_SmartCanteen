import 'package:pbl_studentend_clubbed/cart_screen.dart';
import 'package:pbl_studentend_clubbed/categories_screen.dart';
import 'package:pbl_studentend_clubbed/main_drawer.dart';
import 'package:flutter/material.dart';
import 'main_drawer.dart';
import 'categories_screen.dart';
import 'meal.dart';

class TabsScreen extends StatefulWidget {
  List<Meal> cartMeals;
  Function orderPlaced;
  TabsScreen(this.cartMeals,this.orderPlaced);
  static const routeName = '/tabsscreen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Smart Canteen'),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.category), text: 'Categories'),
                Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
              ],
            ),
          ),
          drawer: MainDrawer(),
          body: TabBarView(
            children: <Widget>[
              CategoriesScreen(),
              CartScreen(widget.cartMeals,widget.orderPlaced),
            ],
          ),
        ));
  }
}
