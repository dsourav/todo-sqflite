import 'databaseHelper.dart';
import 'package:todo/model/model.dart';

class RepositoryService{
  static Future<List<Todo>> getAllTodos() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.todoTable}''';
    final data = await db.rawQuery(sql);
    List<Todo> todos = List();

    for (final node in data) {
      final todo = Todo.fromJson(node);
      todos.add(todo);
    }
    return todos;
  }

  static Future<void> addTodo(Todo todo) async {
     final sql = '''INSERT INTO ${DatabaseCreator.todoTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.name},
      ${DatabaseCreator.isSelected}
    )
    VALUES (?,?,?)''';
     List<dynamic> params = [todo.id, todo.name,  todo.isSelected ? 1 : 0];
         final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add todo', sql, null, result, params);
  }

  static Future<void> updateTodo(Todo todo) async {
     final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.isSelected} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';
       List<dynamic> params = [!todo.isSelected?1:0, todo.id];
        final result = await db.rawUpdate(sql, params);
          DatabaseCreator.databaseLog('Update todo', sql, null, result, params);
  }

    static Future<int> todosCount() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.todoTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
 static  Future<int> delete(int id) async {    
   //var dbClient =  db;    
   return await db.delete(    
     '${DatabaseCreator.todoTable}',    
     where: 'id = ?',    
     whereArgs: [id],    
   );    
 } 
}