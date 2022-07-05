import 'package:github_client/service/user_api_client.dart';

class Repository {
  final api = UserApiClient();
  dynamic fetchUsers(String query) async {
    return await api.fetchUsers(query);
  }
}
