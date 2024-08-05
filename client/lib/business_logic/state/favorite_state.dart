import 'package:client/model/book.dart';

class FavoriteState{
  final List<Book> favorites;

  FavoriteState({this.favorites = const <Book>[]});

  FavoriteState copyWith({
    List<Book>? list
  }){
    return FavoriteState(
      favorites: list ?? favorites
    );
  }

}