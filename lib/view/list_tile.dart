import 'package:flutter/cupertino.dart';

class CupertinoListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;

  const CupertinoListTile({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CupertinoColors.separator)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          if (subtitle != null) ...[const SizedBox(height: 4), subtitle!],
        ],
      ),
    );
  }
}
