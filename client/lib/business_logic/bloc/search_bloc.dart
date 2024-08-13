// search_bloc.dart
import 'package:client/business_logic/event/search_event.dart';
import 'package:client/business_logic/state/search_state.dart';
import 'package:client/network/document_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<FetchSearchResults>(_onFetchSearchResults);
    on<LoadMoreResults>(_onLoadMoreResults);

  }
  int pageSize = 20;
  int pageNo = 1;
  String lastSearchWord = '';
  DocumentRepository repository = DocumentRepository();


  void _onFetchSearchResults(FetchSearchResults event, Emitter<SearchState> emit) async {
    if(state.isListLoading == true) return;

    if(event.query == lastSearchWord) return;

    emit(state.copyWith(isListLoading: true));

    pageNo = 1;
    lastSearchWord = event.query;

    var response = await repository.getSearchResult(
      query: event.query,
      sort: 'recency',
      pageNo: pageNo,
      pageSize: pageSize,
    );
    if(response != null){
      bool hasReachedMax = (response.length < pageSize);
      emit(state.copyWith(results: response, hasReachedMax: hasReachedMax, isListLoading: false));
    }else{
      emit(state.copyWith(isListLoading: false));
    }
  }

  void _onLoadMoreResults(LoadMoreResults event, Emitter<SearchState> emit) async {
    if(state.isPaging == true) return;

    if(event.query != lastSearchWord) return;

    emit(state.copyWith(isPaging: true));
    lastSearchWord = event.query;
    pageNo += 1;
    var response = await repository.getSearchResult(
      query: event.query,
      sort: 'recency',
      pageNo: pageNo,
      pageSize: pageSize,
    );
    if(response != null){
      bool hasReachedMax = (response.length < pageSize);
      emit(state.copyWith(results: [...state.results, ...response], hasReachedMax: hasReachedMax, isListLoading: false,isPaging: false));
    }else{
      emit(state.copyWith(isPaging: false));
    }
  }


}
