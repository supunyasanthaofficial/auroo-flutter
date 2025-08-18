import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _isLoading = false;

  Future<void> _openWebsite() async {
    const url = 'https://everefficient.lk/';
    setState(() {
      _isLoading = true;
    });
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to open the website. Please try again later.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open the website: $e')),
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
              'About Us',
              style: TextStyle(
                fontSize: 26,
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
                  Image.network(
                    'https://everefficient.lk/assets/img/ee-images/ee-logo-new2.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 160,
                        height: 160,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 160,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ever Efficient Technologies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8E44AD),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We are a Sri Lankan-based software and IT service provider, '
                    'delivering innovative digital solutions tailored to your business needs. '
                    'Our commitment to quality, performance, and integrity drives us to provide '
                    'exceptional web development, mobile app design, digital marketing, and IT consultation services.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'To empower businesses with cutting-edge technology, ensuring '
                    'efficiency, scalability, and a competitive edge in the digital landscape.',
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
                    'What We Offer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildServiceItem(
                    icon: Icons.language,
                    text: 'Web & Mobile App Development',
                  ),
                  _buildServiceItem(
                    icon: Icons.code,
                    text: 'Custom Software Solutions',
                  ),
                  _buildServiceItem(
                    icon: Icons.campaign,
                    text: 'Digital Marketing & SEO',
                  ),
                  _buildServiceItem(
                    icon: Icons.people_outline,
                    text: 'Expert IT Consultation',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                children: [
                  const Text(
                    'Our Team',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Our team of skilled developers, designers, and strategists work '
                    'collaboratively to bring your vision to life. With expertise in '
                    'modern technologies and a passion for innovation, we ensure every '
                    'project exceeds expectations.',
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
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    icon: Icons.email_outlined,
                    text: 'info@everefficient.lk',
                  ),
                  _buildContactItem(
                    icon: Icons.phone_outlined,
                    text: '+94 777 644 590',
                  ),
                  _buildContactItem(
                    icon: Icons.location_on_outlined,
                    text: 'Kandy, Sri Lanka',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading
                      ? const Color(0xFFA78BFA)
                      : const Color(0xFF8E44AD),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _openWebsite,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.language, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Visit Our Website',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildServiceItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4B5563)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4B5563)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }
}
