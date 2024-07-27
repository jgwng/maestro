
import 'package:client/util/semantic_identifier.dart';
import 'package:client/util/test_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/ui/main/widget/document_item.dart';
import 'package:client/business_logic/search/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>  with AutomaticKeepAliveClientMixin<SearchScreen>{
  late SearchDocumentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SearchDocumentController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          searchBar(),
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
              controller: controller.fieldController,
              focusNode: controller.node,
              onSubmitted: (text) {
                controller.onTapForSearch(isInit: true);
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => controller.onTapForSearch(isInit: true),
              child: const Text('검색')).toSemantic(
              id: SemanticID.SEARCH_SCREEN_SEARCH_BUTTON,
          ),
        ],
      ),
    );
  }

  Widget searchResult() {
    return Expanded(
      child: Obx(() {
        if (controller.isSearching.isTrue) {
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
        if (controller.searchWord.isEmpty) {
          return const SizedBox();
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (ctx, index) {
            if (index == controller.documents.length) {
              if (controller.isEnd) {
                return const SizedBox();
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.onTapForSearch(isInit: false);
                });
                return Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
            }
            return SearchBookItem(
                book: controller.documents[index],
                onTapFavoriteItem: (result,item) => controller.onTapFavoriteItems(result,item),
            );
            },
          itemCount: controller.documents.length + 1,
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 40,
            );
          },
        );
      }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
