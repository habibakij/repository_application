import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_template/data/model/home_screen/repo_model.dart';
import 'package:flutter_bloc_template/data/repositories/home_screen_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeScreenRepository _repository = HomeScreenRepository();
  int _currentPage = 1;
  bool _hasMoreData = true;
  List<Item> _allItems = [];

  HomeBloc() : super(HomeInitialState()) {
    on<HomeEventInitial>((event, emit) async {
      emit(RepoLoadingState());
      await _fetchData(emit, isInitialLoad: true);
    });

    on<LoadMoreItemsEvent>((event, emit) async {
      if (_hasMoreData) {
        await _fetchData(emit);
      }
    });
  }

  Future<void> _fetchData(Emitter<HomeState> emit,
      {bool isInitialLoad = false}) async {
    try {
      final data =
          await _repository.fetchItems(page: _currentPage, perPage: 10);

      if (isInitialLoad) {
        _allItems = data.items ?? [];
      } else {
        _allItems.addAll(data.items ?? []);
      }

      // 🔹 Ensure Sorting Consistency: Sort by stars in descending order
      _allItems.sort(
          (a, b) => (b.stargazersCount ?? 0).compareTo(a.stargazersCount ?? 0));

      _hasMoreData = data.items != null && data.items!.isNotEmpty;
      if (_hasMoreData) _currentPage++;

      emit(RepoLoadedState(
          listItem: List.from(_allItems), hasMore: _hasMoreData));
    } catch (e) {
      emit(RepoErrorState(e.toString()));
    }
  }
}
