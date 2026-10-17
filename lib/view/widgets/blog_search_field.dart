import 'package:flutter/material.dart';

import 'package:stream_test/view_model/blog_view_model.dart';

class BlogSearchField extends StatelessWidget {
  final BlogViewModel blogViewModel;
  const BlogSearchField({super.key, required this.blogViewModel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextFormField(
        onChanged: (value) {
          blogViewModel.searchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
