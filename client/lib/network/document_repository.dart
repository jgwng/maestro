import 'package:client/core/maestro_test_http.dart';
import 'package:client/core/maestro_test_url.dart';
import 'package:client/model/book.dart';
import 'package:client/util/test_util.dart';

class DocumentRepository extends MaestroTestHttps{
  DocumentRepository._() : super(){
    _instance = this;
  }
  factory DocumentRepository() => _instance ?? DocumentRepository._();

  static DocumentRepository? _instance;

  Future<List<Book>?> getSearchResult({String? query,String? sort,int? pageNo,int? pageSize}) async {
    var params = {
      'query': query,
      'sort':sort,
      'page':'$pageNo',
      'size':'$pageSize',
    };

    final res = await get(ClientTestUrl.searchUrl, queries: params);
    if (res.statusCode == 200) {
      return MaestroTestUtil().jsonToList<Book>(res.data ?? {},Book.fromJson,'documents');
    }
    return null;
  }
}
