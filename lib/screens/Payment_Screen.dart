import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../context/Product_Provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const double deliveryFee = 500;
  String _selectedMethod = 'card';

  double _calculateSubtotal(List<CartItem> cartItems) {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * (item.quantity)),
    );
  }

  void _handlePayment(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final cartItems = args?['cartItems'] as List<CartItem>? ?? [];
    final checkoutDetails =
        args?['checkoutDetails'] as Map<String, String>? ?? {};
    final total = _calculateSubtotal(cartItems) + deliveryFee;

    if (checkoutDetails.isEmpty) {
      print(
        'Warning: checkoutDetails is empty or missing. Proceeding with navigation.',
      );
    }

    final targetRoute = _selectedMethod == 'card'
        ? '/card_payment'
        : '/cod_payment';

    try {
      Navigator.pushNamed(
        context,
        targetRoute,
        arguments: {
          'cartItems': cartItems,
          'checkoutDetails': checkoutDetails,
          'total': total,
        },
      );
      print(
        'Navigating to: $targetRoute, Arguments: {cartItems: $cartItems, checkoutDetails: $checkoutDetails, total: $total}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: Unable to navigate to $targetRoute. Please ensure the screen is registered.',
          ),
        ),
      );
      print('Navigation Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final cartItems = args?['cartItems'] as List<CartItem>? ?? [];
    final checkoutDetails =
        args?['checkoutDetails'] as Map<String, String>? ?? {};

    if (cartItems.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'Your cart is empty.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4B5563),
                fontFamily: 'Helvetica',
              ),
            ),
          ),
        ),
      );
    }

    final subtotal = _calculateSubtotal(cartItems);
    final total = subtotal + deliveryFee;

    print('Received cartItems: $cartItems');
    print('Received checkoutDetails: $checkoutDetails');

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
              'Payment',
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
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
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
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...cartItems.asMap().entries.map((entry) {
                      final product = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 60,
                                        child: Text(
                                          'Price:',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF4B5563),
                                            fontFamily: 'Helvetica',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Rs ${(product.price * product.quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1F2937),
                                          fontFamily: 'Helvetica',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 60,
                                        child: Text(
                                          'Size:',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF4B5563),
                                            fontFamily: 'Helvetica',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        product.size.isNotEmpty
                                            ? product.size
                                            : 'N/A',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1F2937),
                                          fontFamily: 'Helvetica',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 60,
                                        child: Text(
                                          'Color:',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF4B5563),
                                            fontFamily: 'Helvetica',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: product.color.isNotEmpty
                                              ? Color(
                                                  int.parse(
                                                    product.color.replaceFirst(
                                                      '#',
                                                      '0xFF',
                                                    ),
                                                  ),
                                                )
                                              : const Color(0xFFCCCCCC),
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF999999),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
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
                          'Rs ${total.toStringAsFixed(2)}',
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
              Container(
                width: double.infinity,
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
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => _selectedMethod = 'card'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedMethod == 'card'
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFFD1D5DB),
                          ),
                          color: _selectedMethod == 'card'
                              ? const Color(0xFFF6EDFA)
                              : Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.card_outline,
                              size: 24,
                              color: Color(0xFF1F2937),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'Credit / Debit Card',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1F2937),
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => setState(() => _selectedMethod = 'cod'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedMethod == 'cod'
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFFD1D5DB),
                          ),
                          color: _selectedMethod == 'cod'
                              ? const Color(0xFFF6EDFA)
                              : Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.cash_outline,
                              size: 24,
                              color: Color(0xFF1F2937),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1F2937),
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
              const SizedBox(height: 30),
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
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 0),
                  shadowColor: const Color(0xFF000000),
                  elevation: 5,
                ),
                onPressed: () => _handlePayment(context),
                child: const Text(
                  'Continue',
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
