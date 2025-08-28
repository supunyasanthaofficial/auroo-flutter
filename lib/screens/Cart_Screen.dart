import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../context/Product_Provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<String, bool> _selectedItems;

  @override
  void initState() {
    super.initState();
    final productProvider = context.read<ProductProvider>();
    _selectedItems = {
      for (var item in productProvider.cartItems)
        '${item.id}${item.size}${item.color}': true,
    };
    print('CartScreen mounted, cartItems: ${productProvider.cartItems}');
  }

  void _handlePlaceOrder(BuildContext context) {
    final productProvider = context.read<ProductProvider>();
    final selectedOrderItems = productProvider.cartItems
        .asMap()
        .entries
        .where(
          (entry) =>
              _selectedItems['${entry.value.id}${entry.value.size}${entry.value.color}'] ==
              true,
        )
        .map(
          (entry) => CartItem(
            id: entry.value.id,
            name: entry.value.name,
            price: entry.value.price,
            size: entry.value.size,
            color: entry.value.color,
            image: entry.value.image,
            quantity: entry.value.quantity,
          ),
        )
        .toList();

    if (selectedOrderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one item to place an order.'),
        ),
      );
      return;
    }

    try {
      productProvider.placeOrder(selectedOrderItems);
      print('Order placed: $selectedOrderItems');
      Navigator.pushNamed(context, '/login', arguments: selectedOrderItems);
    } catch (e) {
      print('Place order error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to place order')));
    }
  }

  void _handleSelectItem(String itemKey) {
    setState(() {
      _selectedItems[itemKey] = !(_selectedItems[itemKey] ?? false);
    });
  }

  void _handleIncreaseQuantity(CartItem item) {
    context.read<ProductProvider>().updateCartQuantity(
      item.id,
      item.size,
      item.color,
      item.quantity + 1,
    );
  }

  void _handleDecreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      context.read<ProductProvider>().updateCartQuantity(
        item.id,
        item.size,
        item.color,
        item.quantity - 1,
      );
    } else {
      context.read<ProductProvider>().removeFromCart(
        item.id,
        item.size,
        item.color,
      );
      setState(() {
        _selectedItems.remove('${item.id}${item.size}${item.color}');
      });
    }
  }

  void _handleRemoveItem(CartItem item) {
    context.read<ProductProvider>().removeFromCart(
      item.id,
      item.size,
      item.color,
    );
    setState(() {
      _selectedItems.remove('${item.id}${item.size}${item.color}');
    });
  }

  double _calculateTotalPrice(List<CartItem> cartItems) {
    return cartItems
        .asMap()
        .entries
        .where(
          (entry) =>
              _selectedItems['${entry.value.id}${entry.value.size}${entry.value.color}'] ==
              true,
        )
        .fold(
          0.0,
          (total, entry) => total + entry.value.price * entry.value.quantity,
        );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartItems = productProvider.cartItems;

    if (cartItems.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Your cart is empty.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF374151),
              fontFamily: 'Helvetica',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
              'Your Cart',
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
              icon: const Icon(
                Ionicons.arrow_back,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final itemKey = '${item.id}${item.size}${item.color}';
          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _handleSelectItem(itemKey),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _selectedItems[itemKey] == true
                          ? Ionicons.checkbox
                          : Ionicons.square_outline,
                      size: 24,
                      color: const Color(0xFF8E44AD),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.image.isNotEmpty
                        ? item.image
                        : 'https://via.placeholder.com/100',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name.isNotEmpty ? item.name : 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        Text(
                          'Size: ${item.size}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Color: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: item.color.isNotEmpty
                                    ? Color(
                                        int.parse(
                                          item.color.replaceFirst('#', '0xFF'),
                                        ),
                                      )
                                    : const Color(0xFFCCCCCC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFCCCCCC),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Quantity: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _handleDecreaseQuantity(item),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8E44AD),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  '−',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _handleIncreaseQuantity(item),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8E44AD),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Rs ${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _handleRemoveItem(item),
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB10808),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: Rs ${_calculateTotalPrice(cartItems).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E44AD),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 0),
              ),
              onPressed: () => _handlePlaceOrder(context),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
