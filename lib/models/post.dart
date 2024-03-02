class Post {
  String? id;
  final String? name;
  final double? price;
  final String? picture;
  final String? category;
  late final String? restaurantId;

  Post({
    this.id,
    this.name,
    this.price,
    this.picture,
    this.category,
    this.restaurantId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      picture: json['picture'],
      category: json['category'],
      restaurantId: json['restaurantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'picture': picture,
      'category': category,
      'restaurantId': restaurantId,
    };
  }
}
