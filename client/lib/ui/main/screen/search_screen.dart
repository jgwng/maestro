
import 'package:client/business_logic/bloc/search_bloc.dart';
import 'package:client/business_logic/event/search_event.dart';
import 'package:client/business_logic/state/search_state.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:client/util/semantic_identifier.dart';
import 'package:client/util/test_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/ui/main/widget/document_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>  with AutomaticKeepAliveClientMixin<SearchScreen>{

  late SearchBloc _searchBloc;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          searchBar(),
          ElevatedButton(
              onPressed: () {
                MaestroThemeHelper.change();
              },
              child: const Text(
                '모드 변경',
                textAlign: TextAlign.center,)),
          const SizedBox(
            height: 12,
          ),
          searchResult()
        ],
      ),
    );
  }

  Widget searchBar() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: searchNode,
              onSubmitted: (text) => onTapSearchBooks(),
            ),
          ),
          ElevatedButton(
              onPressed: onTapSearchBooks,
              child: const Text('검색')).toSemantic(
              id: SemanticID.SEARCH_SCREEN_SEARCH_BUTTON,
          ),
        ],
      ),
    );
  }

  Widget searchResult() {
    return Expanded(
      child: BlocBuilder<SearchBloc,SearchState>(
        builder: (context,state) {
          if(state.results.isEmpty){
            return const SizedBox();
          }

          if (state.isListLoading == true) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('검색 중입니다')
              ],
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (ctx, index) {
              if (index == state.results.length) {
                if (state.hasReachedMax == true) {
                  return const SizedBox();
                } else {
                  _searchBloc.add(LoadMoreResults(query: searchController.text));
                  return Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
              }
              return SearchBookItem(
                book: state.results[index],
              );
            },
            itemCount: state.results.length + 1,
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 40,
              );
            },
          );
        },
      ),
    );
  }

  void onTapSearchBooks(){
    if(searchController.text.isEmpty){
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    _searchBloc.add(FetchSearchResults(
      query: searchController.text,
    ));
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
