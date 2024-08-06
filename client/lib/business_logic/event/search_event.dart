abstract class SearchEvent{
  const SearchEvent();
}

class FetchSearchResults extends SearchEvent {
  final String query;

  const FetchSearchResults({required this.query});

}

class LoadMoreResults extends SearchEvent {
  final String query;

  const LoadMoreResults({required this.query});

}