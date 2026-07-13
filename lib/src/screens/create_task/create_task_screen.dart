import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/cubits/task_cubit.dart';
import 'package:task_manager/src/screens/create_task/widgets/info_banner.dart';
import 'package:task_manager/src/screens/create_task/widgets/section_header.dart';
import 'package:task_manager/src/theme/app_colors.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _saveEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateSaveButton);
    _descriptionController.addListener(_updateSaveButton);
  }

  void _updateSaveButton() {
    final enabled =
        _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
    if (enabled != _saveEnabled) {
      setState(() => _saveEnabled = enabled);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      context.read<TaskCubit>().addTask(
        title: _titleController.text,
        description: _descriptionController.text,
      );
      Navigator.pop(context);
    }
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova Tarefa',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.inputBorderDark,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 14),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(label: 'Informações da Tarefa'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Título *'),
                validator: (v) =>
                    _requiredValidator(v, 'O título não pode ser vazio'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 8,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Descrição *',
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    _requiredValidator(v, 'A descrição não pode ser vazia'),
              ),
              const SizedBox(height: 32),
              const InfoBanner(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveEnabled ? _save : null,
                icon: const Icon(Icons.check),
                label: const Text('Salvar Tarefa'),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: theme.brightness == Brightness.light
                      ? AppColors.completedBackground
                      : AppColors.completedBackgroundDark,
                  disabledForegroundColor: AppColors.completedText,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  side: BorderSide(color: theme.colorScheme.primary),
                  foregroundColor: theme.colorScheme.onSurface,
                ),
                child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
