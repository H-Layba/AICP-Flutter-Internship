import 'package:flutter/material.dart';
import 'package:to_do_list/utilities/dialog_box.dart';
import '../utilities/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//reference
  final _myBox = Hive.box('myBox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    //TODO: initialState

    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }
    else{
      //data already exists
      db.loadData();
    }

    super.initState();

  }


  //text controller
  final _controller = TextEditingController();


  // checkbox
  void checkBoxChanged (bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index] [1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        }
    );
  }

  //delete task
  void deleteTask(int index) {
    setState((){
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200] ,
        appBar: AppBar(
            backgroundColor: Colors.orange[400],
            title: const Center(
              child: Text('TO DO'),
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          backgroundColor: Colors.orange[400],
          child: Icon(Icons.add),
        ),
        body:ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value,index),
              deleteFunction:(context) => deleteTask(index),
            );
          } ,
        )
    );
  }
}