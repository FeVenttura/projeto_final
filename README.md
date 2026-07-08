# Curso 
    
- Análise e Desenvolvimento de Sistemas

# Matriz Curricular
    
- Desenvolvimento para Dispositivos Móveis

# Alunos

- Fernando Ventura.           GitHub: https://github.com/FeVenttura
- Jonathan Antonio Marcilio.  GitHub: https://github.com/JonathanAntonioMarcilio
- Lucas Medeira.              GitHub: https://github.com/MedeiraLucas

# Tecnologias Utilizadas

O projeto foi desenvolvido utilizando as seguintes tecnologias:

- **Flutter**
  - Framework utilizado para o desenvolvimento da interface gráfica multiplataforma.

- **Dart**
  - Linguagem de programação utilizada para implementação da aplicação.

- **Material Design 3**
  - Utilizado para construção da interface moderna e responsiva.

- **HTTP Package**
  - Responsável pelas requisições HTTP realizadas para a API da Open Library.

- **Shared Preferences**
  - Utilizado para armazenar localmente os livros favoritados pelo usuário.

- **Open Library API**
  - API pública utilizada para pesquisar livros e obter informações detalhadas das obras.

---

# Arquitetura do Projeto

O projeto foi dividido em telas e serviços, facilitando a organização do código.

## Telas

- **HomeScreen**
  - Responsável pela navegação entre as telas de pesquisa e favoritos através da NavigationBar.

- **SearchScreen**
  - Permite pesquisar livros utilizando palavras-chave.
  - Exibe os resultados retornados pela API.

- **BookDetailScreen**
  - Mostra os detalhes do livro selecionado.
  - Carrega automaticamente a descrição da obra.
  - Permite adicionar ou remover o livro dos favoritos.

- **FavoritesScreen**
  - Lista todos os livros favoritados.
  - Permite abrir os detalhes ou remover um livro da lista.

## Serviços

### ApiService

Responsável pela comunicação com a API da Open Library.

Funções implementadas:

- Buscar livros por título, autor ou palavra-chave;
- Buscar descrição detalhada da obra;
- Tratamento de erros como:
  - Falta de conexão;
  - Timeout;
  - Erros do servidor.

### StorageService

Responsável pelo armazenamento local utilizando **SharedPreferences**.

Funcionalidades:

- Salvar favoritos;
- Remover favoritos;
- Recuperar favoritos salvos;
- Verificar se um livro já está favoritado.

---

# Funcionalidades

O aplicativo possui as seguintes funcionalidades:

- Pesquisa de livros por título, autor ou palavra-chave;
- Exibição da capa do livro;
- Visualização de:
  - título;
  - autor;
  - ano de publicação;
  - descrição da obra;
- Favoritar livros;
- Remover livros dos favoritos;
- Persistência dos favoritos mesmo após fechar o aplicativo;
- Navegação entre Pesquisa e Favoritos;
- Tratamento de erros de conexão e indisponibilidade da API.

---

# Dependências Utilizadas

As principais dependências utilizadas no projeto são:

```yaml
flutter
http
shared_preferences
```

---

# Instalação

## 1. Clonar o repositório

```bash
git clone https://github.com/SEU-USUARIO/NOME-DO-REPOSITORIO.git
```

## 2. Entrar na pasta do projeto

```bash
cd NOME-DO-REPOSITORIO
```

## 3. Instalar as dependências

```bash
flutter pub get
```

## 4. Executar o projeto

Conecte um dispositivo físico ou inicie um emulador e execute:

```bash
flutter run
```

---

# Estrutura do Projeto

```
lib/
│
├── models/
│     └── book.dart
│
├── screens/
│     ├── home_screen.dart
│     ├── search_screen.dart
│     ├── favorites_screen.dart
│     └── detail_screen.dart
│
├── services/
│     ├── api_service.dart
│     └── storage_service.dart
│
└── main.dart
```

---

# API Utilizada

O aplicativo utiliza a API pública da **Open Library** para realizar consultas de livros.

Documentação:

https://openlibrary.org/developers/api

---

# Demonstração das Funcionalidades

- Pesquisa de livros utilizando palavras-chave;
- Visualização de informações detalhadas;
- Consulta da descrição da obra;
- Adição e remoção de favoritos;
- Armazenamento local dos favoritos.

---
