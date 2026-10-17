import 'dart:async';
import 'dart:developer';

class BlogViewModel {

  final StreamController<List<String>> _blogsController =
      StreamController<List<String>>.broadcast();

  late final StreamSubscription<List<String>> _subscription;

  final List<String> _blogs = [];
  bool _isPaused = false;
  String _searchText = '';
  Timer? _debounceTimer;

  BlogViewModel() {
    // listen to the stream from inside the ViewModel (just logs every event)
    _subscription = _blogsController.stream.listen(
      (blogs) => log('Stream data: $blogs'),
      onError: (error) => log('Stream error: $error'),
      onDone: () => log('Stream done'),
    );
  }

  Stream<List<String>> get blogsStream => _blogsController.stream;

  /// Read-only copy, so nobody can change the list from outside.
  List<String> get blogs => List.unmodifiable(_blogs);

  bool get isPaused => _isPaused;
  bool get isClosed => _blogsController.isClosed;

  // ---------- Data ----------

  void searchQuery(String query) {
    log('Searching for: $query');
    // make debounce search to avoid too many updates while typing before filter
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _searchText = query.trim().toLowerCase();
      _emitBlogs();
    });
  }

  void addBlog(String blog) {
    final text = blog.trim();
    if (text.isEmpty) return;

    _blogs.add(text);
    log('Blog added: $text');
    _emitBlogs();
  }

 
  void updateBlog(String oldBlog, String newBlog) {
    final text = newBlog.trim();
    final index = _blogs.indexOf(oldBlog);
    if (text.isEmpty || index == -1) return;

    log('Blog updated: $oldBlog -> $text');
    _blogs[index] = text;
    _emitBlogs();
  }

  void removeBlog(String blog) {
    if (!_blogs.remove(blog)) return;

    log('Blog removed: $blog');
    _emitBlogs();
  }

  // ---------- Stream controls ----------

  /// Stop sending updates to the UI (data still changes in the background).
  void pauseStream() {
    log('Stream paused');
    _isPaused = true;
  }

  /// Start sending again and push everything added while paused.
  void resumeStream() {
    if (isClosed) return;

    log('Stream resumed');
    _isPaused = false;
    _emitBlogs();
  }

  /// Close the stream for good. After this there is no resume.
  void cancelStream() {
    log('Stream cancelled');
    _blogsController.close();
  }

  void dispose() {
    _debounceTimer?.cancel();
    _subscription.cancel();
    _blogsController.close();
  }

  void _emitBlogs() {
    if (_isPaused || isClosed) return;
    final filteredBlogs = _blogs
        .where((blog) => blog.toLowerCase().contains(_searchText))
        .toList();
    _blogsController.add(List.unmodifiable(filteredBlogs));
  }
}
