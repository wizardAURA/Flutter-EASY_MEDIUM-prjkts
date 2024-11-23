import 'package:flutter/foundation.dart';
import 'tasks.dart';
import 'package:collection/collection.dart';
class taskData extends ChangeNotifier{
  List<Task> _tasks =[

  ];
  int get taskCount {
    return _tasks.length;
  }
  UnmodifiableListView<Task> get tasks{
    return UnmodifiableListView(_tasks);
  }

  void addTask(String Tasktitle){
    final task = Task(name: Tasktitle);
    _tasks.add(task);
    notifyListeners();
  }
  void updateTask(Task task){
    task.toggleDone();
    notifyListeners();
  }
  void deleteTask (Task task){
    _tasks.remove(task);
    notifyListeners();
  }
}