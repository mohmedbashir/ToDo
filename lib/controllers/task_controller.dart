import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> tasksList = <Task>[].obs;

  void getTasks() async {
    List<Map<String, dynamic>> jsontasks = await DBHelper.query();
    tasksList.assignAll(jsontasks.map((data) => Task.fromJson(data)).toList());
  }

  void addTask(Task task) async {
    await DBHelper.insert(task);
    getTasks();
  }

  void deletsTask(int id) async {
    await DBHelper.delete(id);
    getTasks();
  }

  void updateTask(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  void markAsCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
