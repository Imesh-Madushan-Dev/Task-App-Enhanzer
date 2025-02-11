import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import '../widgets/task_card.dart';

class TaskHistoryScreen extends StatelessWidget {
  const TaskHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task History'),
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final completedTasks = viewModel.tasks.where((task) => task.isCompleted).toList();

          if (completedTasks.isEmpty) {
            return const Center(
              child: Text('No completed tasks yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              return TaskCard(
                task: completedTasks[index],
                isHistory: true,
              );
            },
          );
        },
      ),
    );
  }
} 