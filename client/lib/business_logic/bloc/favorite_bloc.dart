import 'dart:async';

import 'package:client/business_logic/event/favorite_event.dart';
import 'package:client/business_logic/state/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/helper/maestro_db_helper.dart';
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState>{
  FavoriteBloc() : super(FavoriteState()){
    on<AddFavoriteEvent>(_onAddFavoriteBook);
    on<RemoveFavoriteEvent>(_onRemoveFavoriteBook);
    on<AddFavoriteListEvent>(_onAddFavoriteBookList);
  }


  void _onAddFavoriteBook(AddFavoriteEvent event, Emitter<FavoriteState> emit){
    emit(state.copyWith(list: [...state.favorites,event.item]));
    unawaited(MaestroDBHelper().insert(event.item));
  }

  void _onRemoveFavoriteBook(RemoveFavoriteEvent event, Emitter<FavoriteState> emit){
    emit(state.copyWith(list:  List.from(state.favorites)..remove(event.item)));
    unawaited(MaestroDBHelper().delete(event.item));
  }

  void _onAddFavoriteBookList(AddFavoriteListEvent event, Emitter<FavoriteState> emit){
    emit(state.copyWith(list: [...state.favorites,...event.favoriteList]));
  }
}