import 'package:client/business_logic/event/favorite_event.dart';
import 'package:client/business_logic/state/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState>{
  FavoriteBloc() : super(FavoriteState()){
    on<AddFavoriteEvent>(_onAddFavoriteBook);
    on<RemoveFavoriteEvent>(_onRemoveFavoriteBook);
  }


  void _onAddFavoriteBook(AddFavoriteEvent event, Emitter<FavoriteState> emit){
    emit(state.copyWith(list: [...state.favorites,event.item]));
  }

  void _onRemoveFavoriteBook(RemoveFavoriteEvent event, Emitter<FavoriteState> emit){
    emit(state.copyWith(list:  List.from(state.favorites)..remove(event.item)));
  }
}