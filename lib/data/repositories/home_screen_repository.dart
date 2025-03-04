import 'package:flutter_bloc_template/core/network/api_client.dart';
import 'package:flutter_bloc_template/data/model/home_screen/repo_model.dart';

class HomeScreenRepository {
  Future<RepositoryModel> fetchItems({int page = 1, int perPage = 10}) async {
    final response = await ApiClient.get(
      "repositories?q=org:flutter&sort=stars&order=desc&per_page=$perPage&page=$page",
    );
    return repoModelFromJson(response.toString());
  }
}
