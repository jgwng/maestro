import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/business_logic/favorite/favorite_controller.dart';
import 'package:client/ui/main/widget/document_item.dart';

class FavoriteScreen extends StatefulWidget{
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>{

  late FavoriteController controller;

  @override
  void initState(){
    super.initState();
    controller = Get.put<FavoriteController>(FavoriteController());
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
              return DocumentItem(
                  document: controller.favoriteDocuments[index],
                  onTapFavoriteItem : () => controller.onTapRemoveFavorite(index)
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
}