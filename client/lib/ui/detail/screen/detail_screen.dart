import 'package:client/core/maestro_resources.dart';
import 'package:client/model/book.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/widget/general_network_image.dart'
    if (dart.library.html) 'package:client/ui/widget/web_network_image.dart';
import 'package:get/get.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, });
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String viewType = '';
  String authors = '';
  String translators = '';
  late Book book;
  @override
  void initState() {
    super.initState();
    book = Get.arguments?['book'] ?? Book();
    viewType =
        'cached-image-detail-${(book.thumbnail ?? '').hashCode}-${DateTime.now().toIso8601String()}';
    authors = (book.authors ?? []).join(',');
    translators = (book.translators ?? []).join(',');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked : (didPop){
        if (didPop) {
          return;
        }
        Get.back();
      },
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: (){
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios,size: 24,color: Colors.black,),
                ),
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                collapsedHeight: MediaQuery.of(context).size.height * 0.4,
                flexibleSpace: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CachedImage(
                      url: book.thumbnail ?? '',
                      viewType: viewType,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Positioned(
                      right: 12,
                      bottom: -8,
                      child: InkWell(
                        onTap: () {

                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFFFFF),
                              border: Border.all(color: const Color(0xFFD9D0E3))),
                          child: Obx(
                                () => IconButton(
                                onPressed: () {},
                                color: Colors.black,
                                icon: Icon(
                                  true
                                      ? Icons.favorite_outline_sharp
                                      : Icons.favorite_outlined,
                                  color: AppThemes.favoriteColor,
                                  size: 24,
                                )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        book.title ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: AppFonts.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        book.title ?? '',
                        style: const TextStyle(
                          fontFamily: AppFonts.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(book.contents ?? '',
                          style: const TextStyle(
                            fontFamily: AppFonts.medium,
                          )),
                      if (authors.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('- 저자 : $authors'),
                        ),
                      if (translators.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('- 번역가 : $translators'),
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
