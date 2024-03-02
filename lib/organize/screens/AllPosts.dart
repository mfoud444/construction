import 'package:construction/common/colors.dart';
import 'package:construction/models/post.dart';
import 'package:construction/organize/screens/PostDetailsScreen.dart';
import 'package:construction/services/postService.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';

class AllPost extends StatefulWidget {
  const AllPost({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllPostState createState() => _AllPostState();
}

class _AllPostState extends State<AllPost> {
  final PostService foodService = PostService();
  List<Post>? Posts;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _getAllFoods();
  }

  _getAllFoods() async {
    Map<String, dynamic> user = await userService.getCurrentUser();
    String? id = user['id'];
    List<Post> Posts = await foodService.getAllPosts(id!);
    setState(() {
      Posts = Posts;
    });
  }

  void _filterFoods(String searchTerm) {
    List<Post> filteredPosts =
        Posts!.where((food) => food.name!.contains(searchTerm)).toList();
    setState(() {
      Posts = filteredPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            // ignore: prefer_const_constructors
            child: Center(
              // ignore: prefer_const_constructors
              child: Text(
                'Construction',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                    fontFamily: 'Times new roman'),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for a Post',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  _filterFoods(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Posts != null
                ? ListView.separated(
                    itemCount: Posts!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostDetailsScreen(
                                food: Posts![index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 16,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              Posts![index].picture!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Posts![index].name!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          Posts![index].category!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${Posts![index].price}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () async {
                                        foodService
                                            .deleteFood(Posts![index].id!);
                                        _getAllFoods();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
