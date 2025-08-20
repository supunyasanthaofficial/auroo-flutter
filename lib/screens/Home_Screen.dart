import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../context/Product_Provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _sortType = 'default';
  Product? _selectedProduct;
  String _selectedSize = '';
  String _selectedColor = '';
  String _displayImage = '';
  String _selectedImage = '';

  void _openModal(Product product) {
    if (product.colors.isEmpty || product.size.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid product data')));
      return;
    }
    setState(() {
      _selectedProduct = product;
      _selectedSize = product.size[0];
      _selectedColor = product.colors[0];
      _displayImage =
          product.imagesByColor[product.colors[0]] ?? product.thumbnail;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductModal(),
    );
  }

  void _handleColorChange(String color) {
    setState(() {
      _selectedColor = color;
      _displayImage = _selectedProduct?.imagesByColor[color] ?? _displayImage;
    });
  }

  void _handleImagePress(String imageUri) {
    setState(() {
      _selectedImage = imageUri;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildImageViewer(),
    );
  }

  void _navigateToCart() {
    if (_selectedProduct == null ||
        _selectedSize.isEmpty ||
        _selectedColor.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select size and color')),
      );
      return;
    }
    try {
      context.read<ProductProvider>().addToCart(
        CartItem(
          id: _selectedProduct!.id,
          name: _selectedProduct!.name,
          price: _selectedProduct!.price,
          size: _selectedSize,
          color: _selectedColor,
          image: _displayImage,
          quantity: 1,
        ),
      );
      Navigator.pop(context); // Close modal
      debugPrint('Navigating to /cart');
      Navigator.pushNamed(context, '/cart');
    } catch (e) {
      debugPrint('Cart navigation error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to navigate to cart: $e')));
    }
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSortModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final cartItems = productProvider.cartItems;
    final shopNowProducts = productProvider.shopNowProducts;
    debugPrint(
      'Products: ${products.length}, Cart: ${cartItems.length}, ShopNow: ${shopNowProducts.length}',
    );

    final sortOptions = [
      {'label': 'Default', 'value': 'default'},
      {'label': 'Price Low to High', 'value': 'priceLowToHigh'},
      {'label': 'Price High to Low', 'value': 'priceHighToLow'},
    ];

    final sortedProducts = List<Product>.from(products)
      ..sort((a, b) {
        if (_sortType == 'priceLowToHigh') {
          return a.price.compareTo(b.price);
        } else if (_sortType == 'priceHighToLow') {
          return b.price.compareTo(a.price);
        }
        return 0;
      });

    final banners = [
      {
        'id': '1',
        'title': 'Up to 70% Off',
        'subtitle': 'Your dress up clothes first',
        'buttonText': 'Shop Now',
        'image':
            'https://cdn.pixabay.com/photo/2021/09/03/13/32/portrait-6595821_1280.jpg',
      },
      {
        'id': '2',
        'title': 'Up to 70% Off',
        'subtitle': 'New year special sale',
        'buttonText': 'Shop Now',
        'image':
            'https://cdn.pixabay.com/photo/2023/12/23/22/15/teen-photo-8466399_1280.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 30),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD8BFD8), Color(0xFFC6A1CF)],
            ),
          ),
          child: AppBar(
            title: const Text(
              "Women's Fashion",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Helvetica',
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () {
                      debugPrint('Navigating to /cart from app bar');
                      try {
                        Navigator.pushNamed(context, '/cart');
                      } catch (e) {
                        debugPrint('App bar cart navigation error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to open cart: $e')),
                        );
                      }
                    },
                  ),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF0000),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${cartItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return Container(
                    width: MediaQuery.of(context).size.width - 32,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            banner['image']!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Banner image error: $error');
                              return const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFC6A1CF).withOpacity(0.7),
                                  const Color(0xFFD8BFD8).withOpacity(0.9),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  banner['title']!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Helvetica',
                                    shadows: [
                                      Shadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.3),
                                        offset: Offset(0, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  banner['subtitle']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Helvetica',
                                    shadows: [
                                      Shadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.3),
                                        offset: Offset(0, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8E44AD),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    debugPrint('Navigating to /shop_now');
                                    try {
                                      Navigator.pushNamed(
                                        context,
                                        '/shop_now',
                                        arguments: shopNowProducts,
                                      );
                                    } catch (e) {
                                      debugPrint(
                                        'Shop now navigation error: $e',
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to open shop: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    banner['buttonText']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Collection',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  GestureDetector(
                    onTap: _showSortModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.filter_list,
                            size: 20,
                            color: Color(0xFF8E44AD),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sort: ${sortOptions.firstWhere((opt) => opt['value'] == _sortType)['label']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8E44AD),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sortedProducts.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No products available yet. Check back soon!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF374151),
                        fontFamily: 'Helvetica',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          (MediaQuery.of(context).size.width - 32) / 2 / 280,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: sortedProducts.length,
                    itemBuilder: (context, index) {
                      final product = sortedProducts[index];
                      return GestureDetector(
                        onTap: () => _openModal(product),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.thumbnail,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('Product image error: $error');
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                        fontFamily: 'Helvetica',
                                      ),
                                    ),
                                    Text(
                                      'LKR ${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF8E44AD),
                                        fontFamily: 'Helvetica',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortModal() {
    final sortOptions = [
      {'label': 'Default', 'value': 'default'},
      {'label': 'Price Low to High', 'value': 'priceLowToHigh'},
      {'label': 'Price High to Low', 'value': 'priceHighToLow'},
    ];

    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                  fontFamily: 'Helvetica',
                ),
              ),
              const SizedBox(height: 16),
              ...sortOptions.map(
                (option) => GestureDetector(
                  onTap: () {
                    setState(() => _sortType = option['value']!);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: _sortType == option['value']
                          ? const Color(0xFFF1E6FA)
                          : Colors.white,
                      border: const Border(
                        bottom: BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    child: Text(
                      option['label']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: _sortType == option['value']
                            ? const Color(0xFF8E44AD)
                            : const Color(0xFF374151),
                        fontWeight: _sortType == option['value']
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Helvetica',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductModal() {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 10),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _handleImagePress(_displayImage),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _displayImage,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Modal image error: $error');
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Text(
                _selectedProduct?.name ?? 'Unknown Product',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                  fontFamily: 'Helvetica',
                ),
              ),
              Text(
                'LKR ${_selectedProduct?.price.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8E44AD),
                  fontFamily: 'Helvetica',
                ),
              ),
              if (_selectedProduct?.rating != null)
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < _selectedProduct!.rating
                          ? Icons.star
                          : Icons.star_border,
                      size: 18,
                      color: const Color(0xFFF1C40F),
                    ),
                  ),
                ),
              if (_selectedProduct?.description != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF555555),
                    fontFamily: 'Helvetica',
                  ),
                ),
                Text(
                  _selectedProduct!.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF444444),
                    fontFamily: 'Helvetica',
                  ),
                ),
              ],
              const SizedBox(height: 12),
              const Text(
                'Select Size:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                  fontFamily: 'Helvetica',
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    _selectedProduct?.size
                        .map(
                          (size) => GestureDetector(
                            onTap: () => setState(() => _selectedSize = size),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedSize == size
                                      ? const Color(0xFF8E44AD)
                                      : const Color(0xFFCCCCCC),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: _selectedSize == size
                                    ? const Color(0xFFF1E6FA)
                                    : Colors.white,
                              ),
                              child: Text(
                                size,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                            ),
                          ),
                        )
                        ?.toList() ??
                    [],
              ),
              const SizedBox(height: 12),
              const Text(
                'Select Color:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                  fontFamily: 'Helvetica',
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    _selectedProduct?.colors
                        .map(
                          (color) => GestureDetector(
                            onTap: () => _handleColorChange(color),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(color.replaceFirst('#', '0xFF')),
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedColor == color
                                      ? const Color(0xFF8E44AD)
                                      : const Color(0xFFCCCCCC),
                                  width: _selectedColor == color ? 2 : 1,
                                ),
                              ),
                            ),
                          ),
                        )
                        ?.toList() ??
                    [],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _navigateToCart,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart, size: 20, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF444444),
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageViewer() {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.9),
      child: Stack(
        children: [
          Center(
            child: Image.network(
              _selectedImage,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Image viewer error: $error');
                return const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.white,
                );
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
