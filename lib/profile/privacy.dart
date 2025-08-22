import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isLoading = false;

  Future<void> _openEmail() async {
    const email = 'info@everefficient.lk';
    final url = Uri.parse('mailto:$email');
    setState(() {
      _isLoading = true;
    });
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to open email client. Please try again.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open email client: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamed(context, '/profile');
                }
              },
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            children: [
              _buildCard(
                children: [
                  const Text(
                    'Your Privacy Matters to Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'At Ever Efficient Technologies, we are committed to protecting your '
                    'personal information. This Privacy Policy explains how we collect, '
                    'use, store, and safeguard your data when you interact with our '
                    'mobile app or website.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '1. Information We Collect',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.person_outline,
                    text:
                        'Personal Information: Name, email address, contact details, billing info.',
                    boldPart: 'Personal Information: ',
                  ),
                  _buildRow(
                    icon: Icons.phone_iphone,
                    text:
                        'Device & Usage Data: IP address, device type, OS, and app usage patterns.',
                    boldPart: 'Device & Usage Data: ',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '2. How We Use Your Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.shopping_cart_outlined,
                    text: 'Process orders and customer support.',
                  ),
                  _buildRow(
                    icon: Icons.star_outline,
                    text: 'Personalized experiences and content.',
                  ),
                  _buildRow(
                    icon: Icons.analytics_outlined,
                    text: 'Improve services and performance.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '3. Sharing of Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We never sell your data. We may share it only with trusted third '
                    'parties (e.g., payment or analytics services).',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '4. Data Security',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We use industry-standard security like encryption and secure servers.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '5. Cookies & Tracking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We use cookies to enhance your experience and analyze performance.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '6. Your Rights',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• View or request changes to your data.\n'
                    '• Request deletion of your data.\n'
                    '• Opt-out of marketing at any time.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '7. Policy Updates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Changes to this policy will be posted here and notified via email or app.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '8. FAQs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'How is data stored?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'All data is securely encrypted on certified servers.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Can I stop data collection?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Yes, you can opt out via your settings or email us for assistance.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '9. Contact Us',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.mail_outline,
                    text: 'info@everefficient.lk',
                    isButton: true,
                    onPressed: _isLoading ? null : _openEmail,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 10),
                  _buildRow(
                    icon: Icons.phone_outlined,
                    text: '+94 112 345 678',
                  ),
                  const SizedBox(height: 10),
                  _buildRow(
                    icon: Icons.location_on_outlined,
                    text: 'Kandy, Sri Lanka',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String text,
    String? boldPart,
    bool isButton = false,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: isButton
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLoading
                    ? const Color(0xFF8E44AD).withOpacity(0.6)
                    : const Color(0xFF8E44AD),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
              ),
              onPressed: onPressed,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(icon, size: 20, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.47,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: const Color(0xFF4B5563)),
                const SizedBox(width: 10),
                Expanded(
                  child: boldPart != null
                      ? RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF374151),
                              height: 1.47,
                            ),
                            children: [
                              TextSpan(
                                text: boldPart,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: text.substring(boldPart.length)),
                            ],
                          ),
                        )
                      : Text(
                          text,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF374151),
                            height: 1.47,
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
