import 'package:flutter/material.dart';
import 'package:flutter_sql_app/providers/itemList_provider.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedItem = Item(
    id: 0,
    title: '',
    description: '',
  );

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_form.currentState != null && _form.currentState!.validate()) {
      _form.currentState?.save();
      if (isNew) {
        _editedItem.id = -1;
        Provider.of<ItemList>(context, listen: false).addItem(_editedItem);
      } else {
        Provider.of<ItemList>(context, listen: false).updateItem(_editedItem);
      }
      Navigator.of(context).pop();
    }
  }

  var _isInit = false;
  bool isNew = true;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final itemId = ModalRoute.of(context)!.settings.arguments as int?;
      if (itemId != null) {
        isNew = false;
        _editedItem = Provider.of<ItemList>(context, listen: false)
            .items
            .firstWhere((element) => element.id == itemId);
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                initialValue: _editedItem.title,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Need title';
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (val) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (val) {
                  if (val != null) {
                    _editedItem.title = val;
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                initialValue: _editedItem.description,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Need description';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (val) {
                  if (val != null) {
                    _editedItem.description = val;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
