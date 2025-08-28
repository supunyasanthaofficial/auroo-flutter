import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../context/Product_Provider.dart';

class CODPaymentScreen extends StatelessWidget {
  const CODPaymentScreen({super.key});

  static const double deliveryFee = 500;

  double _calculateGrandTotal(List<CartItem> cartItems) {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void _handleConfirmOrder(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final cartItems = args?['cartItems'] as List<CartItem>? ?? [];
    final checkoutDetails =
        args?['checkoutDetails'] as Map<String, String>? ?? {};
    final userEmail = args?['userEmail'] as String? ?? '';

    if (checkoutDetails['fullName'] == null ||
        checkoutDetails['phone'] == null ||
        checkoutDetails['address'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout details are incomplete.')),
      );
      Navigator.pushNamed(
        context,
        '/checkout',
        arguments: {'cartItems': cartItems, 'userEmail': userEmail},
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order Confirmed: COD Payment Successful')),
    );
    Navigator.pushNamed(context, '/my_orders');
  }

  void _handleEditCheckoutDetails(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final cartItems = args?['cartItems'] as List<CartItem>? ?? [];
    final userEmail = args?['userEmail'] as String? ?? '';

    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {'cartItems': cartItems, 'userEmail': userEmail},
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final cartItems = args?['cartItems'] as List<CartItem>? ?? [];
    final checkoutDetails =
        args?['checkoutDetails'] as Map<String, String>? ?? {};

    final grandTotal = _calculateGrandTotal(cartItems);
    final totalWithDelivery = grandTotal + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
              'Cash on Delivery',
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
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          child: Column(
            children: [
              ...cartItems.asMap().entries.map((entry) {
                final product = entry.value;
                final subtotal = product.price * product.quantity;
                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Item ${entry.key + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Helvetica',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Name:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          Text(
                            product.name.isNotEmpty
                                ? product.name
                                : 'Unknown Product',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Size:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          Text(
                            product.size.isNotEmpty ? product.size : 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Color:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: product.color.isNotEmpty
                                  ? Color(
                                      int.parse(
                                        product.color.replaceFirst('#', '0xFF'),
                                      ),
                                    )
                                  : const Color(0xFFCCCCCC),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Qty:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          Text(
                            '${product.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                          Text(
                            'Rs ${subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Helvetica',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        Text(
                          'Rs ${grandTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Fee',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        Text(
                          'Rs ${deliveryFee.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        Text(
                          'Rs ${totalWithDelivery.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8B5CF6),
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (checkoutDetails.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Helvetica',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Name: ${checkoutDetails['fullName'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF374151),
                          fontFamily: 'Helvetica',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Phone: ${checkoutDetails['phone'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF374151),
                          fontFamily: 'Helvetica',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Address: ${checkoutDetails['address'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF374151),
                          fontFamily: 'Helvetica',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7280),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        onPressed: () => _handleEditCheckoutDetails(context),
                        child: const Text(
                          'Edit Delivery Details',
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
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 0),
                  shadowColor: const Color(0xFF000000),
                  elevation: 5,
                ),
                onPressed: () => _handleConfirmOrder(context),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
}
