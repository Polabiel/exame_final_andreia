import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsTimeline(),
    );
  }
}

class NewsTimeline extends StatefulWidget {
  @override
  _NewsTimelineState createState() => _NewsTimelineState();
}

class _NewsTimelineState extends State<NewsTimeline> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('NewsFeed :: <Gabriel Oliveira dos Santos RA: 23600 >'),
      ),
      body: const Text('Lista de Noticias'),
    );
  }
}

class NewsItem extends StatefulWidget {
  final String image;
  final String text;
  final String source;
  final String timeAgo;
  final bool liked;
  final String layoutStyle;
  final VoidCallback onDeletePressed;

  const NewsItem(
      {required this.image,
      required this.text,
      required this.source,
      required this.timeAgo,
      required this.liked,
      required this.layoutStyle,
      required this.onDeletePressed});

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.liked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewsInfoRow(
              source: widget.source,
              timeAgo: widget.timeAgo,
              isLiked: isLiked,
              onLikePressed: () {
                setState(() {
                  isLiked = !isLiked;
                });
              },
              onDeletePressed: () {
                widget.onDeletePressed();
              }),
          NewsImageText(
            image: widget.image,
            text: widget.text,
            layoutStyle: widget.layoutStyle,
          ),
        ],
      ),
    );
  }
}

class NewsInfoRow extends StatelessWidget {
  final String source;
  final String timeAgo;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onDeletePressed;

  const NewsInfoRow({
    required this.source,
    required this.timeAgo,
    required this.isLiked,
    required this.onLikePressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$source • $timeAgo',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.redAccent : Colors.grey,
                size: 20,
              ),
              onPressed: () {
                onLikePressed();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () {
                onDeletePressed();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class NewsImageText extends StatelessWidget {
  final String image;
  final String text;
  final String layoutStyle;

  const NewsImageText({
    required this.image,
    required this.text,
    required this.layoutStyle,
  });

  @override
  Widget build(BuildContext context) {
    return layoutStyle == 'row'
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: NewsText(text: text)),
              const SizedBox(width: 8.0),
              NewsImage.small(image: image),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImage(image: image),
              const SizedBox(height: 8.0),
              NewsText(text: text),
            ],
          );
  }
}

class NewsImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;

  const NewsImage({required this.image, this.width = 300, this.height = 200});
  const NewsImage.small(
      {required this.image, this.width = 130, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        image,
        width: this.width,
        height: this.height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class NewsText extends StatelessWidget {
  final String text;

  const NewsText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 16),
    );
  }
}
