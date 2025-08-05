import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../bloc/task/task_bloc.dart';
import '../../bloc/task/task_event.dart';
import '../../bloc/task/task_state.dart';
import '../../models/tasks.dart';

class AddEditTaskScreen extends StatefulWidget {
  final String? userId;
  final Task? existingTask;
  const AddEditTaskScreen({Key? key, this.userId, this.existingTask})
    : assert(
        userId != null || existingTask != null,
        'userId required for adding, or existingTask for editing',
      ),
      super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _descC = TextEditingController();
  DateTime? _dueDate;
  String _priority = 'medium';

  bool get isEdit => widget.existingTask != null;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final t = widget.existingTask!;
      _titleC.text = t.title;
      _descC.text = t.description;
      _dueDate = t.dueDate;
      _priority = t.priority;
    }
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _dueDate ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (ctx, child) => Theme(data: Theme.of(context), child: child!),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      } else {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
          );
        });
      }
    }
  }

  void _onSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a due date/time.')),
      );
      return;
    }

    // ✅ Always get current user's UID from Firebase Auth in case navigation missed it.
    final currentUser = FirebaseAuth.instance.currentUser;
    if (!isEdit && currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not logged in. Please sign in again.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      if (isEdit) {
        final updated = widget.existingTask!.copyWith(
          title: _titleC.text.trim(),
          description: _descC.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
        );
        context.read<TaskBloc>().add(UpdateTask(updated));
      } else {
        final id = FirebaseFirestore.instance.collection('tasks').doc().id;
        // Always use Firebase UID for creatorId (never trust navigation alone)
        final creatorId = currentUser!.uid;
        context.read<TaskBloc>().add(
          AddTask(
            Task(
              id: id,
              title: _titleC.text.trim(),
              description: _descC.text.trim(),
              dueDate: _dueDate!,
              isCompleted: false,
              priority: _priority,
              creatorId: creatorId,
            ),
          ),
        );
      }
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving: $e")));
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(isEdit ? "Edit Task" : "Add Task"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        elevation: 2,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEdit ? "Edit your task" : "Create new task",
                        style: GoogleFonts.oswald(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _titleC,
                        decoration: InputDecoration(
                          labelText: "Title",
                          prefixIcon: const Icon(Icons.title_rounded),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        maxLength: 40,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? "Title required"
                                    : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _descC,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Description",
                          prefixIcon: const Icon(Icons.notes_rounded),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? "Description required"
                                    : null,
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: _submitting ? null : () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Due Date & Time",
                              prefixIcon: Icon(
                                Icons.event,
                                color: colorScheme.primary,
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            controller: TextEditingController(
                              text:
                                  _dueDate == null
                                      ? ""
                                      : DateFormat(
                                        'EEE, MMM d • h:mm a',
                                      ).format(_dueDate!),
                            ),
                            validator:
                                (v) =>
                                    (_dueDate == null)
                                        ? "Pick a due date"
                                        : null,
                            readOnly: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Priority",
                          prefixIcon: const Icon(Icons.flag_rounded),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        value: _priority,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: "low",
                            child: Text(
                              "Low",
                              style: TextStyle(color: Colors.green[700]),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "medium",
                            child: Text(
                              "Medium",
                              style: TextStyle(color: Colors.orange[800]),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "high",
                            child: Text(
                              "High",
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ],
                        onChanged:
                            _submitting
                                ? null
                                : (val) => setState(() => _priority = val!),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  _submitting
                                      ? null
                                      : () => Navigator.of(context).maybePop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colorScheme.primary,
                                side: BorderSide(
                                  color: colorScheme.primary,
                                  width: 1.3,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  _submitting ? null : () => _onSubmit(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child:
                                  _submitting
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        isEdit ? "Save Changes" : "Add Task",
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
