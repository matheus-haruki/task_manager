import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/cubits/theme_cubit.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/screens/home/widgets/theme_bottom_sheet.dart';
import 'package:task_manager/src/theme/app_colors.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int pendingCount;
  final bool hasTasks;
  final SortOption sortOption;
  final VoidCallback onSort;

  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onToggleSearch;

  const HomeAppBar({
    super.key,
    required this.pendingCount,
    required this.hasTasks,
    required this.sortOption,
    required this.onSort,
    required this.isSearching,
    required this.searchController,
    required this.onToggleSearch,
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

      titleSpacing: isSearching ? 8 : 16,
      leadingWidth: isSearching ? 50 : 56,
      leading: isSearching
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.inputBorderDark,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 14),
                  tooltip: 'Voltar',
                  onPressed: () {
                    searchController.clear();
                    onToggleSearch();
                  },
                ),
              ),
            )
          : null,

      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isSearching
            ? Container(
                key: const ValueKey('SearchBarActive'),
                height: 40,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                    suffixIcon: Icon(Icons.search, size: 20),
                    hintStyle: TextStyle(fontSize: 15),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              )
            : Align(
                key: const ValueKey('OriginalTitle'),
                alignment: Alignment.centerLeft,
                child: Column(
                  key: const ValueKey('OriginalTitle'),
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
              ),
      ),

      actions: isSearching
          ? []
          : [
              IconButton(
                tooltip: 'Buscar',
                icon: const Icon(Icons.search),
                onPressed: onToggleSearch,
              ),
              IconButton(
                tooltip: 'Aparência',
                icon: const Icon(Icons.brightness_6_outlined),
                onPressed: () async {
                  final currentTheme = context.read<ThemeCubit>().state;

                  final selectedTheme = await ThemeBottomSheet.show(
                    context,
                    currentTheme,
                  );

                  if (selectedTheme != null && context.mounted) {
                    context.read<ThemeCubit>().changeTheme(selectedTheme);
                  }
                },
              ),
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
