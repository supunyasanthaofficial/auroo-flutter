import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../context/Product_Provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  Product? _selectedProduct;
  bool _modalVisible = false;
  String _selectedSize = '';
  String _selectedColor = '';
  bool _imageViewerVisible = false;
  String _selectedImage = '';
  String _sortType = 'lowToHigh';
  bool _sortModalVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      print('Products: ${productProvider.products}');
      for (var i = 0; i < productProvider.products.length; i++) {
        final product = productProvider.products[i];
        if (product.price == null || product.price <= 0) {
          print(
            'Product $i (${product.name}) has invalid price: ${product.price}',
          );
        }
      }
    });
  }

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
      _selectedImage =
          product.imagesByColor[product.colors[0]] ?? product.thumbnail;
      _modalVisible = true;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductModal(),
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
          image: _selectedImage.isNotEmpty
              ? _selectedImage
              : _selectedProduct!.thumbnail,
          quantity: 1,
        ),
      );
      Navigator.pop(context); // Close modal
      Navigator.pushNamed(context, '/cart');
    } catch (e) {
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildImageViewer(),
    );
  }

  void _showSortModal() {
    setState(() {
      _sortModalVisible = true;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSortModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final cartItems = productProvider.cartItems;

    if (products == null || productProvider.addToCart == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Error: Product context is not available. Ensure SearchScreen is wrapped in ProductProvider.',
            style: TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final sortOptions = [
      {'label': 'Default', 'value': 'default'},
      {'label': 'Price: Low to High', 'value': 'lowToHigh'},
      {'label': 'Price: High to Low', 'value': 'highToLow'},
    ];

    final filteredProducts =
        products.where((product) {
          if (product.name == null) {
            print('Product missing name: $product');
            return false;
          }
          return product.name.toLowerCase().contains(_searchText.toLowerCase());
        }).toList()..sort((a, b) {
          final priceA = a.price;
          final priceB = b.price;
          if (_sortType == 'lowToHigh') return priceA.compareTo(priceB);
          if (_sortType == 'highToLow') return priceB.compareTo(priceA);
          return 0;
        });

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
              'Search Products',
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
                      Ionicons.cart,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Ionicons.search,
                          color: Color(0xFF999999),
                        ),
                        hintText: 'Search for items...',
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontFamily: 'Helvetica',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                        fontFamily: 'Helvetica',
                      ),
                      onChanged: (value) => setState(() => _searchText = value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
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
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Ionicons.filter,
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
            ),
          ),
          Expanded(
            child: products.isEmpty
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
                : filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      'No products found for "${_searchText.isEmpty ? "all" : _searchText}"',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF374151),
                        fontFamily: 'Helvetica',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          (MediaQuery.of(context).size.width - 32) / 2 / 280,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
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
                                  product.thumbnail.isNotEmpty
                                      ? product.thumbnail
                                      : 'https://via.placeholder.com/200',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox(
                                        height: 200,
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
                                      'Rs ${product.price.toStringAsFixed(2)}',
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
          ),
        ],
      ),
    );
  }

  Widget _buildSortModal() {
    final sortOptions = [
      {'label': 'Default', 'value': 'default'},
      {'label': 'Price: Low to High', 'value': 'lowToHigh'},
      {'label': 'Price: High to Low', 'value': 'highToLow'},
    ];

    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          padding: const EdgeInsets.all(16),
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
                'Sort by Price',
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
                    setState(() => _sortModalVisible = false);
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
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _sortModalVisible = false);
                },
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
                onTap: () => _handleImagePress(
                  _selectedProduct?.imagesByColor[_selectedColor] ??
                      _selectedProduct?.thumbnail ??
                      'https://via.placeholder.com/200',
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _selectedProduct?.imagesByColor[_selectedColor] ??
                        _selectedProduct?.thumbnail ??
                        'https://via.placeholder.com/200',
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                  fontFamily: 'Helvetica',
                ),
              ),
              Text(
                'Rs ${_selectedProduct?.price.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8E44AD),
                  fontFamily: 'Helvetica',
                ),
              ),
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
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                                _selectedImage =
                                    _selectedProduct?.imagesByColor[color] ??
                                    _selectedImage;
                              });
                            },
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
              const Text(
                'Reviews:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                  fontFamily: 'Helvetica',
                ),
              ),
              const Text(
                'No reviews available',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF444444),
                  fontFamily: 'Helvetica',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _navigateToCart,
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
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF444444),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
