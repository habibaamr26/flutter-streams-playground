import 'package:flutter/material.dart';
import 'package:stream_test/view_model/blog_view_model.dart';

/// AppBar icon that shows how many blogs the UI has received.
class BlogsCountBadge extends StatelessWidget {
  final BlogViewModel blogViewModel;

  const BlogsCountBadge({super.key, required this.blogViewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: blogViewModel.blogsStream,
      initialData: blogViewModel.blogs,
      builder: (context, snapshot) {
        final blogsCount = snapshot.data?.length ?? 0;

        return IconButton(
          onPressed: () {},
          icon: Badge(
            label: Text('$blogsCount'),
            child: const Icon(Icons.receipt_long),
          ),
        );
      },
    );
  }
}
