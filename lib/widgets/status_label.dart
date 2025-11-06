import 'package:flutter/material.dart';

class StatusLabel extends StatelessWidget {
  final String status;
  final bool isOutOfStock;

  const StatusLabel({
    super.key,
    required this.status,
    this.isOutOfStock = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayStatus = isOutOfStock ? 'out_of_stock' : status;
    final statusConfig = _getStatusConfig(displayStatus);

    if (statusConfig.text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusConfig.color,
        borderRadius: BorderRadius.circular(4),
      ),

      child: Text(
        statusConfig.text,
        style: TextStyle(
          color: statusConfig.textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Helvetica',
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'new':
        return _StatusConfig('NEW', Colors.green, Colors.white);

      case 'hot':
        return _StatusConfig('HOT', Colors.red, Colors.white);

      case 'out_of-stock':
        return _StatusConfig('OUT OF STOCK', Colors.grey, Colors.white);

      default:
        return _StatusConfig('', Colors.transparent, Colors.transparent);
    }
  }
}

class _StatusConfig {
  final String text;
  final Color color;
  final Color textColor;

  _StatusConfig(this.text, this.color, this.textColor);
}
