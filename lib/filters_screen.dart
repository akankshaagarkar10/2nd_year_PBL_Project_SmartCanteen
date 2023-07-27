import 'package:pbl_studentend_clubbed/main_drawer.dart';
import 'package:flutter/material.dart';
import 'main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _lactoseFree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your filters'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'adjust filter here',
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                SwitchListTile(
                    title: Text('Gluten-free'),
                    value: _glutenFree,
                    onChanged: (newValue) {
                      setState(() {
                        _glutenFree = newValue;
                      });
                    }),
                SwitchListTile(
                    title: Text('vegetarian'),
                    value: _vegetarian,
                    onChanged: (newValue) {
                      setState(() {
                        _vegetarian = newValue;
                      });
                    }),
                SwitchListTile(
                    title: Text('vegan'),
                    value: _vegan,
                    onChanged: (newValue) {
                      setState(() {
                        _vegan = newValue;
                      });
                    }),
                SwitchListTile(
                    title: Text('lactose-free'),
                    value: _lactoseFree,
                    onChanged: (newValue) {
                      setState(() {
                        _lactoseFree = newValue;
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
