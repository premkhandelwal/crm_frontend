part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class PageChangedState extends AppState {
  final Widget newPage;

  PageChangedState({required this.newPage});
}
