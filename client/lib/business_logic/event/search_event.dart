abstract class SearchEvent{
  const SearchEvent();
}

class FetchSearchResults extends SearchEvent {
  final String query;
  final int pageNo;

  const FetchSearchResults({required this.query, this.pageNo = 1});

}

class LoadMoreResults extends SearchEvent {
  final String query;

  const LoadMoreResults({required this.query});

}