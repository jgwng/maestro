import 'package:client/model/book.dart';

class SearchState{
  final List<Book> results;
  final bool hasReachedMax;
  final bool isLoading;

  const SearchState({
    this.results = const [],
    this.hasReachedMax = false,
    this.isLoading = false,
  });


  SearchState copyWith({
    List<Book>? results,
    bool? hasReachedMax,
    bool? isLoading,
  }) {
    return SearchState(
      results: results ?? this.results,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoading: isLoading ?? this.isLoading,
    );
  }

}