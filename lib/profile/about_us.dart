import 'package:flutter/material.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});
  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: const Center(child: Text('This is the About Us page')),
    );
  }
}
