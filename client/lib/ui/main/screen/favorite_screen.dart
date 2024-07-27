import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/business_logic/favorite/favorite_controller.dart';
import 'package:client/ui/main/widget/document_item.dart';

class FavoriteScreen extends StatefulWidget{
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with AutomaticKeepAliveClientMixin<FavoriteScreen>{

  late FavoriteController controller;

  @override
  void initState(){
    super.initState();
    controller = Get.find<FavoriteController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (ctx,index){
              return SearchBookItem(
                  book: controller.favoriteDocuments[index],
                  onTapFavoriteItem : controller.onTapRemoveFavorite
              );
            },
            itemCount: controller.favoriteDocuments.length,
            separatorBuilder: (ctx,index){
              return const SizedBox(
                height: 40,
              );
            },
          ),
        );
      }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}