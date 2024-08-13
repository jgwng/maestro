import 'package:client/business_logic/bloc/favorite_bloc.dart';
import 'package:client/business_logic/event/favorite_event.dart';
import 'package:client/helper/maestro_db_helper.dart';
import 'package:client/model/book.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/main/screen/favorite_screen.dart';
import 'package:client/ui/main/screen/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/maestro_resources.dart';
import '../../../helper/maestro_theme_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  int _selectedIndex = 0;


  final List<Widget> _pages = <Widget>[
    const SearchScreen(),
    const FavoriteScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async{
          List<Book> favoriteList = await MaestroDBHelper().getDB();
          FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(Get.context!);
          favoriteBloc.add(AddFavoriteListEvent(favoriteList));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: MaestroThemeHelper.themeMode,
                builder:(context,mode,child){
                  bool isDark = MaestroThemeHelper.isDark;
                  return Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            MaestroThemeHelper.change();
                          },
                          splashColor: Colors.transparent,
                          child:  Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: isDark ? AppThemes.unSelectedColor  : AppThemes.pointColor,
                            semanticLabel: isDark ? 'DARK' : 'LIGHT',
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        InkWell(
                          onTap: (){},
                          child:  Icon(
                            Icons.logout,
                            color: isDark ? AppThemes.unSelectedColor  : AppThemes.pointColor,
                            size: 30,),
                        ),
                      ],
                    ),
                  );
                }),
            Expanded(
              child: _pages.elementAt(_selectedIndex),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search,size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,size: 30,),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex, // 지정 인덱스로 이동
        selectedItemColor: AppThemes.pointColor,
        unselectedItemColor: AppThemes.unSelectedColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped, // 선언했던 onItemTapped
      ),
    );
  }
}
