import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';


import 'addTodo.dart';
import 'database/databaseHelper.dart';
import 'database/repositoryService.dart';

import 'model/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: CupertinoThemeData(
      //   brightness: Brightness.dark,
      // ),
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Todo>> future;
  String name;
  int id;

  @override
  initState() {
    super.initState();
    future = RepositoryService.getAllTodos();
  }

  final LocalStorage storage = new LocalStorage('todo_app');
  // bool initialized = false;
  // var result;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.black,
            transitionBetweenRoutes: false,
            automaticallyImplyLeading: false,
            largeTitle: Text("NOTIFY",style: TextStyle(color: Colors.white),),
            trailing: CupertinoButton(
              child: Icon(
                CupertinoIcons.add,
                size: 30.0,
                color: CupertinoColors.white,
              ),
              onPressed: () async {
                var result = await Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (BuildContext context) => AddTODO()));
                if (result != null && result) {
                  setState(() {
                    future = RepositoryService.getAllTodos();
                  });
                }
              },
            ),
          ),
          SliverFillRemaining(
            child: Container(
              child: Theme(
                data: ThemeData.dark(),
                child: Material(
                  color: CupertinoColors.black,
                  child: FutureBuilder<List<Todo>>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        
                        
                        return ReorderableListView(
                                    onReorder: (int oldIndex, int newIndex) {
            setState(() {
              _updateMyItems(oldIndex, newIndex,snapshot);
            });
          },
                            children: snapshot.data
                                .map((todo) => buildItem(todo))
                                .toList());
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _updateMyItems(oldIndex, newIndex,snapshot){
          if(newIndex > oldIndex){
        newIndex -= 1;
      }

      final Todo todo=snapshot.data.removeAt(oldIndex);
        snapshot.data.insert(newIndex, todo);
  }

  Widget buildItem(Todo todo) {
    return ListTile(
      key: ValueKey("value${todo.id}"),
      leading: Checkbox(
        value: todo.isSelected,
        onChanged: (bool value) {},
      ),
      title: Text(todo.name),
      onTap: () {
        popUp(todo);
      },
    );
  }

  popUp(Todo todo) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              title: const Text('Marcar com a completada...'),
              message: const Text(''),
              actions: <Widget>[
                todo.isSelected
                    ? CupertinoActionSheetAction(
                        child: const Text('Marcar como imcompleta'),
                        onPressed: () {
                          RepositoryService.updateTodo(todo).then((_) {
                            setState(() {
                              future = RepositoryService.getAllTodos();
                            });
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    : CupertinoActionSheetAction(
                        child: const Text('Marcar como completa'),
                        onPressed: () {
                          RepositoryService.updateTodo(todo).then((_) {
                            setState(() {
                              future = RepositoryService.getAllTodos();
                            });
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                CupertinoActionSheetAction(
                  child: const Text('Eliminar ',
                      style: TextStyle(color: CupertinoColors.destructiveRed)),
                  onPressed: () {
                    RepositoryService.delete(todo.id).then((_){
                       setState(() {
                              future = RepositoryService.getAllTodos();
                            });
                            Navigator.of(context).pop();

                    });
                   
                  },
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ));
  }


}

