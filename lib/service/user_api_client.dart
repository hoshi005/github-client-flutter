import 'package:dio/dio.dart';
import 'package:github_client/model/user.dart';

class UserApiClient {
  Future<List<User>?> fetchUsers(String query) async {
    final dio = Dio();
    const url = 'https://api.github.com/search/users';

    final response = await dio.get(
      url,
      queryParameters: {
        'q': query,
      },
    );

    if (response.statusCode == 200) {
      try {
        final datas = response.data['items'] as List<dynamic>;
        final users = datas.map((user) => User.fromJson(user)).toList();
        return users;
      } catch (e) {
        throw e;
      }
    }

    return null;
  }
}
