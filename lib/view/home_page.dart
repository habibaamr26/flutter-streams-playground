import 'package:flutter/material.dart';
import 'package:stream_test/view/widgets/add_blog_sheet.dart';
import 'package:stream_test/view/widgets/blog_search_field.dart';
import 'package:stream_test/view/widgets/blogs_count_badge.dart';
import 'package:stream_test/view/widgets/blogs_list.dart';
import 'package:stream_test/view/widgets/stream_control_buttons.dart';
import 'package:stream_test/view_model/blog_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BlogViewModel _blogViewModel;
  @override
  initState() {
    _blogViewModel = BlogViewModel();
    super.initState();
  }

  @override
  void dispose() {
    _blogViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          BlogsCountBadge(blogViewModel: _blogViewModel),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          BlogSearchField(blogViewModel: _blogViewModel),
          StreamControlButtons(blogViewModel: _blogViewModel),
          Expanded(child: BlogsList(blogViewModel: _blogViewModel)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            AddBlogSheet.show(context, onAdd: _blogViewModel.addBlog),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}
