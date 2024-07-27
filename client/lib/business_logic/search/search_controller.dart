import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/business_logic/favorite/favorite_controller.dart';
import 'package:client/helper/maestro_db_helper.dart';
import 'package:client/main.dart';
import 'package:client/model/book.dart';
import 'package:client/network/document_repository.dart';

class SearchDocumentController extends GetxController{
  final TextEditingController fieldController = TextEditingController();
  final FocusNode node = FocusNode();
  final DocumentRepository repository = DocumentRepository();
  String searchWord = '';
  int pageNo = 1;
  int pageSize = 20;
  RxBool isSearching = false.obs;
  bool isEnd = false;
  RxList<Book> documents = <Book>[].obs;
  List<Book> favDocuments = [];

  @override
  void onReady() async{
    super.onReady();
    List<Book> savedDocuments = await MaestroDBHelper().getDB();
    favDocuments.addAll(savedDocuments);
  }

  void onTapForSearch({bool isInit = false}) async{
    print('BUTTON CLICK');

    if(isSearching.value == true) return;

    if(fieldController.text.isEmpty) return;

    if(fieldController.text == searchWord && isInit == true) return;
    FocusScope.of(navigatorKey.currentState!.context).requestFocus(FocusNode());

    if(isInit == false){
      pageNo +=1;
    }else{
      pageNo = 1;
      isSearching.value = true;
    }
    var response = await repository.getSearchResult(
      query: fieldController.text,
      sort: 'recency',
      pageNo: pageNo,
      pageSize: pageSize,
    );
    if(response != null){
      if(searchWord != fieldController.text){
        searchWord = fieldController.text;
        documents.clear();
      }
      for(Book book in response){
        int index = favDocuments.indexWhere((element) => element.thumbnail == book.thumbnail);
        if(index >=0){
          book.isFavorite = 'TRUE';
        }
      }
      documents.addAll(response);
      documents.refresh();
      if(response.length < pageSize){
        isEnd = true;
      }
    }
    isSearching.value = false;
  }

  void onTapFavoriteItems(bool isFavorite, Book book) async{
    int index = documents.indexWhere((element) => element.thumbnail == book.thumbnail);
    documents[index].isFavorite = isFavorite ? 'FALSE' : 'TRUE';
    documents.refresh();
    if(isFavorite == true){
      favDocuments.removeWhere((element) => element.thumbnail == book.thumbnail);
      MaestroDBHelper().delete(documents[index]);
    }else{
      favDocuments.add(book);
      MaestroDBHelper().insert(documents[index]);
    }

    if(Get.isRegistered<FavoriteController>()){
      FavoriteController favController = Get.find<FavoriteController>();
      if(isFavorite == true){
        int favoriteIndex = favController.favoriteDocuments.indexWhere((element) => element.thumbnail == book.thumbnail);
        if(index >=0){
          favController.favoriteDocuments.removeAt(favoriteIndex);
        }
      }else{
        favController.favoriteDocuments.add(documents[index]);
      }
    }
  }
}