import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../context/Product_Provider.dart';
import '../widgets/status_label.dart';

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
  bool _modalVisible = false;

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
      _modalVisible = true;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductModal(),
    ).then((_) => setState(() => _modalVisible = false));
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
      Navigator.pop(context);
      debugPrint('Navigating to /cart');
      Navigator.pushNamed(context, '/cart');
    } catch (e) {
      debugPrint('Cart navigation error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to navigate to cart: $e')));
    }
  }

  void _handleImagePress(String imageUri) {
    setState(() {
      _selectedImage = imageUri.isNotEmpty
          ? imageUri
          : 'https://via.placeholder.com/200';
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildImageViewer(),
    );
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
            'https://cdn.pixabay.com/photo/2016/03/23/08/34/woman-1274360_640.jpg',
      },
      {
        'id': '2',
        'title': 'Up to 70% Off',
        'subtitle': 'New year special sale',
        'buttonText': 'Shop Now',
        'image':
            'https://cdn.pixabay.com/photo/2023/12/23/22/15/teen-photo-8466399_1280.jpg',
      },
      {
        'id': '3',
        'title': 'Our Website',
        'subtitle': 'Explore our latest collections',
        'buttonText': 'Visit Now',
        'image':
            'https://cdn.pixabay.com/photo/2021/04/17/18/26/woman-6186493_1280.jpg',
        'url': 'https://www.auroo.com',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            banner['image']!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: const Color(0xFFE5E7EB),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Banner image error: $error');
                              return Container(
                                color: const Color(0xFFE5E7EB),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                stops: const [0.3, 1.0],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner['title']!,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Helvetica',
                                    shadows: [
                                      Shadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.6),
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  banner['subtitle']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Helvetica',
                                    shadows: [
                                      Shadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                        offset: Offset(0, 1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8E44AD),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 3,
                                  ),
                                  onPressed: () async {
                                    if (banner.containsKey('url') &&
                                        banner['url'] != null) {
                                      final url = banner['url']!;
                                      try {
                                        final uri = Uri.parse(url);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                          debugPrint('Opening URL: $url');
                                        } else {
                                          debugPrint('Cannot launch URL: $url');
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Cannot open URL: $url',
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        debugPrint('URL launch error: $e');
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to open URL: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          child: Stack(
                            children: [
                              Column(
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
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const SizedBox(
                                              height: 200,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            debugPrint(
                                              'Product image error: $error',
                                            );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                              Positioned(
                                top: 8,
                                left: 8,
                                child: StatusLabel(
                                  status: product.status,
                                  isOutOfStock: product.isOutOfStock,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Color.fromARGB(255, 14, 13, 13),
                                    size: 20,
                                  ),
                                  onPressed: () => _openModal(product),
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
      snap: true,
      snapSizes: const [0.5, 0.9],
      builder: (context, scrollController) => StatefulBuilder(
        builder: (BuildContext modalContext, StateSetter setModalState) =>
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint('Image tapped: $_displayImage');
                        _handleImagePress(_displayImage);
                      },
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
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedProduct?.name ?? 'Unknown Product',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        if (_selectedProduct != null)
                          StatusLabel(
                            status: _selectedProduct!.status,
                            isOutOfStock: _selectedProduct!.isOutOfStock,
                          ),
                      ],
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
                    if (_selectedProduct?.isOutOfStock == true) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: const Text(
                          'This product is currently out of stock',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Helvetica',
                          ),
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _selectedProduct?.size
                              .map(
                                (size) => FilterChip(
                                  label: Text(
                                    size,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF333333),
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                  selected: _selectedSize == size,
                                  selectedColor: const Color(0xFFF1E6FA),
                                  backgroundColor: Colors.white,
                                  checkmarkColor: const Color(0xFF8E44AD),
                                  side: BorderSide(
                                    color: _selectedSize == size
                                        ? const Color(0xFF8E44AD)
                                        : const Color(0xFFCCCCCC),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onSelected:
                                      _selectedProduct?.isOutOfStock == true
                                      ? null
                                      : (selected) {
                                          if (selected) {
                                            debugPrint('Size selected: $size');
                                            _selectedSize = size;
                                            setModalState(() {});
                                          }
                                        },
                                ),
                              )
                              .toList() ??
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          _selectedProduct?.colors
                              .map(
                                (color) => InkWell(
                                  onTap: _selectedProduct?.isOutOfStock == true
                                      ? null
                                      : () {
                                          debugPrint('Color selected: $color');
                                          _selectedColor = color;
                                          _displayImage =
                                              _selectedProduct
                                                  ?.imagesByColor[color] ??
                                              _displayImage;
                                          setModalState(() {});
                                        },
                                  splashColor: const Color(
                                    0xFF8E44AD,
                                  ).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        int.parse(
                                          color.replaceFirst('#', '0xFF'),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _selectedColor == color
                                            ? const Color(0xFF8E44AD)
                                            : const Color(0xFFCCCCCC),
                                        width: _selectedColor == color ? 3 : 1,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _selectedProduct?.isOutOfStock == true
                              ? Colors.grey
                              : const Color(0xFF8E44AD),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _selectedProduct?.isOutOfStock == true
                            ? null
                            : () {
                                debugPrint('Add to Cart button pressed');
                                _navigateToCart();
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Ionicons.cart,
                              size: 20,
                              color: _selectedProduct?.isOutOfStock == true
                                  ? Colors.white70
                                  : Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedProduct?.isOutOfStock == true
                                  ? 'Out of Stock'
                                  : 'Add to Cart',
                              style: TextStyle(
                                color: _selectedProduct?.isOutOfStock == true
                                    ? Colors.white70
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          debugPrint('Close button pressed');
                          Navigator.pop(context);
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
                    ),
                  ],
                ),
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
                  size: 40,
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
