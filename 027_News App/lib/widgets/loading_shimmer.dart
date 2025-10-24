import 'package:flutter/material.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 120,
                    height: 24,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}