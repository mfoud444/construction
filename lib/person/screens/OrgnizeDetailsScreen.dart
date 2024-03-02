import 'package:construction/models/post.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/services/SharedPreferencesHelper.dart';
import 'package:construction/services/postService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgnizeDetailsScreen extends StatefulWidget {
  final Organize orgnize;

  const OrgnizeDetailsScreen({Key? key, required this.orgnize})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrgnizeDetailsScreenState createState() =>
      // ignore: no_logic_in_create_state
      _OrgnizeDetailsScreenState(restaurant: orgnize);
}

class _OrgnizeDetailsScreenState extends State<OrgnizeDetailsScreen> {
  final Organize restaurant;
  _OrgnizeDetailsScreenState({required this.restaurant});
  final PostService foodService = PostService();
  final List<String> categories = ['B', 'L', 'D', 'S'];
  String selectedCategory = 'B';
  Map<String, int> quantities = {};

  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();
  @override
  void initState() {
    super.initState();
    _getQuantities();
  }

  Future<void> _saveQuantity(String id, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(id, quantity);
  }

  Future<void> _getQuantities() async {
    quantities = await _sharedPreferencesHelper.getQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Image.network(
              widget.orgnize.picture!,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: selectedCategory == categories[index]
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
                future: foodService.getPostsByCategory(
                    restaurant.id!, selectedCategory),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Post food = snapshot.data![index];
                        // If the food quantity is not present in the quantities map, set it to 0
                        if (!quantities.containsKey(food.id)) {
                          quantities[food.id!] = 0;
                        }
                        return Padding(
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
                                        image: NetworkImage(food.picture!),
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
                                        food.name!.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${food.price} RS',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle),
                                        onPressed: () {
                                          if (quantities[food.id] != 0) {
                                            setState(() {
                                              // Decrement the quantity value
                                              int currentQuantity =
                                                  quantities[food.id]!;
                                              currentQuantity =
                                                  currentQuantity - 1;
                                              quantities[food.id!] =
                                                  currentQuantity;
                                              // Save the updated value to SharedPreferences
                                              _saveQuantity(
                                                  food.id!, currentQuantity);
                                            });
                                          }
                                        },
                                      ),
                                      Text(quantities[food.id].toString()),
                                      IconButton(
                                          icon: Icon(Icons.add_circle),
                                          onPressed: () {
                                            setState(() {
                                              int currentQuantity =
                                                  quantities[food.id]!;
                                              currentQuantity =
                                                  currentQuantity + 1;
                                              quantities[food.id!] =
                                                  currentQuantity;
                                              _saveQuantity(
                                                  food.id!, currentQuantity);
                                            });
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                                            },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    // ignore: prefer_const_constructors
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
