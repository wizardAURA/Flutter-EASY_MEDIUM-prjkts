import 'package:equatable/equatable.dart';
import '../../models/tasks.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String userId;
  const LoadTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

// Consistent: This matches your UI code and correct usage
class DeleteTask extends TaskEvent {
  final Task task;
  const DeleteTask(this.task);

  @override
  List<Object?> get props => [task];
}

// The main fix: userId, priority, status
class FilterTasks extends TaskEvent {
  final String userId;
  final String? priority;
  final bool? status;

  const FilterTasks({required this.userId, this.priority, this.status});

  @override
  List<Object?> get props => [userId, priority, status];
}
