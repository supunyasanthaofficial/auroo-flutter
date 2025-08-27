import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../context/Product_Provider.dart';

class TrackingDetailsScreen extends StatefulWidget {
  final CartItem order;

  const TrackingDetailsScreen({super.key, required this.order});

  @override
  State<TrackingDetailsScreen> createState() => _TrackingDetailsScreenState();
}

class _TrackingDetailsScreenState extends State<TrackingDetailsScreen> {
  Timer? _timer;
  List<Map<String, dynamic>>? trackingSteps;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize tracking data
    _loadTrackingData();
    // Start timer to refresh tracking data every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _loadTrackingData(); // Refresh data to reflect status updates
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Load tracking data for frontend testing
  // Backend developer: Replace this method with an API call to fetch tracking data
  // Expected format: List<Map<String, dynamic>> with keys 'title', 'date', 'isCompleted'
  void _loadTrackingData() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      // Simulate API delay for realistic frontend testing
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          final provider = Provider.of<ProductProvider>(context, listen: false);
          final order = provider.orders.firstWhere(
            (item) => item.id == widget.order.id,
            orElse: () => widget.order,
          );
          // Update delivery status (optional, remove if backend handles this)
          provider.simulateStatusUpdate(widget.order.id);
          setState(() {
            trackingSteps = getTrackingSteps(order.deliveryStatus ?? 'Ordered');
            isLoading = false;
          });
          // Debug print to verify tracking steps
          debugPrint('Tracking Steps: $trackingSteps');
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load tracking data: $e';
      });
      debugPrint('Error loading tracking data: $e');
    }
  }

  Widget _buildTrackingStep({
    required String title,
    required String date,
    required bool isCompleted,
    required bool isLast,
  }) {
    IconData stepIcon;
    switch (title) {
      case 'Order Placed':
        stepIcon = Ionicons.cart_outline;
        break;
      case 'Shipped':
        stepIcon = Ionicons.airplane_outline;
        break;
      case 'Out for Delivery':
        stepIcon = Ionicons.car_outline;
        break;
      case 'Delivered':
        stepIcon = Ionicons.checkbox_outline;
        break;
      default:
        stepIcon = Ionicons.ellipse_outline;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? stepIcon : Ionicons.ellipse_outline,
              color: isCompleted ? Colors.green : Colors.grey,
              size: 24,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isCompleted ? Colors.black : Colors.grey,
                fontFamily: 'Helvetica',
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Helvetica',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Mock data for frontend testing
  // Backend developer: Replace this with API response parsing
  List<Map<String, dynamic>> getTrackingSteps(String deliveryStatus) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return [
      {
        'title': 'Order Placed',
        'date': formatter.format(now.subtract(const Duration(days: 2))),
        'isCompleted': true,
      },
      {
        'title': 'Shipped',
        'date': formatter.format(now.subtract(const Duration(days: 1))),
        'isCompleted': deliveryStatus != 'Ordered',
      },
      {
        'title': 'Out for Delivery',
        'date': formatter.format(now),
        'isCompleted':
            deliveryStatus == 'Out for Delivery' ||
            deliveryStatus == 'Delivered',
      },
      {
        'title': 'Delivered',
        'date': formatter.format(now.add(const Duration(hours: 3))),
        'isCompleted': deliveryStatus == 'Delivered',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final order = provider.orders.firstWhere(
          (item) => item.id == widget.order.id,
          orElse: () => widget.order,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          appBar: AppBar(
            title: const Text(
              'Tracking Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Helvetica',
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD8BFD8), Color(0xFFC6A1CF)],
                ),
              ),
            ),
            elevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFE5E7EB),
                            image: DecorationImage(
                              image: NetworkImage(order.image ?? ''),
                              fit: BoxFit.cover,
                              onError: (error, stackTrace) =>
                                  const AssetImage('assets/placeholder.png'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.name.isNotEmpty
                                    ? order.name
                                    : 'Unknown Item',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                              Text(
                                order.price != null
                                    ? 'LKR ${order.price!.toStringAsFixed(2)}'
                                    : 'N/A',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4B5563),
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                              Text(
                                'Size: ${order.size.isNotEmpty ? order.size : 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4B5563),
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                              Text(
                                'Color: ${order.color.isNotEmpty ? order.color : 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4B5563),
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                              Text(
                                'Quantity: ${order.quantity ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4B5563),
                                  fontFamily: 'Helvetica',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tracking Progress
                  const Text(
                    'Tracking Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontFamily: 'Helvetica',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _loadTrackingData,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : trackingSteps == null || trackingSteps!.isEmpty
                        ? const Center(
                            child: Text(
                              'No tracking data available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4B5563),
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: trackingSteps!.length,
                            itemBuilder: (context, index) {
                              final step = trackingSteps![index];
                              return _buildTrackingStep(
                                title: step['title'] as String? ?? 'Unknown',
                                date: step['date'] as String? ?? 'N/A',
                                isCompleted:
                                    step['isCompleted'] as bool? ?? false,
                                isLast: index == trackingSteps!.length - 1,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
