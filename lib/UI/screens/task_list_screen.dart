import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../../models/tasks.dart';

class TaskListScreen extends StatefulWidget {
  final String userId;
  const TaskListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String priorityFilter = "All";
  String statusFilter = "All";

  @override
  void initState() {
    super.initState();
    assert(widget.userId.isNotEmpty, "userId must not be empty!");
    context.read<TaskBloc>().add(LoadTasks(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        elevation: 4,
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onPrimary),
            onPressed: () {},
            tooltip: "Search",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          children: [
            // STACK filter chips vertically (no overflow!)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterChips(
                  label: "Priority:",
                  filters: const ["All", "Low", "Medium", "High"],
                  selected: priorityFilter,
                  onSelected: (value) {
                    setState(() {
                      priorityFilter = value;
                      _applyFilters();
                    });
                  },
                ),
                const SizedBox(height: 8),
                _buildFilterChips(
                  label: "Status:",
                  filters: const ["All", "Complete", "Incomplete"],
                  selected: statusFilter,
                  onSelected: (value) {
                    setState(() {
                      statusFilter = value;
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Task List
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
                    final tasks = state.tasks;
                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 56,
                              color: colorScheme.primary.withOpacity(0.3),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "No tasks found.",
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: tasks.length,
                      itemBuilder:
                          (context, i) =>
                              _buildTaskCard(tasks[i], colorScheme, theme),
                    );
                  } else if (state is TaskError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Navigator.pushNamed(
              context,
              '/add_task',
              arguments: widget.userId,
            ),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Wrap ensures chips never overflow the screen.
  Widget _buildFilterChips({
    required String label,
    required List<String> filters,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        ...filters.map(
          (f) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: ChoiceChip(
              label: Text(f),
              selected: selected == f,
              onSelected: (_) => onSelected(f),
              selectedColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.16),
              labelStyle: TextStyle(
                color:
                    selected == f
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[800],
                fontWeight: selected == f ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task, ColorScheme colorScheme, ThemeData theme) {
    Color getPriorityColor(String p) {
      switch (p.toLowerCase()) {
        case "high":
          return Colors.redAccent;
        case "medium":
          return Colors.orangeAccent;
        default:
          return Colors.green;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        leading: CircleAvatar(
          backgroundColor: getPriorityColor(task.priority),
          child: Icon(
            task.isCompleted ? Icons.check : Icons.flag,
            color: Colors.white,
          ),
        ),
        title: Text(
          task.title,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color:
                task.isCompleted
                    ? colorScheme.outline
                    : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Due: ${DateFormat('EEE, MMM d • h:mm a').format(task.dueDate)}",
              style: theme.textTheme.bodySmall!.copyWith(
                color:
                    task.isCompleted ? colorScheme.outline : Colors.grey[700],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Chip(
                label: Text(
                  task.priority[0].toUpperCase() + task.priority.substring(1),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: getPriorityColor(task.priority),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.deepPurple),
              onPressed:
                  () => Navigator.pushNamed(
                    context,
                    '/edit_task',
                    arguments: task,
                  ),
              tooltip: "Edit",
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                context.read<TaskBloc>().add(DeleteTask(task));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Task deleted!"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              tooltip: "Delete",
            ),
            IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.green,
              ),
              onPressed: () {
                final updatedTask = task.copyWith(
                  isCompleted: !task.isCompleted,
                );
                context.read<TaskBloc>().add(UpdateTask(updatedTask));
              },
              tooltip: "Toggle Complete",
            ),
          ],
        ),
        onTap:
            () => Navigator.pushNamed(context, '/edit_task', arguments: task),
      ),
    );
  }

  void _applyFilters() {
    if (widget.userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User ID missing!')));
      return;
    }
    context.read<TaskBloc>().add(
      FilterTasks(
        userId: widget.userId,
        priority: priorityFilter == "All" ? null : priorityFilter.toLowerCase(),
        status:
            statusFilter == "All"
                ? null
                : (statusFilter == "Complete" ? true : false),
      ),
    );
  }
}
