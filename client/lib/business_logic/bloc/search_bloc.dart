// search_bloc.dart
import 'package:client/business_logic/event/search_event.dart';
import 'package:client/business_logic/state/search_state.dart';
import 'package:client/network/document_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    on<FetchSearchResults>(_onFetchSearchResults);

  }
  int pageSize = 20;
  DocumentRepository repository = DocumentRepository();


  void _onFetchSearchResults(FetchSearchResults event, Emitter<SearchState> emit) async {
    emit(state.copyWith(isLoading: true));
    var response = await repository.getSearchResult(
      query: event.query,
      sort: 'recency',
      pageNo: event.pageNo,
      pageSize: pageSize,
    );
    if(response != null){
      bool hasReachedMax = (response.length < pageSize);
      emit(state.copyWith(results: state.results + response, hasReachedMax: hasReachedMax, isLoading: false));
    }else{
      emit(state.copyWith(isLoading: false));
    }
  }


}
