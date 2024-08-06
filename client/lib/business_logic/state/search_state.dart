import 'package:client/model/book.dart';

class SearchState{
  final List<Book> results;
  final bool hasReachedMax;
  final bool isListLoading;
  final bool isPaging;

  const SearchState({
    this.results = const [],
    this.hasReachedMax = false,
    this.isListLoading = false,
    this.isPaging = false,
  });


  SearchState copyWith({
    List<Book>? results,
    bool? hasReachedMax,
    bool? isListLoading,
    bool? isPaging,
  }) {
    return SearchState(
      results: results ?? this.results,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isListLoading: isListLoading ?? this.isListLoading,
      isPaging: isPaging ?? this.isPaging,
    );
  }

}