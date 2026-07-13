import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/cubits/task_cubit.dart';
import 'package:task_manager/src/cubits/task_state.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/screens/create_task/create_task_screen.dart';
import 'package:task_manager/src/screens/home/widgets/delete_background.dart';
import 'package:task_manager/src/screens/home/widgets/empty_state.dart';
import 'package:task_manager/src/screens/home/widgets/home_app_bar.dart';
import 'package:task_manager/src/screens/home/widgets/sort_sheet.dart';
import 'package:task_manager/src/theme/app_colors.dart';
import 'package:task_manager/src/widgets/confirm_sheet.dart';
import 'package:task_manager/src/screens/home/widgets/task_card.dart';
import 'package:task_manager/src/screens/home/widgets/task_detail_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false; 

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => context.read<TaskCubit>().search(_searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openSortSheet(SortOption current) async {
    final selected = await SortSheet.show(context, current);
    if (selected != null && mounted) {
      context.read<TaskCubit>().sortBy(selected);
    }
  }

  Future<bool?> _confirmDelete() {
    return ConfirmSheet.show(
      context,
      icon: Icons.delete_outline,
      iconColor: AppColors.errorRed,
      title: 'Deletar tarefa',
      message: 'Deseja remover esta tarefa?\nEssa ação não pode ser desfeita.',
      confirmLabel: 'Sim, deletar',
      confirmColor: AppColors.errorRed,
    );
  }

  Future<void> _confirmComplete(int taskId) async {
    final confirm = await ConfirmSheet.show(
      context,
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.errorRed,
      title: 'Concluir tarefa',
      message:
          'Deseja marcar esta tarefa como concluída?\n'
          'Essa ação não pode ser desfeita.',
      confirmLabel: 'Sim, concluir',
    );
    if (confirm == true && mounted) {
      context.read<TaskCubit>().completeTask(taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        final tasks = state.visibleTasks;

        return Scaffold(
          appBar: HomeAppBar(
            pendingCount: state.pendingCount,
            hasTasks: state.tasks.isNotEmpty,
            sortOption: state.sortOption,
            onSort: () => _openSortSheet(state.sortOption),
            isSearching: _isSearching,
            searchController: _searchController,
            onToggleSearch: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: tasks.isEmpty
                      ? EmptyState(isSearching: state.isSearching)
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 100),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Dismissible(
                              key: ValueKey(task.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) => _confirmDelete(),
                              onDismissed: (_) =>
                                  context.read<TaskCubit>().deleteTask(task.id),
                              background: const DeleteBackground(),
                              child: TaskCard(
                                task: task,
                                onComplete: () => _confirmComplete(task.id),
                                onTap: () => TaskDetailModal.show(context, task),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
            ),
            label: const Text('Criar Tarefa'),
          ),
        );
      },
    );
  }
}
