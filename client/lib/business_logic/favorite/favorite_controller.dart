import 'package:get/get.dart';
import 'package:client/business_logic/search/search_controller.dart';
import 'package:client/model/documents.dart';
import 'package:client/helper/maestro_db_helper.dart';
class FavoriteController extends GetxController{

  RxList<Document> favoriteDocuments = <Document>[].obs;

  @override
  void onReady() async{
    super.onReady();
    List<Document> savedDocuments = await MaestroDBHelper().getDB();
    favoriteDocuments.addAll(savedDocuments);
  }

  void onTapRemoveFavorite(int index){

    SearchDocumentController searchController = Get.find<SearchDocumentController>();
    Document document = favoriteDocuments[index];
    searchController.favDocuments.removeWhere((element) => element.imageUrl == document.imageUrl);
    int listIndex = searchController.documents.indexWhere((element) => element.imageUrl == document.imageUrl);
    if(listIndex >= 0){
      searchController.documents[listIndex].isFavorite = 'false';
    }

    MaestroDBHelper().delete(favoriteDocuments[index]);
    favoriteDocuments.removeAt(index);
  }

}