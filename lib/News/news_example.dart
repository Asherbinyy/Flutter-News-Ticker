import 'dart:async';
import 'package:flutter/material.dart';

enum TickerDuration { short, medium, long }

List<TickerData> newsExample = const [
  TickerData(
    id: 1,
    title: 'BBC News',
    description: 'The latest news from the BBC',
    // image:
    // 'https://www.bbc.co.uk/news/special/2015/newsspec_10857/bbc_news_logo.png?cb=1',
  ),
  TickerData(
    id: 2,
    title: 'CNN News',
    description: 'The latest news from the CNN',
    // image:
    //     'https://1000logos.net/wp-content/uploads/2021/04/CNN-logo-500x281.png',
  ),
  TickerData(
    id: 3,
    title: 'Sky News',
    description: 'The latest news from the Sky',
    // image:
    //     'https://static.skyassets.com/contentstack/assets/blt99ae31f3e053a966/bltd9c477a02ae8f056/60b754cd9278c520d5affde3/Master.png',
  ),
  TickerData(
    id: 4,
    title: 'Al Jazeera News',
    description: 'The latest news from the Al Jazeera',
    // image:
    // 'https://play-lh.googleusercontent.com/cH7bE7urEYRSpR0mFQbNP4ZZ0ecmfYH6tDLaCu_Z5OH6EUAsQ3e8Ml58Ebm8VcmMCI8=w240-h480-rw',
  ),
];

class NewsTickerBuilder extends StatefulWidget {
  final TickerDuration duration;
  final List<TickerData> newsList;

  const NewsTickerBuilder({
    Key? key,
    this.duration = TickerDuration.medium,
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
      case TickerDuration.short:
        _newsDuration = const Duration(milliseconds: 500);
        break;
      case TickerDuration.medium:
        _newsDuration = const Duration(seconds: 1);
        break;
      case TickerDuration.long:
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
          return NewsTickerCard(news: news);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}

class NewsTickerCard extends StatelessWidget {
  final TickerData news;
  final VoidCallback? onNewsTap;

  const NewsTickerCard({
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

class TickerData {
  final int id;
  final String title;
  final String description;
  const TickerData({
    required this.id,
    required this.title,
    required this.description,
  });
  factory TickerData.fromMap(Map<String, dynamic> map) {
    return TickerData(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
