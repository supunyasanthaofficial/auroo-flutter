import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../context/Product_Provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  Map<String, bool> _errors = {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final newErrors = <String, bool>{};
    if (_firstNameController.text.trim().isEmpty) {
      newErrors['firstName'] = true;
    }
    if (_lastNameController.text.trim().isEmpty) {
      newErrors['lastName'] = true;
    }
    if (_countryController.text.trim().isEmpty) {
      newErrors['country'] = true;
    }
    if (_streetController.text.trim().isEmpty) {
      newErrors['street'] = true;
    }
    if (_cityController.text.trim().isEmpty) {
      newErrors['city'] = true;
    }
    if (_stateController.text.trim().isEmpty) {
      newErrors['state'] = true;
    }
    if (_zipController.text.trim().isEmpty) {
      newErrors['zip'] = true;
    }
    if (_phoneController.text.trim().isEmpty) {
      newErrors['phone'] = true;
    }

    setState(() {
      _errors = newErrors;
    });

    return newErrors.isEmpty;
  }

  void _handleSubmit(BuildContext context) {
    if (!_validateForm()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final cartItems = args?['cartItems'] as List<CartItem>? ?? [];
    final userEmail = args?['userEmail'] as String? ?? '';

    final checkoutDetails = {
      'fullName':
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      'phone': _phoneController.text.trim(),
      'address':
          '${_streetController.text.trim()}, ${_cityController.text.trim()}, ${_stateController.text.trim()}, ${_countryController.text.trim()}',
    };

    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'cartItems': cartItems,
        'userEmail': userEmail,
        'checkoutDetails': checkoutDetails,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final cartItems = args?['cartItems'] as List<CartItem>? ?? [];

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
              'Checkout',
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...cartItems.asMap().entries.map((entry) {
                final item = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.name.isNotEmpty ? item.name : 'Unknown Product',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Helvetica',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Price:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4B5563),
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Text(
                                  'Rs ${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF1F2937),
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Size:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4B5563),
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Text(
                                  item.size.isNotEmpty ? item.size : 'N/A',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF1F2937),
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Color:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4B5563),
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: item.color.isNotEmpty
                                        ? Color(
                                            int.parse(
                                              item.color.replaceFirst(
                                                '#',
                                                '0xFF',
                                              ),
                                            ),
                                          )
                                        : const Color(0xFFCCCCCC),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFF999999),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Quantity:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4B5563),
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF1F2937),
                                    fontFamily: 'Helvetica',
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
              const Text(
                'Delivery Information',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  fontFamily: 'Helvetica',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['firstName'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['firstName'] == true ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['firstName'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['firstName'] == true ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['firstName'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF8E44AD),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['lastName'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['lastName'] == true ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['lastName'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['lastName'] == true ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['lastName'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF8E44AD),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(
                  hintText: 'Country',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['country'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['country'] == true ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['country'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['country'] == true ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['country'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF8E44AD),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 16, fontFamily: 'Helvetica'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(
                  hintText: 'Street Address',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['street'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['street'] == true ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['street'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['street'] == true ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['street'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF8E44AD),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 16, fontFamily: 'Helvetica'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'City',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['city'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['city'] == true ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['city'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['city'] == true ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['city'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF8E44AD),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        hintText: 'State / Province',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['state'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['state'] == true ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['state'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFD1D5DB),
                            width: _errors['state'] == true ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _errors['state'] == true
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF8E44AD),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Zip / Postal Code',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['zip'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['zip'] == true ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['zip'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['zip'] == true ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['zip'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF8E44AD),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 16, fontFamily: 'Helvetica'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['phone'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['phone'] == true ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['phone'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFD1D5DB),
                      width: _errors['phone'] == true ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errors['phone'] == true
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF8E44AD),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 16, fontFamily: 'Helvetica'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 0),
                  shadowColor: const Color(0xFF000000),
                  elevation: 3,
                ),
                onPressed: () => _handleSubmit(context),
                child: const Text(
                  'Continue to Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
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
