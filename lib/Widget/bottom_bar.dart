import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: const SizedBox(
        height: 80,
        child: TabBar(
          padding: EdgeInsets.only(bottom: 20),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            ButtonTextWidget(text: 'Home', icon: Icons.home),
            ButtonTextWidget(text: 'Account', icon: Icons.account_box),
          ],
        ),
      ),
    );
  }
}

class ButtonTextWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const ButtonTextWidget({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Icon(icon, size: 15),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }
}
