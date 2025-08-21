import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../context/Product_Provider.dart';

class ShopNowScreen extends StatefulWidget {
  const ShopNowScreen({super.key});

  @override
  State<ShopNowScreen> createState() => _ShopNowScreenState();
}

class _ShopNowScreenState extends State<ShopNowScreen> {
  Product? _selectedProduct;
  bool _modalVisible = false;
  String _selectedSize = '';
  String _selectedColor = '';
  String _displayImage = '';
  bool _imageViewerVisible = false;
  String _selectedImage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopNowProducts =
          ModalRoute.of(context)?.settings.arguments as List<Product>?;
      print('ShopNowScreen mounted');
      print('shopNowProducts: $shopNowProducts');
      if (shopNowProducts == null || shopNowProducts.isEmpty) {
        print('shopNowProducts is null or empty');
      } else {
        for (var i = 0; i < shopNowProducts.length; i++) {
          final p = shopNowProducts[i];
          if (p.id.isEmpty ||
              p.name.isEmpty ||
              p.price <= 0 ||
              p.colors.isEmpty ||
              p.size.isEmpty) {
            print('Product $i has invalid data: $p');
          }
        }
      }
    });
  }

  void _openModal(Product product) {
    if (product.id.isEmpty ||
        product.name.isEmpty ||
        product.colors.isEmpty ||
        product.size.isEmpty) {
      print('Invalid product data: $product');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid product data')));
      return;
    }
    setState(() {
      _selectedProduct = product;
      _selectedSize = product.size.isNotEmpty ? product.size[0] : '';
      _selectedColor = product.colors.isNotEmpty ? product.colors[0] : '';
      _displayImage = product.imagesByColor.containsKey(_selectedColor)
          ? product.imagesByColor[_selectedColor]!
          : product.thumbnail.isNotEmpty
          ? product.thumbnail
          : 'https://via.placeholder.com/200';
      _modalVisible = true;
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
      _displayImage = _selectedProduct?.imagesByColor.containsKey(color) == true
          ? _selectedProduct!.imagesByColor[color]!
          : _selectedProduct?.thumbnail.isNotEmpty == true
          ? _selectedProduct!.thumbnail
          : 'https://via.placeholder.com/200';
    });
    print('Selected color: $color, Image: $_displayImage');
  }

  void _handleAddToCart() {
    if (_selectedProduct == null ||
        _selectedSize.isEmpty ||
        _selectedColor.isEmpty) {
      print(
        'Missing selection: $_selectedProduct, $_selectedSize, $_selectedColor',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select size and color')),
      );
      return;
    }
    try {
      final cartItem = CartItem(
        id: _selectedProduct!.id,
        name: _selectedProduct!.name,
        price: _selectedProduct!.price,
        size: _selectedSize,
        color: _selectedColor,
        image: _displayImage.isNotEmpty
            ? _displayImage
            : _selectedProduct!.thumbnail,
        quantity: 1,
      );
      context.read<ProductProvider>().addToCart(cartItem);
      print('Added to cart: $cartItem');
      Navigator.pop(context); // Close modal
      Navigator.pushNamed(context, '/cart');
    } catch (e) {
      print('Add to cart error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add item to cart')),
      );
    }
  }

  void _handleImagePress(String imageUri) {
    setState(() {
      _selectedImage = imageUri.isNotEmpty
          ? imageUri
          : 'https://via.placeholder.com/200';
      _imageViewerVisible = true;
    });
    print('Image viewer opened for: $imageUri');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildImageViewer(),
    );
  }

  Widget _buildStarRating(double? rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < (rating?.floor() ?? 0) ? Icons.star : Icons.star_border,
          size: 16,
          color: const Color(0xFFF1C40F),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartItems = productProvider.cartItems;
    final shopNowProducts =
        ModalRoute.of(context)?.settings.arguments as List<Product>?;

    if (shopNowProducts == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Error: Product context or shopNowProducts is not available.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontFamily: 'Helvetica',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FF),
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
              'Shop Now Deals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Helvetica',
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Ionicons.cart_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      print('Navigating to Cart, items: ${cartItems.length}');
                      Navigator.pushNamed(context, '/cart');
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
      body: shopNowProducts.isEmpty
          ? const Center(
              child: Text(
                'No products available',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF374151),
                  fontFamily: 'Helvetica',
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    (MediaQuery.of(context).size.width - 48) / 2 / 220,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: shopNowProducts.length,
              itemBuilder: (context, index) {
                final product = shopNowProducts[index];
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
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.thumbnail.isNotEmpty
                                    ? product.thumbnail
                                    : 'https://via.placeholder.com/200',
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const SizedBox(
                                        height: 150,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name.isNotEmpty
                                        ? product.name
                                        : 'Unknown Product',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                  Text(
                                    'Rs ${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF8E44AD),
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            // decoration: BoxDecoration(
                            //   color: Color(0xFF8E44AD),
                            //   borderRadius: BorderRadius.circular(25),
                            // ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Color.fromARGB(255, 14, 13, 13),
                                size: 20,
                              ),
                              onPressed: () => _openModal(product),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProductModal() {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        margin: const EdgeInsets.all(16),
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
                  borderRadius: BorderRadius.circular(10),
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
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 250,
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                  ),
                ),
              ),
              Text(
                _selectedProduct?.name ?? 'Unknown Product',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                  fontFamily: 'Helvetica',
                ),
              ),
              Text(
                'Rs ${_selectedProduct?.price.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8E44AD),
                  fontFamily: 'Helvetica',
                ),
              ),
              if (_selectedProduct?.rating != null) ...[
                const SizedBox(height: 6),
                _buildStarRating(_selectedProduct!.rating),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _selectedProduct?.description ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontFamily: 'Helvetica',
                  ),
                ),
              ),
              const Text(
                'Size:',
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
                                borderRadius: BorderRadius.circular(6),
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
                        .toList() ??
                    [],
              ),
              const SizedBox(height: 10),
              const Text(
                'Color:',
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
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList() ??
                    [],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _handleAddToCart,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Ionicons.cart, size: 20, color: Colors.white),
                    SizedBox(width: 8),
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
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF444444),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _modalVisible = false);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Ionicons.close, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                setState(() => _imageViewerVisible = false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
