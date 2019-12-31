import 'package:todo/database/databaseHelper.dart';

class Todo {
  int id;
  String name;

  bool isSelected;

  Todo(this.id, this.name,  this.isSelected);

  Todo.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.name = json[DatabaseCreator.name];
    this.isSelected = json[DatabaseCreator.isSelected] == 1;
  }
}