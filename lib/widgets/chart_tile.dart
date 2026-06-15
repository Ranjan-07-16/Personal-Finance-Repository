import 'package:flutter/material.dart';

class ChartTile extends StatelessWidget {
  final String title;
  final Widget chart;

  const ChartTile({super.key, required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }
}
