import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Ticker Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NewsTickerBuilder(
              newsList: newsExample,
              duration: NewsTickerDuration.short,
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

enum NewsTickerDuration { short, medium, long }

List<News> newsExample = const [
  News(
    id: 1,
    title: 'BBC News',
    description: 'The latest news from the BBC',
    // image:
    // 'https://www.bbc.co.uk/news/special/2015/newsspec_10857/bbc_news_logo.png?cb=1',
  ),
  News(
    id: 2,
    title: 'CNN News',
    description: 'The latest news from the CNN',
    // image:
    //     'https://1000logos.net/wp-content/uploads/2021/04/CNN-logo-500x281.png',
  ),
  News(
    id: 3,
    title: 'Sky News',
    description: 'The latest news from the Sky',
    // image:
    //     'https://static.skyassets.com/contentstack/assets/blt99ae31f3e053a966/bltd9c477a02ae8f056/60b754cd9278c520d5affde3/Master.png',
  ),
  News(
    id: 4,
    title: 'Al Jazeera News',
    description: 'The latest news from the Al Jazeera',
    // image:
    // 'https://play-lh.googleusercontent.com/cH7bE7urEYRSpR0mFQbNP4ZZ0ecmfYH6tDLaCu_Z5OH6EUAsQ3e8Ml58Ebm8VcmMCI8=w240-h480-rw',
  ),
];

class NewsTickerBuilder extends StatefulWidget {
  final NewsTickerDuration duration;
  final List<News> newsList;

  const NewsTickerBuilder({
    Key? key,
    this.duration = NewsTickerDuration.medium,
    required this.newsList,
  }) : super(key: key);

  @override
  State<NewsTickerBuilder> createState() => _NewsTickerBuilderState();
}

class _NewsTickerBuilderState extends State<NewsTickerBuilder> {
  late final ScrollController _scrollController = ScrollController();

  final Curve _scrollCurve = Curves.linear;
  Timer? _timer;
  late Duration _newsDuration;

  void setDuration() {
    switch (widget.duration) {
      case NewsTickerDuration.short:
        _newsDuration = const Duration(milliseconds: 500);
        break;
      case NewsTickerDuration.medium:
        _newsDuration = const Duration(seconds: 1);
        break;
      case NewsTickerDuration.long:
        _newsDuration = const Duration(seconds: 2);
        break;
    }
  }

  void animateNews() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        _scrollController.position.outOfRange) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: _newsDuration,
        curve: Curves.fastLinearToSlowEaseIn,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.offset + 20,
        duration: _newsDuration,
        curve: _scrollCurve,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setDuration();
    _timer = Timer.periodic(_newsDuration, (timer) {
      animateNews();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: newsExample.length,
        itemBuilder: (context, index) {
          final news = newsExample[index];
          return NewsTicker(news: news);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }
}

class NewsTicker extends StatelessWidget {
  final News news;
  final VoidCallback? onNewsTap;

  const NewsTicker({
    Key? key,
    required this.news,
    this.onNewsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('You can Add your own functionality here ...');
        onNewsTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              '${news.title} | ',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.deepOrange,
                  ),
            ),
            Text(
              news.description,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Colors.grey.shade300,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class News {
  final int id;
  final String title;
  final String description;

  // final String image;

  const News({
    required this.id,
    required this.title,
    required this.description,
    // required this.image,
  });

  @override
  String toString() =>
      'News{ id: $id, title: $title, description: $description, '
      // 'image: $image,'
      '}';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // 'image': image,
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      // image: map['image'] ?? '',
    );
  }
}
