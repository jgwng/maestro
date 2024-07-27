import 'package:get/get.dart';
import 'package:client/business_logic/search/search_controller.dart';
import 'package:client/model/book.dart';
import 'package:client/helper/maestro_db_helper.dart';
class FavoriteController extends GetxController{

  RxList<Book> favoriteDocuments = <Book>[].obs;

  @override
  void onReady() async{
    super.onReady();
    List<Book> savedDocuments = await MaestroDBHelper().getDB();
    favoriteDocuments.addAll(savedDocuments);
  }

  void onTapRemoveFavorite(bool isFavorite, Book book){

    SearchDocumentController searchController = Get.find<SearchDocumentController>();
    int index = favoriteDocuments.indexWhere((element) => element.thumbnail == book.thumbnail);
    Book document = favoriteDocuments[index];
    searchController.favDocuments.removeWhere((element) => element.thumbnail == document.thumbnail);
    int listIndex = searchController.documents.indexWhere((element) => element.thumbnail == document.thumbnail);
    if(listIndex >= 0){
      searchController.documents[listIndex].isFavorite = 'false';
    }

    MaestroDBHelper().delete(favoriteDocuments[index]);
    favoriteDocuments.removeAt(index);
  }

}