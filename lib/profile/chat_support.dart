import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatSupportScreen extends StatelessWidget {
  const ChatSupportScreen({super.key});

  Future<void> _openUrl(
    String url,
    String fallbackUrl,
    BuildContext context,
  ) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (fallbackUrl.isNotEmpty) {
        final fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to open the app or website.'),
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to open $url')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final supportOptions = [
      {
        'id': 'whatsapp',
        'icon': Icons.chat_bubble_outline,
        'label': 'WhatsApp',
        'description': 'Chat with us on WhatsApp for quick support.',
        'url': 'whatsapp://send?phone=+94112345678',
        'fallbackUrl': '',
      },
      {
        'id': 'instagram',
        'icon': Icons.camera_alt_outlined,
        'label': 'Instagram',
        'description': 'Message us on Instagram for assistance.',
        'url':
            'https://www.instagram.com/ever_efficient_?igsh=MjMxb3d0M2liOGlu',
        'fallbackUrl': '',
      },
      {
        'id': 'messenger',
        'icon': Icons.message_outlined,
        'label': 'Messenger',
        'description': 'Reach out via Facebook Messenger.',
        'url': 'https://m.me/everefficient.official',
        'fallbackUrl': 'https://www.facebook.com/everefficient.official',
      },
    ];

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
              'Chat Support',
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: Container(
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
              children: [
                const Text(
                  'Connect with Us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose your preferred platform to get in touch with our support team.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 20),
                ...supportOptions.map((option) {
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _openUrl(
                          option['url'] as String,
                          option['fallbackUrl'] as String,
                          context,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(
                                  option['icon'] as IconData,
                                  size: 30,
                                  color: const Color(0xFF4B5563),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option['label'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option['description'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 24,
                                color: Color(0xFF9CA3AF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (option != supportOptions.last)
                        const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
