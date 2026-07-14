import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/src/models/task.dart';
import 'package:task_manager/src/repositories/task_storage.dart';
import 'package:task_manager/src/cubits/task_cubit.dart';

/// Fake em memória — estende TaskStorage e sobrescreve os métodos,
/// evitando dependência de shared_preferences (e de pacotes de mock) nos testes.
class _FakeTaskStorage extends TaskStorage {
  List<Task> stored;
  int saveCallCount = 0;

  _FakeTaskStorage({List<Task>? initial}) : stored = initial ?? [];

  @override
  Future<List<Task>> loadTasks() async => List<Task>.from(stored);

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    saveCallCount++;
    stored = List<Task>.from(tasks);
  }
}

void main() {
  // data fixa pro createdAt, injetada via `now`, deixa os testes determinísticos
  final fixedNow = DateTime(2026, 7, 14, 9, 0);

  // aguarda o _loadInitialData() async disparado no construtor concluir
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  group('inicialização', () {
    test('começa com estado vazio quando não há dados salvos', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      expect(cubit.state.tasks, isEmpty);
      expect(cubit.state.pendingCount, 0);
      addTearDown(cubit.close);
    });

    test('carrega tarefas persistidas na inicialização', () async {
      final existing = Task(
        id: 5,
        title: 'Persistida',
        description: 'x',
        createdAt: fixedNow,
      );
      final cubit = TaskCubit(
        storage: _FakeTaskStorage(initial: [existing]),
        now: () => fixedNow,
      );
      await settle();

      expect(cubit.state.tasks, [existing]);
      addTearDown(cubit.close);
    });
  });

  group('addTask', () {
    test('adiciona a tarefa no TOPO da lista', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'Primeira', description: 'a');
      cubit.addTask(title: 'Segunda', description: 'b');

      expect(cubit.state.tasks.first.title, 'Segunda');
      expect(cubit.state.tasks.length, 2);
      addTearDown(cubit.close);
    });

    test('nova tarefa nasce como pendente (isDone = false)', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'Nova', description: 'a');

      expect(cubit.state.tasks.first.isDone, isFalse);
      addTearDown(cubit.close);
    });

    test('registra createdAt usando o relógio injetado', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'Nova', description: 'a');

      expect(cubit.state.tasks.first.createdAt, fixedNow);
      addTearDown(cubit.close);
    });

    test('persiste a lista após adicionar', () async {
      final storage = _FakeTaskStorage();
      final cubit = TaskCubit(storage: storage, now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'Nova', description: 'a');
      await settle();

      expect(storage.stored.length, 1);
      addTearDown(cubit.close);
    });

    test('pendingCount reflete apenas tarefas não concluídas', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'A', description: 'a');
      cubit.addTask(title: 'B', description: 'b');

      expect(cubit.state.pendingCount, 2);
      addTearDown(cubit.close);
    });
  });

  group('completeTask', () {
    test('marca a tarefa correta como concluída', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'Tarefa', description: 'a');
      final id = cubit.state.tasks.first.id;

      cubit.completeTask(id);

      expect(cubit.state.tasks.first.isDone, isTrue);
      expect(cubit.state.pendingCount, 0);
      addTearDown(cubit.close);
    });

    test('concluir é irreversível: chamar de novo mantém concluída', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'Tarefa', description: 'a');
      final id = cubit.state.tasks.first.id;

      cubit.completeTask(id);
      cubit.completeTask(id); // segunda chamada não deve "desmarcar"

      expect(cubit.state.tasks.first.isDone, isTrue);
      addTearDown(cubit.close);
    });

    test('não afeta outras tarefas', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'A', description: 'a');
      cubit.addTask(title: 'B', description: 'b');
      final idB = cubit.state.tasks.first.id; // B está no topo

      cubit.completeTask(idB);

      final a = cubit.state.tasks.firstWhere((t) => t.title == 'A');
      expect(a.isDone, isFalse);
      addTearDown(cubit.close);
    });
  });

  group('deleteTask', () {
    test('remove apenas a tarefa com o id informado', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'A', description: 'a');
      cubit.addTask(title: 'B', description: 'b');
      final idTopo = cubit.state.tasks.first.id;

      cubit.deleteTask(idTopo);

      expect(cubit.state.tasks.length, 1);
      expect(cubit.state.tasks.any((t) => t.id == idTopo), isFalse);
      addTearDown(cubit.close);
    });
  });

  group('search', () {
    test('filtra visibleTasks por título (case-insensitive)', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'Comprar pão', description: 'a');
      cubit.addTask(title: 'Estudar Flutter', description: 'b');

      cubit.search('flutter');

      expect(cubit.state.visibleTasks.length, 1);
      expect(cubit.state.visibleTasks.first.title, 'Estudar Flutter');
      expect(cubit.state.isSearching, isTrue);
      addTearDown(cubit.close);
    });

    test('query vazia mostra todas as tarefas', () async {
      final cubit = TaskCubit(storage: _FakeTaskStorage(), now: () => fixedNow);
      await settle();

      cubit.addTask(title: 'A', description: 'a');
      cubit.addTask(title: 'B', description: 'b');

      cubit.search('');

      expect(cubit.state.visibleTasks.length, 2);
      expect(cubit.state.isSearching, isFalse);
      addTearDown(cubit.close);
    });
  });
}