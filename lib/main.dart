import 'package:flutter/material.dart';

// Função principal que inicia o aplicativo
void main() {
  runApp(const MeuApp());
}

// Classe principal do aplicativo
// StatelessWidget é usada porque essa parte não precisa mudar
class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',

      // Retira a faixa de "Debug" do aplicativo
      debugShowCheckedModeBanner: false,

      // Configura as cores e o estilo geral do aplicativo
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F5),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
      ),

      // Define a primeira tela que será aberta
      home: const TelaLista(),
    );
  }
}

// Classe que representa um produto da lista, 
//funciona como um modelo para guardar os dados de cada item
class Item {
  // Nome do produto
  String nome;

  // Quantidade do produto
  int quantidade;

  // Informa se o produto já foi comprado
  bool comprado;

  // Construtor da classe Item
  Item({
    required this.nome,
    required this.quantidade,

    // o produto começa como não comprado
    this.comprado = false,
  });
}

// Tela principal da lista de compras
// StatefulWidget é usado porque a lista pode mudar
class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

// Classe que controla o estado da tela principal
class _TelaListaState extends State<TelaLista> {

  // Lista que armazena todos os produtos adicionados
  List<Item> itens = [];

  // Função responsável por abrir a tela de cadastro
  Future<void> abrirTelaAdicionar() async {

    // Navigator.push abre uma nova tela
    // await espera a nova tela devolver algum resultado
    final Item? novoItem = await Navigator.push(
      context,

      // Define qual tela será aberta
      MaterialPageRoute(
        builder: (context) => const TelaAdicionarItem(),
      ),
    );

    // Verifica se a tela de cadastro devolveu um produto
    if (novoItem != null) {

      // setState atualiza a tela depois de alterar a lista
      setState(() {
        itens.add(novoItem);
      });

      // Mostra uma mensagem confirmando que o produto foi adicionado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  '${novoItem.nome} adicionado!',
                ),
              ),
            ],
          ),

          // Faz o SnackBar aparecer sobre o conteúdo
          behavior: SnackBarBehavior.floating,

          // Define a cor da mensagem
          backgroundColor: const Color(0xFF2E7D32),

          // Arredonda os cantos da mensagem
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }
  }

  // Função responsável por remover um produto
  void removerItem(int indice) {

    // Guarda o nome antes de remover
    // Isso permite mostrar o nome no SnackBar depois
    final nome = itens[indice].nome;

    // Atualiza a lista removendo o produto escolhido
    setState(() {
      itens.removeAt(indice);
    });

    // Mostra uma mensagem confirmando a remoção
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                '$nome removido da lista',
              ),
            ),
          ],
        ),

        behavior: SnackBarBehavior.floating,

        backgroundColor: Colors.red.shade700,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // Conta quantos produtos possuem comprado = true
    final comprados =
        itens.where((item) => item.comprado).length;

    // Calcula quantos produtos ainda não foram comprados
    final faltam = itens.length - comprados;

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // Cria o cabeçalho principal do aplicativo
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,

            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,

            // Permite criar um cabeçalho maior e personalizado
            flexibleSpace: FlexibleSpaceBar(
              background: Container(

                // Cria um degradê usando dois tons de verde
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      Color(0xFF388E3C),
                      Color(0xFF1B5E20),
                    ],
                  ),
                ),

                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      45,
                      20,
                      18,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      mainAxisAlignment:
                          MainAxisAlignment.end,

                      children: [

                        // Título e ícone do aplicativo
                        Row(
                          children: [

                            // Caixa que contém o ícone
                            Container(
                              padding:
                                  const EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.18),

                                borderRadius:
                                    BorderRadius.circular(14),
                              ),

                              child: const Icon(
                                Icons.shopping_cart,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Nome do aplicativo
                            const Text(
                              'Lista de Compras',

                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Mostra o resumo da lista
                        Row(
                          children: [

                            // Mostra a quantidade de comprados
                            _infoBox(
                              Icons.check_circle_outline,
                              '$comprados',
                              'Comprados',
                            ),

                            const SizedBox(width: 10),

                            // Mostra quantos ainda faltam
                            _infoBox(
                              Icons.shopping_basket_outlined,
                              '$faltam',
                              'Faltam',
                            ),

                            const SizedBox(width: 10),

                            // Mostra o total de produtos
                            _infoBox(
                              Icons.list_alt,
                              '${itens.length}',
                              'Total',
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

          // Verifica se a lista está vazia
          if (itens.isEmpty)

            // Área que ocupa o espaço disponível
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      // Ícone mostrado quando não existem produtos
                      Container(
                        padding: const EdgeInsets.all(25),

                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 65,
                          color: Colors.green.shade600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Mensagem para o usuário
                      const Text(
                        'Sua lista está vazia',

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Texto explicando o que fazer
                      Text(
                        'Adicione produtos para começar\n'
                        'a organizar suas compras.',

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          // Caso existam produtos, mostra a lista
          else

            // Adiciona espaçamento ao redor da lista
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                14,
                15,
                14,
                90,
              ),

              // Cria a lista de produtos
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(

                  // Essa função cria cada item da lista
                  (context, indice) {

                    // Pega o produto que está naquela posição
                    final item = itens[indice];

                    // Cria o Card daquele produto
                    return _cardItem(
                      item,
                      indice,
                    );
                  },

                  // Define quantos itens serão criados
                  childCount: itens.length,
                ),
              ),
            ),
        ],
      ),

      // Único botão para adicionar novos produtos
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: abrirTelaAdicionar,

        backgroundColor:
            const Color(0xFF2E7D32),

        foregroundColor: Colors.white,

        elevation: 5,

        // Ícone de adicionar
        icon: const Icon(Icons.add),

        // Texto do botão
        label: const Text(
          'Adicionar',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Função que cria os pequenos indicadores
  // mostrados no cabeçalho
  Widget _infoBox(
    IconData icone,
    String numero,
    String texto,
  ) {
    return Expanded(
      child: Container(

        // Espaçamento interno
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),

        // Fundo transparente
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          children: [

            // Ícone do indicador
            Icon(
              icone,
              size: 19,
              color: Colors.white,
            ),

            const SizedBox(height: 2),

            // Número do indicador
            Text(
              numero,

              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Nome do indicador
            Text(
              texto,

              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função responsável por criar o Card de cada produto
  Widget _cardItem(
    Item item,
    int indice,
  ) {
    return AnimatedContainer(

      // Pequena animação quando o produto muda
      duration: const Duration(
        milliseconds: 250,
      ),

      margin: const EdgeInsets.only(
        bottom: 11,
      ),

      // Aparência do Card
      decoration: BoxDecoration(

        // Muda a cor quando o produto é comprado
        color: item.comprado
            ? const Color(0xFFE8F5E9)
            : Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        // Cria uma borda no Card
        border: Border.all(
          color: item.comprado
              ? Colors.green.shade200
              : Colors.grey.shade200,
        ),

        // Cria uma sombra leve
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      // ListTile organiza as informações do produto
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),

        // Checkbox para marcar o produto como comprado
        leading: Checkbox(
          value: item.comprado,

          activeColor:
              const Color(0xFF2E7D32),

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5),
          ),

          // Executado quando o Checkbox é clicado
          onChanged: (valor) {

            // Atualiza o estado do produto
            setState(() {
              item.comprado = valor!;
            });
          },
        ),

        // Nome do produto
        title: Text(
          item.nome,

          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,

            // Deixa o texto cinza quando comprado
            color: item.comprado
                ? Colors.grey.shade500
                : Colors.black87,

            // Risca o nome quando comprado
            decoration: item.comprado
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),

        // Mostra a quantidade do produto
        subtitle: Padding(
          padding:
              const EdgeInsets.only(top: 6),

          child: Row(
            children: [

              // Ícone da quantidade
              Icon(
                Icons.inventory_2_outlined,
                size: 15,

                color: item.comprado
                    ? Colors.grey
                    : Colors.green.shade700,
              ),

              const SizedBox(width: 5),

              // Texto da quantidade
              Text(
                '${item.quantidade} unidade(s)',

                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        // Botão de excluir o produto
        trailing: IconButton(
          onPressed: () {

            // Chama a função de remover
            removerItem(indice);
          },

          icon: const Icon(
            Icons.delete_outline,
          ),

          color: Colors.red.shade400,

          // Texto que aparece ao passar o mouse
          tooltip: 'Remover',
        ),
      ),
    );
  }
}

// Tela responsável por cadastrar um novo produto
class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() =>
      _TelaAdicionarItemState();
}

// Estado da tela de cadastro
class _TelaAdicionarItemState
    extends State<TelaAdicionarItem> {

  // Controller que controla o campo do nome
  // Ele permite pegar o texto digitado pelo usuário
  final TextEditingController nomeController =
      TextEditingController();

  // Controller que controla o campo da quantidade
  final TextEditingController quantidadeController =
      TextEditingController();

  // Função responsável por salvar o produto
  void salvar() {

    // Pega o texto digitado no campo do nome
    final nome =
        nomeController.text.trim();

    // Pega o texto digitado no campo da quantidade
    final quantidadeTexto =
        quantidadeController.text.trim();

    // Verifica se o nome está vazio
    if (nome.isEmpty) {

      // Mostra um aviso para o usuário
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: const Row(
            children: [

              // Ícone de aviso
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),

              SizedBox(width: 8),

              // Mensagem de erro
              Text(
                'Digite o nome do item',
              ),
            ],
          ),

          behavior:
              SnackBarBehavior.floating,

          backgroundColor:
              Colors.orange.shade700,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      );

      // Para a função caso o nome esteja vazio
      return;
    }

    // Converte o texto da quantidade para um número
    // Se não conseguir converter, usa 1 como padrão
    final quantidade =
        int.tryParse(
              quantidadeTexto,
            ) ??
            1;

    // Fecha a tela atual e devolve um novo Item
    // para a tela principal
    Navigator.pop(
      context,

      Item(
        nome: nome,
        quantidade: quantidade,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7F5),

      // Barra superior da tela de cadastro
      appBar: AppBar(
        title: const Text(
          'Adicionar item',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Permite rolar a tela caso necessário
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // Ícone principal da tela
            Center(
              child: Container(
                width: 90,
                height: 90,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.green.shade100,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.shopping_basket_outlined,

                  size: 45,

                  color:
                      Colors.green.shade700,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Título da tela
            const Text(
              'Novo produto',

              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            // Pequena explicação
            Text(
              'Informe o nome e a quantidade do produto.',

              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 28),

            // Campo para digitar o nome
            TextField(
              controller: nomeController,

              decoration:
                  InputDecoration(
                labelText:
                    'Nome do produto',

                hintText:
                    'Ex: Arroz, Leite, Café...',

                // Ícone dentro do campo
                prefixIcon:
                    const Icon(
                  Icons.shopping_basket_outlined,
                ),

                // Coloca um fundo branco
                filled: true,

                fillColor:
                    Colors.white,

                // Borda padrão
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide:
                      BorderSide.none,
                ),

                // Borda quando o campo não está selecionado
                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide:
                      BorderSide(
                    color:
                        Colors.grey.shade200,
                  ),
                ),

                // Borda verde quando o usuário seleciona o campo
                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide:
                      const BorderSide(
                    color:
                        Color(0xFF2E7D32),

                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 17),

            // Campo para digitar a quantidade
            TextField(
              controller:
                  quantidadeController,

              // Mostra o teclado numérico
              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(
                labelText:
                    'Quantidade',

                hintText:
                    'Ex: 2',

                // Ícone do campo
                prefixIcon:
                    const Icon(
                  Icons.numbers,
                ),

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide:
                      BorderSide.none,
                ),

                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide:
                      BorderSide(
                    color:
                        Colors.grey.shade200,
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),

                  borderSide:
                      const BorderSide(
                    color:
                        Color(0xFF2E7D32),

                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Botão que salva o novo produto
            SizedBox(
              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton.icon(
                onPressed: salvar,

                // Ícone do botão
                icon:
                    const Icon(
                  Icons.check_circle_outline,
                ),

                // Texto do botão
                label:
                    const Text(
                  'Adicionar à lista',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                // Estilo do botão
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF2E7D32,
                  ),

                  foregroundColor:
                      Colors.white,

                  elevation: 2,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}