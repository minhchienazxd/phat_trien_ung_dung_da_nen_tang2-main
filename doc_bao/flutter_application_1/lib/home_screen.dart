import 'dart:convert';


import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'article_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  _HomeScreenState createState() => _HomeScreenState();

}
class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  final List<String> categories = ['All', 'Politics', 'Sports', 'Health', 'Music', 'Tech'];
  String selectedCategory = 'All'; // Thể loại mặc định là All

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ngày tháng
              Text(
                DateFormat('EEE, dd\'th\' MMMM yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              // Title
              Text(
                'Explore',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 24),

              // Input tìm kiếm
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search for article',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Thanh danh sách thể loại
              const SizedBox(
                height: 40,
                child: CategoriesBar(
                  categories: ['All', 'Politics', 'Sports', 'Health', 'Music', 'Tech'],
                ),
              ),
              // Danh sách bài báo
              const SizedBox(height: 24),
              Expanded(
                child: ArticleList(
                  searchQuery: searchQuery,
                  selectedCategory: selectedCategory,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CategoriesBar extends StatefulWidget {
  final List<String> categories;

  const CategoriesBar({Key? key, required this.categories}) : super(key: key);

  @override
  State<CategoriesBar> createState() => _CategoriesBarState();
}

class _CategoriesBarState extends State<CategoriesBar> {
  List<String> categories = const [
    'All',
    'Politics',
    'Sports',
    'Health',
    'Music',
    'Tech'
  ];

  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            currentCategory = index;
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(
              // vertical: 8.0,
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
              color: currentCategory == index ? Colors.black : Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                  color: currentCategory == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArticleList extends StatelessWidget {
  const ArticleList({Key? key, required this.searchQuery, required this.selectedCategory});
  final String searchQuery;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getArticles(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            final data = snapshot.data ?? [];
            final filteredArticles = searchQuery.isEmpty
                ? data
                : data
                    .where((article) =>
                        article.title.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();
            return ListView.builder(
              padding: const EdgeInsets.only(right: 16.0),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                return ArticleTile(
                  article: filteredArticles[index],
                );
              },
            );
        }
      },
    );
  }

  Future<List<Article>> getArticles() async {
    const url =
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=bd237b888d224fb2b084f0f913a806ac';
    final res = await http.get(Uri.parse(url));

    final body = json.decode(res.body) as Map<String, dynamic>;

    final List<Article> result = [];
    for (final article in body['articles']) {
      result.add(
        Article(
          title: article['title'],
          urlToImage: article['urlToImage'],
        ),
      );
    }

    return result;
  }
}

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              article.urlToImage ?? '',
              fit: BoxFit.cover,
              height: 128,
              width: 128,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 128,
                  width: 128,
                  color: Colors.lightBlue,
                );
              },
            ),
          ),
          // TODO: Thêm thông tin bài báo
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
