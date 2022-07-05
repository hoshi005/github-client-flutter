import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_client/view_model/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  if (Platform.isAndroid) WebView.platform = AndroidWebView();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(usersProvider);
    final stateController = ref.read(queryProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: stateController.state,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (value) {
            stateController.state = value;
          },
        ),
      ),
      body: asyncValue.when(
        data: (users) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index];
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
          );
        },
        error: (e, _) => Text(e.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
