import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
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
            const SnackBar(content: Text('Unable to open email client.')),
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
              'Terms of Use',
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
                    'Welcome to Ever Efficient Technologies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'By accessing or using our mobile app or website, you agree to be '
                    'bound by these Terms of Use. Please review them carefully to '
                    'understand your rights and responsibilities.',
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
                    '1. Acceptance of Terms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.check_circle_outline,
                    text:
                        'You confirm you’ve read and agree to these Terms and all applicable laws.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '2. Modifications to Terms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.description_outlined,
                    text:
                        'We may update these terms at any time. Continued use means acceptance of changes.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '3. User Responsibilities',
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
                        '• Use services legally.\n'
                        '• Keep your credentials safe.\n'
                        '• Don’t engage in harmful or unauthorized activity.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '4. Intellectual Property',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.lock_outline,
                    text:
                        'All designs, logos, and content are owned by Ever Efficient Technologies. '
                        'Do not copy or redistribute without permission.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '5. Privacy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.shield_outlined,
                    text:
                        'Your use of our services is governed by our Privacy Policy. '
                        'Please review it for details.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '6. Limitation of Liability',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.warning_outlined,
                    text:
                        'We’re not responsible for indirect or consequential damages like '
                        'data loss or business disruption.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '7. Termination',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    icon: Icons.cancel_outlined,
                    text:
                        'We may suspend or terminate your account if you breach these terms '
                        'or harm our platform.',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    '8. Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Can I share my account?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'No. Sharing accounts is prohibited and may result in suspension.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.47,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'What happens if I violate the terms?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your account may be restricted, suspended, or permanently removed.',
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading
                          ? const Color(0xFF8E44AD).withOpacity(0.6)
                          : const Color(0xFF8E44AD),
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _openEmail,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.mail_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'info@everefficient.lk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  _buildRow(
                    icon: Icons.phone_outlined,
                    text: '+94 112 345 678',
                  ),
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

  Widget _buildRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4B5563)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
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
