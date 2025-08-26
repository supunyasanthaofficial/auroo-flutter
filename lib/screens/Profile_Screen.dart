import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../context/Product_Provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String? _profileImage;
  final String _defaultProfileImage =
      'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  bool _isImageViewerVisible = false;
  bool _isLoading = false;
  String _userName = 'User';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _userName;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<ProductProvider>();
        setState(() {
          _profileImage = null;
          context.read<ProductProvider>().setProfileImage(null);
          _animationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handlePickImage() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final picker = ImagePicker();
    try {
      final result = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (result != null && mounted) {
        if (await File(result.path).exists()) {
          setState(() {
            _profileImage = result.path;
            context.read<ProductProvider>().setProfileImage(result.path);
          });
          _animationController.forward(from: 0.0);
        } else {
          _showSnackBar('Selected image is invalid');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to pick image: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
              setState(() {
                _profileImage = null;
                context.read<ProductProvider>().setProfileImage(null);
              });
              _animationController.forward(from: 0.0);
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _handleEditName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                setState(() {
                  _userName = _nameController.text;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
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
                onPressed: () {
                  context.read<ProductProvider>().setProfileImage(null);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;
      default:
        _showSnackBar('$label clicked');
    }
  }

  void _showImageViewer() {
    setState(() => _isImageViewerVisible = true);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              maxScale: 4.0,
              minScale: 0.5,
              child: Center(
                child:
                    _profileImage != null && _profileImage!.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: _profileImage!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => const Center(
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
                    : CachedNetworkImage(
                        imageUrl: _defaultProfileImage,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.white),
                          ),
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
                  setState(() => _isImageViewerVisible = false);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  ImageProvider _getProfileImageProvider() {
    if (_profileImage != null) {
      if (_profileImage!.startsWith('http')) {
        return NetworkImage(_profileImage!);
      } else if (_profileImage!.isNotEmpty &&
          File(_profileImage!).existsSync()) {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.05,
                vertical: 24,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Container(
                      width: constraints.maxWidth * 0.9,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _showImageViewer,
                            child: Hero(
                              tag: 'profile_image',
                              child: CircleAvatar(
                                radius: constraints.maxWidth * 0.15,
                                backgroundColor: const Color(0xFFC084FC),
                                child: CircleAvatar(
                                  radius: constraints.maxWidth * 0.145,
                                  backgroundImage: _getProfileImageProvider(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.6,
                                  ),
                                  child: Text(
                                    _userName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xFF6B7280),
                                ),
                                onPressed: _handleEditName,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF7C3AED),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      elevation: _isLoading ? 0 : 2,
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : _handlePickImage,
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  'Change Photo',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF4444),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: _handleRemoveImage,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            'Remove',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: constraints.maxWidth * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                            textColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? textColor;

  const OptionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: label == 'Terms of Use' ? const Radius.circular(20) : Radius.zero,
        bottom: label == 'Logout' ? const Radius.circular(20) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: label != 'Logout'
                ? const BorderSide(color: Color(0xFFE5E7EB), width: 1)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: textColor ?? const Color(0xFF4B5563)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? const Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: textColor ?? const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
