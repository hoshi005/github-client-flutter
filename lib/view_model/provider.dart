import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_client/model/user.dart';
import 'package:github_client/repository/repository.dart';

final repositoryProvider = Provider((ref) => Repository());

final queryProvider = StateProvider<String>((ref) => 'hoshi005');

final usersProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.read(repositoryProvider);
  final query = ref.watch(queryProvider);
  return await repository.fetchUsers(query);
});
