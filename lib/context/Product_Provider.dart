import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final List<String> size;
  final List<String> colors;
  final String thumbnail;
  final Map<String, String> imagesByColor;
  final String description;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.colors,
    required this.thumbnail,
    required this.imagesByColor,
    required this.description,
    required this.rating,
  });
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final String size;
  final String color;
  final String image;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.color,
    required this.image,
    required this.quantity,
  });
}

class ProductProvider with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: "1",
      name: "Floral Maxi Dress",
      price: 4500.0,
      size: ["S", "M", "L"],
      colors: ["#FFC0CB", "#000000"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2020/03/12/00/52/nonbinary-4923610_640.jpg",
      imagesByColor: {
        "#FFC0CB":
            "https://cdn.pixabay.com/photo/2020/03/12/00/52/nonbinary-4923610_1280.jpg",
        "#000000":
            "https://cdn.pixabay.com/photo/2024/07/22/06/38/woman-8911930_1280.jpg",
      },
      description: "Elegant floral dress perfect for summer outings.",
      rating: 4.5,
    ),
    Product(
      id: "2",
      name: "Silk Blouse",
      price: 5900.99,
      size: ["XS", "S", "M"],
      colors: ["#F5F5DC", "#DDA0DD"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2023/05/25/13/10/woman-8017358_640.jpg",
      imagesByColor: {
        "#F5F5DC":
            "https://cdn.pixabay.com/photo/2023/05/25/13/10/woman-8017358_1280.jpg",
        "#DDA0DD":
            "https://cdn.pixabay.com/photo/2021/03/26/11/16/woman-6127233_1280.jpg",
      },
      description: "Silky smooth blouse for casual and formal occasions.",
      rating: 4.8,
    ),
    Product(
      id: "3",
      name: "High-Waisted Jeans",
      price: 7900.99,
      size: ["M", "L", "XL"],
      colors: ["#1E90FF", "#708090"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2017/08/06/01/24/people-2587437_640.jpg",
      imagesByColor: {
        "#1E90FF":
            "https://cdn.pixabay.com/photo/2017/08/06/01/24/people-2587437_1280.jpg",
        "#708090":
            "https://cdn.pixabay.com/photo/2021/01/15/19/28/jeans-5919633_1280.jpg",
      },
      description: "Comfortable high-waisted jeans that fit any style.",
      rating: 4.3,
    ),
    Product(
      id: "4",
      name: "Leather Jacket",
      price: 12900.99,
      size: ["M", "L"],
      colors: ["#000000"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2024/01/20/13/44/woman-8521140_640.jpg",
      imagesByColor: {
        "#000000":
            "https://cdn.pixabay.com/photo/2024/01/20/13/44/woman-8521140_1280.jpg",
      },
      description: "Classic black leather jacket with premium feel.",
      rating: 4.9,
    ),
    Product(
      id: "5",
      name: "Knit Sweater",
      price: 6900.99,
      size: ["S", "M", "L"],
      colors: ["#8B4513", "#FFFACD"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2020/02/01/16/41/girl-4810719_640.jpg",
      imagesByColor: {
        "#8B4513":
            "https://cdn.pixabay.com/photo/2020/02/01/16/41/girl-4810719_1280.jpg",
        "#FFFACD":
            "https://cdn.pixabay.com/photo/2019/12/14/21/14/woman-4695491_1280.jpg",
      },
      description: "Warm and stylish sweater for cold weather.",
      rating: 4.4,
    ),
    Product(
      id: "6",
      name: "Denim Skirt",
      price: 4900.99,
      size: ["XS", "S", "M", "L"],
      colors: ["#4682B4"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2019/07/26/06/12/girl-4364019_640.jpg",
      imagesByColor: {
        "#4682B4":
            "https://cdn.pixabay.com/photo/2019/07/26/06/12/girl-4364019_1280.jpg",
      },
      description: "Trendy denim skirt with perfect fit and length.",
      rating: 4.2,
    ),
    Product(
      id: "7",
      name: "Graphic Tee",
      price: 2999.99,
      size: ["S", "M", "L"],
      colors: ["#FFFFFF", "#000000"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2016/11/14/04/57/woman-1822656_640.jpg",
      imagesByColor: {
        "#FFFFFF":
            "https://cdn.pixabay.com/photo/2016/11/14/04/57/woman-1822656_1280.jpg",
        "#000000":
            "https://cdn.pixabay.com/photo/2016/03/27/22/22/hipster-1283826_1280.jpg",
      },
      description: "Soft cotton tee with stylish graphic prints.",
      rating: 4.1,
    ),
    Product(
      id: "8",
      name: "Chic Jumpsuit",
      price: 8500.99,
      size: ["S", "M", "L"],
      colors: ["#FF69B4", "#FFD700"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2021/04/03/02/52/ao-dai-6146369_640.jpg",
      imagesByColor: {
        "#FF69B4":
            "https://cdn.pixabay.com/photo/2021/04/03/02/52/ao-dai-6146369_1280.jpg",
        "#FFD700":
            "https://cdn.pixabay.com/photo/2019/06/05/14/32/jumpsuit-4253906_1280.jpg",
      },
      description: "Modern jumpsuit perfect for casual parties.",
      rating: 4.6,
    ),
  ];

  List<Product> _shopNowProducts = [
    Product(
      id: "s1",
      name: "Summer Sale Skirt",
      price: 2999.99,
      size: ["S", "M"],
      colors: ["#FF7F50", "#FFD700"],
      thumbnail:
          "https://cdn.pixabay.com/photo/2023/09/02/11/53/woman-8228748_1280.jpg",
      imagesByColor: {
        "#FF7F50":
            "https://cdn.pixabay.com/photo/2023/09/02/11/53/woman-8228748_1280.jpg",
        "#FFD700":
            "https://cdn.pixabay.com/photo/2019/10/12/16/03/skirt-4544372_1280.jpg",
      },
      description: "Limited time offer for stylish summer skirts.",
      rating: 4.6,
    ),
  ];

  List<CartItem> _cartItems = [];
  List<CartItem> _orders = [];

  List<Product> get products => _products;
  List<Product> get shopNowProducts => _shopNowProducts;
  List<CartItem> get cartItems => _cartItems;
  List<CartItem> get orders => _orders;

  void addToCart(CartItem product) {
    final exists = _cartItems.any(
      (item) =>
          item.id == product.id &&
          item.size == product.size &&
          item.color == product.color,
    );

    if (exists) {
      _cartItems = _cartItems.map((item) {
        if (item.id == product.id &&
            item.size == product.size &&
            item.color == product.color) {
          return CartItem(
            id: item.id,
            name: item.name,
            price: item.price,
            size: item.size,
            color: item.color,
            image: item.image,
            quantity: item.quantity + product.quantity,
          );
        }
        return item;
      }).toList();
    } else {
      if (_cartItems.length >= 10) {
        ScaffoldMessenger.of(_navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text(
              'You can only add up to 10 different items in your cart',
            ),
          ),
        );
        return;
      }
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void addMultipleToCart(List<CartItem> productsToAdd) {
    for (var product in productsToAdd) {
      final exists = _cartItems.any(
        (item) =>
            item.id == product.id &&
            item.size == product.size &&
            item.color == product.color,
      );

      if (exists) {
        _cartItems = _cartItems.map((item) {
          if (item.id == product.id &&
              item.size == product.size &&
              item.color == product.color) {
            return CartItem(
              id: item.id,
              name: item.name,
              price: item.price,
              size: item.size,
              color: item.color,
              image: item.image,
              quantity: item.quantity + product.quantity,
            );
          }
          return item;
        }).toList();
      } else {
        if (_cartItems.length >= 10) {
          ScaffoldMessenger.of(_navigatorKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Text(
                'Cart limit exceeded. Only 10 unique products allowed.',
              ),
            ),
          );
          break;
        }
        _cartItems.add(product);
      }
    }
    notifyListeners();
  }

  void updateCartQuantity(
    String id,
    String size,
    String color,
    int newQuantity,
  ) {
    _cartItems = _cartItems.map((item) {
      if (item.id == id && item.size == size && item.color == color) {
        return CartItem(
          id: item.id,
          name: item.name,
          price: item.price,
          size: item.size,
          color: item.color,
          image: item.image,
          quantity: newQuantity,
        );
      }
      return item;
    }).toList();
    notifyListeners();
  }

  void removeFromCart(String id, String size, String color) {
    _cartItems.removeWhere(
      (item) => item.id == id && item.size == size && item.color == color,
    );
    notifyListeners();
  }

  void placeOrder(List<CartItem> products) {
    _orders.addAll(products);
    notifyListeners();
  }

  void addProduct(Product newProduct) {
    _products.add(newProduct);
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _products.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void addShopNowProduct(Product newProduct) {
    _shopNowProducts.add(newProduct);
    notifyListeners();
  }

  void deleteShopNowProduct(String productId) {
    _shopNowProducts.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
