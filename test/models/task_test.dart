import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/src/models/task.dart';

void main() {
  Task buildTask({
    int id = 1,
    String title = 'Título',
    String description = 'Descrição',
    bool isDone = false,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      createdAt: DateTime(2026, 7, 13, 10, 30),
      isDone: isDone,
    );
  }

  group('Task.create', () {
    test('remove espaços em branco do título e da descrição (trim)', () {
      final task = Task.create(
        id: 1,
        title: '  Comprar pão  ',
        description: '  Ir à padaria  ',
        createdAt: DateTime(2026, 7, 13),
      );

      expect(task.title, 'Comprar pão');
      expect(task.description, 'Ir à padaria');
    });

    test('nova tarefa começa com isDone = false (Em Progresso)', () {
      final task = Task.create(
        id: 1,
        title: 'Nova',
        description: 'Tarefa',
        createdAt: DateTime(2026, 7, 13),
      );

      expect(task.isDone, isFalse);
    });
  });

  group('complete()', () {
    test('marca uma tarefa pendente como concluída', () {
      final task = buildTask(isDone: false);

      final completed = task.complete();

      expect(completed.isDone, isTrue);
    });

    test('não altera os demais campos ao concluir', () {
      final task = buildTask();

      final completed = task.complete();

      expect(completed.id, task.id);
      expect(completed.title, task.title);
      expect(completed.description, task.description);
      expect(completed.createdAt, task.createdAt);
    });

    test('é idempotente: concluir uma tarefa já concluída retorna a mesma instância', () {
      final done = buildTask(isDone: true);

      final result = done.complete();

      expect(identical(result, done), isTrue);
      expect(result.isDone, isTrue);
    });
  });

  group('copyWith', () {
    test('altera apenas os campos informados', () {
      final task = buildTask(title: 'Original');

      final updated = task.copyWith(title: 'Alterado');

      expect(updated.title, 'Alterado');
      expect(updated.id, task.id);
      expect(updated.description, task.description);
      expect(updated.isDone, task.isDone);
    });
  });

  group('serialização (toMap/fromMap/toJson/fromJson)', () {
    test('round-trip via Map preserva todos os campos', () {
      final task = buildTask(isDone: true);

      final restored = Task.fromMap(task.toMap());

      expect(restored, task);
    });

    test('round-trip via JSON preserva todos os campos', () {
      final task = buildTask();

      final restored = Task.fromJson(task.toJson());

      expect(restored, task);
    });

    test('createdAt é serializado em ISO 8601', () {
      final task = buildTask();

      final map = task.toMap();

      expect(map['createdAt'], task.createdAt.toIso8601String());
    });
  });

  group('igualdade (== e hashCode)', () {
    test('duas tarefas com os mesmos campos são iguais', () {
      final a = buildTask();
      final b = buildTask();

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('tarefas com campos diferentes não são iguais', () {
      final a = buildTask(isDone: false);
      final b = buildTask(isDone: true);

      expect(a, isNot(b));
    });
  });
}