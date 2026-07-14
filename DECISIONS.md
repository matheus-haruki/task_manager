# DECISIONS.md
Este documento registra as principais decisões técnicas, de arquitetura e de UI/UX tomadas durante o desenvolvimento do Task Manager, além de documentar o uso de ferramentas de IA ao longo do desafio.
---
## 1. Arquitetura
### Gerenciamento de estado: Cubit (flutter_bloc)
Optei por **Cubit** em vez de `setState`, Provider ou Riverpod pelos seguintes motivos:
- **Separação clara** entre a camada de UI e a lógica de negócio. Toda a regra (adicionar, concluir, deletar, buscar, ordenar) vive no `TaskCubit`, deixando os widgets responsáveis apenas por renderizar o estado.
- **Testabilidade:** por não depender do ciclo de vida de widgets, a lógica pôde ser testada de forma isolada e determinística (ver seção de Testes).
- **Simplicidade sobre BLoC completo:** o Cubit oferece o essencial do padrão BLoC sem a verbosidade de eventos, o que é adequado ao escopo do desafio.
### Estrutura de pastas (feature-first)
```
lib/src/
├── cubits/        # estado (task_cubit, task_state, theme_cubit)
├── models/        # domínio (task, sort_option)
├── repositories/  # persistência (task_storage)
├── screens/       # telas, cada uma com seus widgets locais
├── theme/         # design system (cores, tema, extensions)
├── utils/         # helpers (date_formatter)
└── widgets/       # widgets compartilhados entre telas
```
Cada tela agrupa seus próprios widgets em uma subpasta `widgets/`, mantendo proximidade entre o que é usado junto. Widgets realmente reutilizáveis (bottom sheets base) ficam em `lib/src/widgets/`.
### Estado imutável
Tanto `Task` quanto `TaskState` são **imutáveis** (`final` + `copyWith` + `==`/`hashCode`). Isso torna as transições de estado previsíveis e evita mutações acidentais — cada mudança gera um novo estado.
### Injeção de dependências no Cubit
O `TaskCubit` recebe o relógio (`DateTime Function() now`) e o `TaskStorage` via construtor. Essa escolha foi deliberada para **testabilidade**: nos testes injeto um relógio fixo e um storage fake em memória, sem depender de `DateTime.now()` real nem de `shared_preferences`.
---
## 2. Regras de Negócio
### Imutabilidade da conclusão
A regra "uma tarefa concluída não pode ser desmarcada" foi implementada em duas camadas:
- No **modelo**, `Task.complete()` é idempotente: `isDone ? this : copyWith(isDone: true)`. Não existe método `uncomplete()`.
- No **Cubit**, `completeTask()` apenas chama `task.complete()`, nunca revertendo o status.
> Evolução possível: o `copyWith` ainda permitiria `isDone: false` em teoria. A irreversibilidade é garantida pela API exposta (não há caminho que desmarque), mas um refinamento seria encapsular ainda mais esse invariante no tipo.
### Validação de entrada
Título e descrição são validados no formulário de cadastro (não podem ser vazios ou apenas espaços), e o `Task.create` aplica `.trim()` para normalizar a entrada. O botão "Salvar" permanece desabilitado enquanto os campos forem inválidos.
---
## 3. Escolha de Pacotes
O desafio recomenda **não abusar de pacotes** do pub.dev. Segui o princípio de adicionar dependências apenas quando o ganho justificasse claramente o custo.
### Por que NÃO usei o `intl`
O único requisito de formatação de data era o padrão `dd/MM/yyyy HH:mm`. Trazer o pacote `intl` (relativamente pesado, voltado a i18n/localização completa) para resolver **um único formato** seria desproporcional. Optei por um helper próprio (`date_formatter.dart`) que faz o padding manual dos componentes da data. Isso:
- Mantém as dependências enxutas.
- Deixa explícito e testável exatamente o formato exigido.
- Alinha-se à orientação do desafio de preferir soluções próprias quando simples.
### Por que usei o `shared_preferences`
Utilizei `shared_preferences` para implementar a **persistência local**, que consta na lista de *bonus points* do desafio. Escolhi-o em vez de `sqflite`/`hive` porque:
- Os dados são uma lista simples serializável em JSON — não há relações nem consultas que justifiquem um banco de dados.
- É leve, oficial (mantido pelo time do Flutter) e amplamente adotado.
### Por que usei o `flutter_bloc`
É a biblioteca padrão para o padrão BLoC/Cubit, madura e amplamente adotada, com excelente suporte a testes. O ganho em organização e testabilidade justificou a dependência.
> **Nota sobre "sem persistência":** as regras de negócio mencionam "dados em memória / sem banco de dados", enquanto os bonus points premiam persistência local via SharedPreferences. Interpretei a regra como "sem backend / sem banco relacional", e implementei a persistência como camada opcional (bonus), mantendo intacto o funcionamento em memória durante a sessão. Documento aqui essa interpretação por ser um ponto ambíguo do enunciado.
---
## 4. Decisões de UI/UX
### Identidade visual
A interface se **inspira na linguagem visual do aplicativo da XP** (paleta, tipografia e hierarquia visual), buscando um resultado limpo e profissional alinhado à identidade da empresa. Nenhum ativo proprietário (logotipos, ícones oficiais ou imagens) foi utilizado — apenas princípios de design (cores, espaçamento, peso tipográfico).
### Design system próprio
Centralizei cores, tipografia e estilos em `lib/src/theme/`, usando `ThemeExtension` (`app_theme_extension.dart`) para expor cores customizadas via `context.appColors`. Isso garante consistência visual e facilita a manutenção, além de dar suporte nativo a temas claro e escuro.
### Fonte Inter
Adotei a família **Inter** (empacotada como asset) por sua excelente legibilidade em interfaces densas de texto e por transmitir um tom moderno e profissional.
### Tema dinâmico (claro/escuro)
A seleção de tema é feita via `theme_cubit.dart` e apresentada em um bottom sheet dedicado, permitindo ao usuário alternar entre claro/escuro/sistema.
### Feedback e estados visuais
- **Tarefas concluídas** recebem tratamento visual distinto (opacidade reduzida, strike-through no título), tornando o status imediatamente perceptível.
- **Empty state** dedicado quando não há tarefas, orientando o usuário.
- **Contador de pendentes** no header, com pluralização correta ("1 pendente" / "N pendentes").
### Padrões de interação
- **Bottom sheets** para ações secundárias (ordenação, seleção de tema, detalhes da tarefa) — padrão mobile-first que mantém o contexto da tela.
- **Swipe para deletar** (`Dismissible`) com um fundo visual de exclusão e **confirmação** antes de remover, evitando remoções acidentais.
- **Modal de detalhes** para visualizar a tarefa completa sem sair da Home.
### Responsividade
Ajustes de layout para o modo paisagem (landscape), evitando overflow e sobreposições, garantindo boa experiência em diferentes orientações.
---
## 5. Testes
A suíte cobre o **domínio** e a **lógica de gerência** (29 testes):
- `task_test.dart`: criação/trim, conclusão idempotente, `copyWith`, serialização (round-trip) e igualdade.
- `task_cubit_test.dart`: inserção no topo, status inicial pendente, conclusão irreversível, contagem de pendentes, deleção e busca.
- `sort_option_test.dart`: ordenação por data e por status.
Para manter os testes **rápidos e sem dependências externas**, criei um `_FakeTaskStorage` manual (estendendo `TaskStorage`) em vez de usar bibliotecas de mock, e injetei um relógio fixo para tornar as datas determinísticas.
---
## 6. Uso de IA
### Motivador
Utilizei IA como ferramenta de apoio para acelerar decisões pontuais, revisar boas práticas e esclarecer dúvidas — sem substituir o entendimento do código, que revisei e validei integralmente.
### Ferramentas
- **Claude** (Anthropic) — ferramenta principal
- **Gemini** (Google) — apoio complementar
### Onde e como usei
- **Escolha e substituição de pacotes:** avaliei alternativas (ex.: evitar `intl` em favor de um helper próprio) discutindo trade-offs com a IA.
- **Identidade visual:** apoio para traduzir a linguagem visual de referência (XP) em uma paleta e tipografia próprias.
- **Estruturação e boas práticas:** revisão da organização de pastas, imutabilidade e testabilidade do código.
- **Swipe para deletar:** apoio na implementação do gesto com `Dismissible` e no fluxo de confirmação.
- **Testes unitários:** a IA me ajudou a estruturar a suíte de testes. Forneci o código real da aplicação; os testes foram escritos contra a API existente.
- **Documentação:** apoio na redação e organização do README e deste documento, a partir das decisões técnicas que defini ao longo do projeto.
### Como validei e adaptei
- Todo código sugerido foi **lido, compreendido e adaptado** ao contexto do projeto.
- Os testes foram **executados** (`flutter test` → 29/29 aprovados) e revisados linha a linha, inclusive a limpeza de comentários.
- Rodei `dart format .` e `flutter analyze` (sem issues) para garantir qualidade e consistência.
- Descartei sugestões que adicionavam dependências ou complexidade desnecessárias, mantendo o projeto alinhado à orientação de "não abusar de pacotes".