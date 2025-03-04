part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class RepoLoadingState extends HomeState {}

class RepoLoadedState extends HomeState {
  final List<Item> listItem;
  final bool hasMore;

  RepoLoadedState({required this.listItem, required this.hasMore});
}

class RepoErrorState extends HomeState {
  final String message;
  RepoErrorState(this.message);
}
