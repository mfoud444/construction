import 'package:construction/models/post.dart';
import 'package:flutter/material.dart';

class PostDetailsScreen extends StatelessWidget {
  final Post food;

  const PostDetailsScreen({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(food.name.toString())),
      body: Column(
        children: [
          Image.network(food.picture!),
          Text(food.name.toString()),
          Text(food.category.toString()),
          Text(food.price.toString()),
        ],
      ),
    );
  }
}
