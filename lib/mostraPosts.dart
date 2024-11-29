import 'package:exame_final_andreia/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // necessário para trabalhar com JSON
import 'package:http/http.dart' as http; // necessário para trabalhar com HTTP

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostListScreen(),
    );
  }
}

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<dynamic> posts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  // Função para fazer a requisição HTTP e retornar a lista de posts
  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.mockfly.dev/mocks/c2915529-223e-481b-b157-13ce2447dd38/news'));
      if (response.statusCode == 200) {
        // Se a requisição for bem-sucedida, converte o JSON em uma lista de posts
        setState(() {
          posts = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar os posts');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Função para deletar um post
  void _deletePost(int index) {
    setState(() {
      posts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Posts'),
      ),
      // não consegui achar outra solução, para mim o tal do FutureBuilder estava atralhando pelo fato de não ter efetividade na hora que eu estava tentando adaptar esse código, pois se você parar para pensar o que recebemos é apenas uma lista, colocar os valores ali, realmente é melhor, porém com essa ligação fica mais facil
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Erro: $errorMessage'))
              : posts.isEmpty
                  ? const Center(child: Text('Nenhum dado encontrado'))
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return NewsItem(
                          source: posts[index]['source'],
                          timeAgo: posts[index]['timeAgo'],
                          text: posts[index]['text'],
                          image: posts[index]['image'],
                          layoutStyle: posts[index]['layoutStyle'],
                          liked: posts[index]['liked'],
                          onDeletePressed: () {
                            // outra coisa não achei que iria funcionar para todos os posts quando vi no começo, por isso a alteração, já que ele refazia a chamada da api toda vez no setState
                            _deletePost(index);
                          },
                        );
                      },
                    ),
    );
  }
}
