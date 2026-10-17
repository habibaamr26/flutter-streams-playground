import 'package:flutter/material.dart';
import 'package:stream_test/view/widgets/blog_card.dart';
import 'package:stream_test/view_model/blog_view_model.dart';

class BlogsList extends StatelessWidget {
  final BlogViewModel blogViewModel;

  const BlogsList({super.key, required this.blogViewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: blogViewModel.blogsStream,
      initialData: blogViewModel.blogs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error occurred while fetching data'),
          );
        }

        final blogs = snapshot.data ?? [];
        if (blogs.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          itemCount: blogs.length,
          itemBuilder: (context, index) {
            return BlogCard(
              index: index,
              blog: blogs[index],
              blogViewModel: blogViewModel,
            );
          },
        );
      },
    );
  }
}
