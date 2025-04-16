import 'package:flutter/material.dart';

class InfiniteScrollPage extends StatefulWidget {
  const InfiniteScrollPage({super.key});

  @override
  State<InfiniteScrollPage> createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  // 画像がロード済みか追跡するためのセット
  final Set<int> _loadedImages = {};

  // スクロール検出のためのコントローラーを追加
  final ScrollController _scrollController = ScrollController();

  // 現在表示中のアイテム数
  int _itemCount = 20; // 初期表示数

  // ロード中を示すフラグ
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // スクロールイベントのリスナーを追加
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // スクロールコントローラーのクリーンアップ
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // スクロールの状態を監視し、下部に近づいたときに新しい項目を追加
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreItems();
    }
  }

  // 新しい項目をロード
  void _loadMoreItems() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        // 追加する項目数（必要に応じて調整）
        _itemCount += 10;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Page'),
      ),
      body: ListView.builder(
        controller: _scrollController, // スクロールコントローラーを設定
        itemCount: _itemCount + 1, // +1 はローディングインジケーター用
        itemBuilder: (context, index) {
          // 最後の項目の場合、ローディングインジケーターを表示
          if (index == _itemCount) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final imageIndex = index % 5;

          // この画像がまだロードされていなければロードする
          if (!_loadedImages.contains(imageIndex)) {
            _loadedImages.add(imageIndex);
            // バックグラウンドで画像をプリロード
            precacheImage(AssetImage('images/image$imageIndex.jpg'), context);
          }

          // FadeInImageを使用して遅延ロード
          return FadeInImage(
            // プレースホルダー画像（小さく軽量なもの）
            placeholder: const AssetImage('images/placeholder.png'),
            // 実際の画像
            image: AssetImage('images/image$imageIndex.jpg'),
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
            height: 200,
          );
        },
      ),
    );
  }
}
