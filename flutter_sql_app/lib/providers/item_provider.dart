import 'package:flutter/foundation.dart';

class Item with ChangeNotifier {
  int id;
  String title;
  String description;

  Item({
    required this.id,
    required this.title,
    required this.description,
  });

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description};
  }
}
