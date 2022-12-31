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
            OfferBuilder(
              cardHeight: 70,
              flashSaleList: flashSaleExample,
              // duration:  Duration(seconds: 5),
            ),

          ],
        ),
      ),
    );
  }
}
class Offer {
  final int id;
  final String text;

  const Offer({
    required this.id,
    required this.text,
  });

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      id: map['id'] ?? 0,
      text: map['text'] ?? '',
    );
  }
}

List<Offer> flashSaleExample = const [
  Offer(
    id: 1,
    text: '-50% OFF- on all products',
  ),
  Offer(
    id: 2,
    text: 'Harry Up! Up to -10% OFF- on -Home Decor-',
  ),
  Offer(
    id: 3,
    text: '-Free- Shipping on orders over -\$40-',
  ),
];

class OfferBuilder extends StatefulWidget {
  final List<Offer> flashSaleList;
  final Duration duration;
  final double cardHeight;

  const OfferBuilder({
    Key? key,
    required this.flashSaleList,
    this.duration = const Duration(seconds: 2), required this.cardHeight,
  }) : super(key: key);

  @override
  State<OfferBuilder> createState() => _OfferBuilderState();
}

class _OfferBuilderState extends State<OfferBuilder> {
  late final ScrollController _scrollController =
  ScrollController(initialScrollOffset: 0);

  Timer? _timer;

  void scrollOfferUpwards() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: widget.duration,
        curve: Curves.fastLinearToSlowEaseIn,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.offset + widget.cardHeight,
        duration: Duration(seconds: widget.duration.inSeconds ~/ 2),
        curve: Curves.linear,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (timer) {
      scrollOfferUpwards();
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
      height: widget.cardHeight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: widget.flashSaleList.length,
        itemBuilder: (context, index) {
          final flashSale = widget.flashSaleList[index];
          return OfferCard(
            flashSale: flashSale,
            duration: widget.duration,
            cardHeight : 70,
          );
        },
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Offer flashSale;
  final Duration? duration;
  final double cardHeight;

  const OfferCard({
    Key? key,
    required this.flashSale,
    this.duration, required this.cardHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  cardHeight,
      padding: const EdgeInsets.all(10),
      // color: Colors.deepOrange,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: InkWell(
          onTap: () {
            print('You can Add your own functionality here ...');
          },
          child: Builder(builder: (context) {
            final List <TextSpan> textSpans = [];

            final splitText = flashSale.text.split('-');

            for (var i = 0; i < splitText.length; i++) {
              if (i % 2 == 0) {
                textSpans.add(
                  TextSpan(
                    text: splitText[i],
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                );
              } else {
                textSpans.add(
                  TextSpan(
                    text: splitText[i],
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            }

            return RichText(
              text: TextSpan(
                children: textSpans,
              ),
            );
            //
            // final highlightedText = flashSale.highlightedText;
            // if (highlightedText.isEmpty) {
            //   return Text(
            //     inputText,
            //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //           color: Colors.white,
            //         ),
            //   );
            // } else {
            //   final textSpan = <TextSpan>[];
            //    final splitText = inputText.trim();
            //   for (final text in splitText) {
            //     if (highlightedText.contains(text)) {
            //       textSpan.add(
            //         TextSpan(
            //           text: '$text ',
            //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //                 color: Colors.green,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //         ),
            //       );
            //
            //     } else {
            //       textSpan.add(
            //         TextSpan(
            //           text: '$text ',
            //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //                 color: Colors.white,
            //               ),
            //         ),
            //       );
            //     }
            //   }
            //   return RichText(
            //     text: TextSpan(
            //       children: textSpan,
            //
            //     ),
            //
            //   );
            // }
          }),
        ),
      ),
    );
  }
}
