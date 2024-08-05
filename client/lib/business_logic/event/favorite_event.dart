import 'package:client/model/book.dart';

abstract class FavoriteEvent{

}

class AddFavoriteEvent extends FavoriteEvent{
  final Book item;

  AddFavoriteEvent(this.item);
}

class RemoveFavoriteEvent extends FavoriteEvent{
  final Book item;

  RemoveFavoriteEvent(this.item);
}