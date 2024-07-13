import 'package:hive_flutter/hive_flutter.dart';


class ToDoDataBase{

List toDoList = [];

final _myBox =Hive.box('mybox');

//run when app is opened for the first time
void createInitialData() {
  toDoList = [
    ["Make an App",false],
    ["Read a Book",false],
  ];
}
//load the data
void loadData() {
  toDoList = _myBox.get("TODOLIST");
}
// update the database
void updateDataBase(){
  _myBox.put("TODOLIST", toDoList);
}
}