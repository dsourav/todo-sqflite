import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/model.dart';


import 'database/repositoryService.dart';


class AddTODO extends StatefulWidget {

  @override
  
  _AddTODOState createState() => _AddTODOState();
}

class _AddTODOState extends State<AddTODO> {
  final TextEditingController _controllerText = TextEditingController();

 
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            transitionBetweenRoutes: false,
            automaticallyImplyLeading: false,
            largeTitle: Text("Que vols fer?"),
          ),
          SliverFillRemaining(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  CupertinoTextField(
                    controller: _controllerText,
                    placeholder: 'Escriu una tasca...',
                    style: TextStyle(
                        fontSize: 25.0, color: CupertinoColors.inactiveGray),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    placeholderStyle: TextStyle(
                        fontSize: 25.0, color: CupertinoColors.inactiveGray),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CupertinoButton(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: CupertinoColors.inactiveGray),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      CupertinoButton(
                        color: CupertinoColors.activeOrange,
                        child: Text(
                          'Crear tasca',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                        onPressed: ()async {
                          if (_controllerText.text.length > 0) {
                           // _addItem(_controllerText.text);

                           int count=await RepositoryService.todosCount();
                           final todo = Todo(count,_controllerText.text , false);
                           RepositoryService.addTodo(todo).then((_){
                             _controllerText.clear();
                            Navigator.pop(context,true);

                           });
                            
                          } else {
                            _showErrorDialouge(context);
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _showErrorDialouge(context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data:ThemeData.light() ,
                      child: CupertinoAlertDialog(
              title: Text('Ouch...!'),
              content: Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text('Has de crear una tasca per afegir-la')),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true, 
                    child: new Text("Ok"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    )
              ],
            ),
          );
        });
  }
}
