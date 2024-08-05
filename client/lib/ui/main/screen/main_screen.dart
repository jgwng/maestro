import 'package:flutter/material.dart';
import 'package:client/ui/main/screen/favorite_screen.dart';
import 'package:client/ui/main/screen/search_screen.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(vsync: this,length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              onTap: (index){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              controller: tabController,
              tabs: const [
                Tab(text: '검색'),
                Tab(text: '즐겨찾기'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  SearchScreen(),
                  FavoriteScreen()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
