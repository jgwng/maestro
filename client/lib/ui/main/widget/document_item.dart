import 'package:client/business_logic/bloc/favorite_bloc.dart';
import 'package:client/business_logic/event/favorite_event.dart';
import 'package:client/business_logic/state/favorite_state.dart';
import 'package:client/core/maestro_resources.dart';
import 'package:client/core/maestro_routes.dart';
import 'package:client/model/book.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/widget/general_network_image.dart'
    if (dart.library.html) 'package:client/ui/widget/web_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';


class SearchBookItem extends StatelessWidget {
  const SearchBookItem({super.key, required this.book});

  final Book book;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc,FavoriteState>(
      builder: (context,state){
        final isFavorite = state.favorites.contains(book);
        return PointerInterceptor(
            child: InkWell(
              onTap: onTapBookItem,
              child: Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  children: [
                    SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: CachedImage(
                            url: book.thumbnail ?? '',
                            width: 80,
                            height: 80,
                            onTap: onTapBookItem,
                          ),
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            book.title ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            (book.authors ?? []).join(','),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.medium),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: onTapFavoriteItem,
                      child: Icon(
                          (isFavorite)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 24,
                          color: AppThemes.favoriteColor),
                    )
                  ],
                ),
              ),
            ));
      }
    );
  }

  void onTapBookItem() async {
    var result = await Get.toNamed(AppRoutes.detail, arguments: {'book': book});

  }

  void onTapFavoriteItem() async{
    final favoriteBloc = BlocProvider.of<FavoriteBloc>(Get.context!);
    final isFavorite = favoriteBloc.state.favorites.contains(book);
    if(isFavorite){
      favoriteBloc.add(RemoveFavoriteEvent(book));
    }else{
      favoriteBloc.add(AddFavoriteEvent(book));
    }
  }

}
