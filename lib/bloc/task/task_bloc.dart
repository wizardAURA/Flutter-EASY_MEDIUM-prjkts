import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/tasks.dart';
import '../../repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  String? _userId;
  String? _activePriorityFilter;
  bool? _activeStatusFilter;

  TaskBloc({required this.taskRepository}) : super(const TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      _userId = event.userId;
      emit(const TaskLoading());

      await emit.forEach<List<Task>>(
        taskRepository.getTasksForUser(event.userId),
        onData: (tasks) {
          if (_activePriorityFilter != null || _activeStatusFilter != null) {
            add(
              FilterTasks(
                userId: event.userId,
                priority: _activePriorityFilter,
                status: _activeStatusFilter,
              ),
            );
            return const TaskLoading();
          }
          return TaskLoaded(tasks);
        },
        onError: (_, __) => const TaskError('Error loading tasks'),
      );
    });

    on<AddTask>((event, emit) async {
      await taskRepository.addTask(event.task);
      if (_userId != null) add(LoadTasks(_userId!));
    });

    on<UpdateTask>((event, emit) async {
      await taskRepository.updateTask(event.task);
      if (_userId != null) add(LoadTasks(_userId!));
    });

    on<DeleteTask>((event, emit) async {
      await taskRepository.deleteTask(event.task.id);
      if (_userId != null) add(LoadTasks(_userId!));
    });

    on<FilterTasks>((event, emit) async {
      _userId = event.userId;
      _activePriorityFilter = event.priority;
      _activeStatusFilter = event.status;
      emit(const TaskLoading());
      await emit.forEach<List<Task>>(
        taskRepository.getFilteredTasks(
          event.userId,
          event.priority,
          event.status,
        ),
        onData: (tasks) => TaskLoaded(tasks),
        onError: (err, _) => const TaskError('Error loading filtered tasks'),
      );
    });
  }
}
