import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tasks.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  Future<void> addTask(Task task) async {
    await _tasksCollection.doc(task.id).set(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  Stream<List<Task>> getTasksForUser(String userId) {
    return _tasksCollection
        .where('creator', isEqualTo: userId)
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Task.fromJson(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList(),
        );
  }

  Stream<List<Task>> getFilteredTasks(
    String userId,
    String? priority,
    bool? completed,
  ) {
    Query query = _tasksCollection.where('creator', isEqualTo: userId);

    if (priority != null) {
      query = query.where('priority', isEqualTo: priority);
    }
    if (completed != null) {
      query = query.where('isCompleted', isEqualTo: completed);
    }

    query = query.orderBy('dueDate');

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    Task.fromJson(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
    );
  }
}
