import 'package:client/core/maestro_resources.dart';
import 'package:client/core/maestro_routes.dart';
import 'package:client/model/book.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/widget/general_network_image.dart'
    if (dart.library.html) 'package:client/ui/widget/web_network_image.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

typedef FavoriteCallback = void Function(bool, Book);

class SearchBookItem extends StatelessWidget {
  SearchBookItem({super.key, required this.book, this.onTapFavoriteItem});

  final Book book;
  final FavoriteCallback? onTapFavoriteItem;

  late RxBool isFavorite = (book.isFavorite == 'TRUE').obs;

  @override
  Widget build(BuildContext context) {
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
            Obx(() {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  if (onTapFavoriteItem != null) {
                    onTapFavoriteItem!(isFavorite.value, book);
                  }
                },
                child: Icon(
                    (isFavorite.value)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    size: 24,
                    color: AppThemes.favoriteColor),
              );
            })
          ],
        ),
      ),
    ));
  }

  void onTapBookItem() async {
    var result = await Get.toNamed(AppRoutes.detail, arguments: {'book': book});
    if (result != null && result is bool) {
      if(isFavorite.value == result) return;

      isFavorite.value = result;
      if (onTapFavoriteItem != null) {
        onTapFavoriteItem!(isFavorite.value, book);
      }
    }
  }
}
