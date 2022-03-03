import 'package:flutter/material.dart';
import 'package:flutter_sql_app/providers/itemList_provider.dart';
import 'package:flutter_sql_app/screens/editItem_screen.dart';
import 'package:flutter_sql_app/screens/itemList_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ItemList(),
      child: MaterialApp(
        title: 'Item Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          ItemListScreen.routeName: (ctx) => ItemListScreen(),
          EditItemScreen.routeName: (ctx) => EditItemScreen(),
        },
        home: ItemListScreen(),
      ),
    );
  }
}
