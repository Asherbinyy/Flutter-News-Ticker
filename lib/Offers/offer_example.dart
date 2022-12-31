import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news_ticker/News/news_example.dart';

List<TickerData> flashSaleExample = const [
  TickerData(
    id: 1,
    title: '-50% OFF- on all products',
    description: '',
  ),
  TickerData(
    id: 2,
    title: 'Harry Up! Up to -10% OFF- on -Home Decor-',
    description: '',
  ),
  TickerData(
    id: 3,
    title: '-Free- Shipping on orders over -\$40-',
    description: '',
  ),
];

class OfferBuilder extends StatefulWidget {
  final List<TickerData> flashSaleList;
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
  final TickerData flashSale;
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

            final splitText = flashSale.title.split('-');

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
