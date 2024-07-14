import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('이미지 상세 보기'),
      ),
      body: Image.network(
        widget.imageUrl ?? '',
        fit: BoxFit.fitHeight,
        height: double.infinity,
      ),
    );
  }
}
