import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImage =
      'https://cdn.pixabay.com/photo/2019/12/04/09/30/man-4672229_1280.jpg';
  final String _defaultProfileImage =
      'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  bool _isImageViewerVisible = false;
  final String _userName = 'Supun Yasantha';

  Future<void> _handlePickImage() async {
    final picker = ImagePicker();
    try {
      final result = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (result != null && mounted) {
        // Verify file exists for local images
        if (await File(result.path).exists()) {
          setState(() {
            _profileImage = result.path;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Selected image is invalid')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  void _handleRemoveImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Photo'),
        content: const Text(
          'Are you sure you want to remove your profile photo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              if (mounted) {
                setState(() {
                  _profileImage = null;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _handleOptionPress(String label) {
    switch (label) {
      case 'Terms of Use':
        Navigator.pushNamed(context, '/terms');
        break;
      case 'Privacy Policy':
        Navigator.pushNamed(context, '/privacy');
        break;
      case 'Chat Support':
        Navigator.pushNamed(context, '/chat_support');
        break;
      case 'About Us':
        Navigator.pushNamed(context, '/about_us');
        break;
      case 'Logout':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;
      default:
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$label clicked')));
        }
    }
  }

  void _showImageViewer() {
    if (mounted) {
      setState(() {
        _isImageViewerVisible = true;
      });
    }
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(0), // Fullscreen dialog
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Stack(
            children: [
              Center(
                child:
                    _profileImage != null && _profileImage!.startsWith('http')
                    ? Image.network(
                        _profileImage!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Text(
                                'Failed to load image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      )
                    : _profileImage != null && File(_profileImage!).existsSync()
                    ? Image.file(
                        File(_profileImage!),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Text(
                                'Failed to load image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      )
                    : Image.network(
                        _defaultProfileImage,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Text(
                                'Failed to load image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        _isImageViewerVisible = false;
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getProfileImageProvider() {
    if (_profileImage != null) {
      if (_profileImage!.startsWith('http')) {
        return NetworkImage(_profileImage!);
      } else if (File(_profileImage!).existsSync()) {
        return FileImage(File(_profileImage!));
      }
    }
    return NetworkImage(_defaultProfileImage);
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
              'Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Container(
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
                children: [
                  GestureDetector(
                    onTap: _showImageViewer,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFC084FC),
                      child: CircleAvatar(
                        radius: 53,
                        backgroundImage: _getProfileImageProvider(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                        onPressed: _handlePickImage,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Change',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                        onPressed: _handleRemoveImage,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  OptionRow(
                    icon: Icons.description_outlined,
                    label: 'Terms of Use',
                    onTap: () => _handleOptionPress('Terms of Use'),
                  ),
                  OptionRow(
                    icon: Icons.lock_outline,
                    label: 'Privacy Policy',
                    onTap: () => _handleOptionPress('Privacy Policy'),
                  ),
                  OptionRow(
                    icon: Icons.headset_mic_outlined,
                    label: 'Chat Support',
                    onTap: () => _handleOptionPress('Chat Support'),
                  ),
                  OptionRow(
                    icon: Icons.info_outline,
                    label: 'About Us',
                    onTap: () => _handleOptionPress('About Us'),
                  ),
                  OptionRow(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () => _handleOptionPress('Logout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const OptionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF4B5563)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Color(0xFF374151)),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 24, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
