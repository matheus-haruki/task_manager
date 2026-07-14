import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/models/task.dart';

void main() {
  Task taskAt(DateTime date, {int id = 0, bool isDone = false}) {
    return Task(
      id: id,
      title: 'T$id',
      description: 'd',
      createdAt: date,
      isDone: isDone,
    );
  }

  final older = taskAt(DateTime(2026, 1, 1), id: 1);
  final newer = taskAt(DateTime(2026, 12, 31), id: 2);

  group('ordenação por data', () {
    test('newestFirst coloca a tarefa mais recente primeiro', () {
      final list = [older, newer]..sort(SortOption.newestFirst.compare);

      expect(list.first, newer);
      expect(list.last, older);
    });

    test('oldestFirst coloca a tarefa mais antiga primeiro', () {
      final list = [newer, older]..sort(SortOption.oldestFirst.compare);

      expect(list.first, older);
      expect(list.last, newer);
    });
  });

  group('ordenação por status', () {
    test('pendingFirst agrupa as pendentes antes das concluídas', () {
      final done = taskAt(DateTime(2026, 6, 1), id: 3, isDone: true);
      final pending = taskAt(DateTime(2026, 6, 2), id: 4, isDone: false);

      final list = [done, pending]..sort(SortOption.pendingFirst.compare);

      expect(list.first.isDone, isFalse);
      expect(list.last.isDone, isTrue);
    });

    test('completedFirst agrupa as concluídas antes das pendentes', () {
      final done = taskAt(DateTime(2026, 6, 1), id: 3, isDone: true);
      final pending = taskAt(DateTime(2026, 6, 2), id: 4, isDone: false);

      final list = [pending, done]..sort(SortOption.completedFirst.compare);

      expect(list.first.isDone, isTrue);
      expect(list.last.isDone, isFalse);
    });
  });

  group('metadados do enum', () {
    test('todos os SortOption têm label e ícone definidos', () {
      for (final option in SortOption.values) {
        expect(option.label, isNotEmpty);
        expect(option.icon, isNotNull);
      }
    });
  });
}
