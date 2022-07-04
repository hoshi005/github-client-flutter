import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> _users = [];

  Future<void> _fetchUsers(String query) async {
    final response =
        await Dio().get('https://api.github.com/search/users?q=$query');
    List list = response.data['items'];
    _users = list.map((e) => User.fromMap(e)).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers('hoshi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: 'hoshi',
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (value) {
            _fetchUsers(value);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _users.length,
        itemBuilder: (_, index) {
          final user = _users[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(user.login),
                      ),
                      body: WebView(
                        initialUrl: user.htmlUrl,
                      ),
                    );
                  },
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipOval(
                  child: Image.network(
                    user.avatarUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(user.login),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class User {
  final String login;
  final String avatarUrl;
  final String htmlUrl;

  User({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  factory User.fromMap(Map<String, dynamic> user) {
    return User(
      login: user['login'],
      avatarUrl: user['avatar_url'],
      htmlUrl: user['html_url'],
    );
  }
}
