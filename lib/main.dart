import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_news_ticker/News/news_example.dart';
import 'package:flutter_news_ticker/Offers/offer_example.dart';

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
              duration: TickerDuration.short,
            ),
            // OfferBuilder(
            //   cardHeight: 70,
            //   flashSaleList: flashSaleExample,
            //   // duration:  Duration(seconds: 5),
            // ),
            // NewsTickerBuilder(
            //   newsList: newsExample,
            //   duration: TickerDuration.short,
            // ),
            // const Expanded(child: SizedBox()),
            // OfferBuilder(
            //   cardHeight: 70,
            //   flashSaleList: flashSaleExample,
            //   // duration:  Duration(seconds: 5),
            // ),
          ],
        ),
      ),
    );
  }
}


