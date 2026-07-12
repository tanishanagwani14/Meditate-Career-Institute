import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.searchPlaceholder,
    this.searchController,
    this.onSearchChanged,
    this.onFiltersPressed,
  });

  final String searchPlaceholder;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFiltersPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: searchPlaceholder,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: onFiltersPressed ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filters coming soon on this page')),
                    );
                  },
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Filters'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40)),
            ),
          ],
        ),
      ),
    );
  }
}
