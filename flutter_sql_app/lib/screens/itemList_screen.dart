import 'package:flutter/material.dart';
import 'package:flutter_sql_app/providers/itemList_provider.dart';
import 'package:flutter_sql_app/screens/editItem_screen.dart';
import 'package:provider/provider.dart';

class ItemListScreen extends StatefulWidget {
  static String routeName = '/item-list';

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  Future? _itemsFuture;

  Future _obtainItemsFuture() {
    return Provider.of<ItemList>(context, listen: false).fetchAndSetItems();
  }

  @override
  void initState() {
    _itemsFuture = _obtainItemsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final itemsData = Provider.of<ItemList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditItemScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _itemsFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Consumer<ItemList>(builder: (context, listValue, child) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: listValue.items[index],
                        child: Dismissible(
                          key: ValueKey(listValue.items[index]),
                          background: Container(
                            color: Theme.of(context).errorColor,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 40,
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 4,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) {
                            return showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                    'Do you want to remove the item?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop(false);
                                      },
                                      child: const Text('No')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop(true);
                                      },
                                      child: const Text('Yes')),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            Provider.of<ItemList>(context, listen: false)
                                .deleteItem(listValue.items[index]);
                          },
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(listValue.items[index].title),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    EditItemScreen.routeName,
                                    arguments: listValue.items[index].id);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: listValue.items.length,
                  );
                });
        },
      ),
    );
  }
}
