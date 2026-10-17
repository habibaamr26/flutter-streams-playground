import 'package:flutter/material.dart';
import 'package:stream_test/view/widgets/edit_blog_dialog.dart';
import 'package:stream_test/view_model/blog_view_model.dart';

class BlogCard extends StatelessWidget {
  final int index;
  final String blog;
  final BlogViewModel blogViewModel;

  const BlogCard({
    super.key,
    required this.index,
    required this.blog,
    required this.blogViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          blog,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => EditBlogDialog(
                  initialText: blog,
                  onSave: (newBlog) => blogViewModel.updateBlog(blog, newBlog),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => blogViewModel.removeBlog(blog),
            ),
          ],
        ),
      ),
    );
  }
}
