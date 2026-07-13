import 'package:flutter/material.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int pendingCount;
  final bool hasTasks;
  final SortOption sortOption;
  final VoidCallback onSort;

  const HomeAppBar({
    super.key,
    required this.pendingCount,
    required this.hasTasks,
    required this.sortOption,
    required this.onSort,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  String get _subtitle {
    if (!hasTasks) return 'Nenhuma tarefa cadastrada';
    if (pendingCount == 0) return 'Todas as tarefas concluídas';
    return '$pendingCount ${pendingCount == 1 ? 'pendente' : 'pendentes'}';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Minhas Tarefas',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            _subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Ordenar',
          icon: Badge(
            isLabelVisible: sortOption != SortOption.newestFirst,
            child: const Icon(Icons.sort),
          ),
          onPressed: onSort,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
