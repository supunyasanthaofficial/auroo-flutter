import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../context/Product_Provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final Set<int> _selected = {};

  void _toggleSelect(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  void _handleDeleteSelected(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Selected'),
        content: const Text(
          'Are you sure you want to delete the selected orders?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final productProvider = Provider.of<ProductProvider>(
                context,
                listen: false,
              );
              final remaining = productProvider.orders
                  .asMap()
                  .entries
                  .where((entry) => !_selected.contains(entry.key))
                  .map((entry) => entry.value)
                  .toList();
              productProvider.setOrders(remaining);
              setState(() {
                _selected.clear();
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDelivery(
    BuildContext context,
    int index,
    ProductProvider provider,
  ) {
    provider.updateDeliveryStatus(index, 'Delivered');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Order marked as delivered! Thank you for your purchase.',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildDeliveryStatus(String status) {
    final statusMap = {
      'Ordered': {'progress': 0.25, 'color': Colors.blue},
      'Shipped': {'progress': 0.5, 'color': Colors.orange},
      'Out for Delivery': {'progress': 0.75, 'color': Colors.purple},
      'Delivered': {'progress': 1.0, 'color': Colors.green},
    };

    final progress = statusMap[status]?['progress'] as double? ?? 0.0;
    final color = statusMap[status]?['color'] as Color? ?? Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status: $status',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
            fontFamily: 'Helvetica',
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFE5E7EB),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final orders = productProvider.orders;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 42),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD8BFD8), Color(0xFFC6A1CF)],
            ),
          ),
          child: AppBar(
            title: const Text(
              'My Orders',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Helvetica',
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: SafeArea(
        child: orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Ionicons.cart_outline,
                      size: 80,
                      color: Color(0xFFD1D5DB),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF9CA3AF),
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 12, bottom: 100),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final item = orders[index];
                      if (item.name.isEmpty ||
                          item.price == 0.0 ||
                          item.image.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final isSelected = _selected.contains(index);

                      return GestureDetector(
                        onLongPress: () => _toggleSelect(index),
                        onTap: () =>
                            _selected.isNotEmpty ? _toggleSelect(index) : null,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFFA78BFA),
                                    width: 2,
                                  )
                                : null,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 85,
                                    height: 105,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xFFE5E7EB),
                                      image: DecorationImage(
                                        image: NetworkImage(item.image),
                                        fit: BoxFit.cover,
                                        onError: (error, stackTrace) =>
                                            const AssetImage(
                                              'assets/placeholder.png',
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1F2937),
                                            fontFamily: 'Helvetica',
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'LKR ${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF4B5563),
                                            fontFamily: 'Helvetica',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildDeliveryStatus(
                                          item.deliveryStatus,
                                        ),
                                        if (item.deliveryStatus != 'Delivered')
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF8B5CF6,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () => _confirmDelivery(
                                                context,
                                                index,
                                                productProvider,
                                              ),
                                              child: const Text(
                                                'Confirm Delivery',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Helvetica',
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (isSelected)
                                const Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Icon(
                                    Ionicons.checkmark_circle,
                                    size: 24,
                                    color: Color(0xFF8B5CF6),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (_selected.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB10808),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () => _handleDeleteSelected(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Ionicons.trash_outline,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delete Selected (${_selected.length})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
    );
  }
}
