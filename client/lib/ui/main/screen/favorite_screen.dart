import 'package:client/business_logic/bloc/favorite_bloc.dart';
import 'package:client/business_logic/state/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/ui/main/widget/document_item.dart';

class FavoriteScreen extends StatefulWidget{
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with AutomaticKeepAliveClientMixin<FavoriteScreen>{

  late FavoriteBloc _favoriteBloc;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoriteBloc,FavoriteState>(
        builder: (context,state){
          if(state.favorites.isEmpty){
            return const SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (ctx, index) {
                return SearchBookItem(
                  book: state.favorites[index],
                );
              },
              itemCount: state.favorites.length,
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 40,
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}