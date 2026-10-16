# Stream Test

Learning **Dart Streams** in two ways:

1. **A Flutter app** that uses `StreamController` + `StreamBuilder` (no state management package).
2. **A pure Dart playground** with every stream operator in one runnable file.

<!-- Add a screenshot or GIF of the app here -->
<!-- ![demo](screenshots/demo.gif) -->

---

## ⭐ Streams Playground

> **📄 [`example/streams_playground.dart`](example/streams_playground.dart)**
>
> One Dart file, no Flutter, no `StreamController`. Every stream is made with `async*`, and every operator has its own small function, so you can run it and **see** what each one does.

### Run it

```bash
dart run example/streams_playground.dart
```

Want to try one thing at a time? Comment out the other lines in `main()`.
Want it faster or slower? Change `delay` at the top of the file.

### The source streams

```dart
getNumbers()          // 1 2 3 4 5
getNumbersDouble()    // 1 1 2 2 3 3 4 4 5 5
getNumbersWithError() // 1 2 ❌error 3
```

### What's inside

| Function | Operator | Output |
|---|---|---|
| `mapStream` | `map`: change every value | `2 4 6 8 10` |
| `filterStream` | `where`: keep what passes a test | `2 4` |
| `distinctStream` | `distinct`: drop repeats that come back to back | `1 2 3 4 5` |
| `expandStream` | `expand`: one value becomes many | `1 10 2 20 …` |
| `asyncMapStream` | `asyncMap`: like `map` but async | `user 1 … user 5` |
| `takeStream` | `take(3)`: first 3, then stop | `1 2 3` |
| `skipStream` | `skip(2)`: skip the first 2 | `3 4 5` |
| `takeWhileStream` | `takeWhile`: stop at the first `false` | `1 2 3` |
| `collectStream` | `toList` / `first` / `last` / `reduce` / `fold` / `any` | `[1..5]` `1` `5` `15` `115` `true` |
| `errorStream` | `handleError`: catch the error, keep going | `1 2 Caught 3` |
| `awaitForStream` | `await for` + `break` (stops the stream) | `1 2 3` |
| `listenStream` | `listen` + `pause` / `resume` | pauses after `2`, waits, then `3 4 5` |
| `chainStream` | `distinct` → `where` → `map` together | `20 40` |

### `forEach` vs `listen`

The playground uses `forEach` in most places and `listen` in one. Here's why:

| | `forEach` / `await for` | `listen` |
|---|---|---|
| Returns | `Future`, so you can `await` it | `StreamSubscription` |
| Waits until the stream ends | ✅ | ❌ (unless you use a `Completer`) |
| `pause` / `resume` / `cancel` | ❌ | ✅ |
| Use it when | you want to read the stream to the end | you need control over the subscription |

`await something.listen(...)` does **not** wait for anything. That was my first mistake.

---

## 📱 The Flutter App

A list of blog items. Every change goes through a stream to the UI, and you can **pause**, **resume** or **cancel** that stream and watch what happens.

### Features

- Add / edit / delete items
- Search with **debounce** (waits 300ms after you stop typing)
- Pause / Resume / Cancel the stream
- Live counter badge in the AppBar

### What I practiced

| Concept | Where |
|---|---|
| `StreamController.broadcast()` so two widgets can listen (list + badge) | `blog_view_model.dart` |
| `StreamBuilder` with `initialData` | `blogs_list.dart`, `blogs_count_badge.dart` |
| `stream.listen()` with `onData` / `onError` / `onDone` | `BlogViewModel` constructor |
| Pause / resume by holding events in the ViewModel | `pauseStream()` / `resumeStream()` |
| Closing a stream safely with `isClosed` | `cancelStream()` |
| Search debounce with `Timer` | `searchQuery()` |
| UI widgets separated from the ViewModel | `lib/view/` and `lib/view_model/` |

### Things I learned the hard way

- A normal `StreamController()` allows **one** listener only. A second `StreamBuilder` throws `Bad state: Stream has already been listened to`, so I switched to `.broadcast()`.
- A broadcast stream does not remember old events. A widget that starts listening late gets nothing until the next event, which is why `initialData` matters.
- After `close()`, any `add()` crashes with `Cannot add new events after calling close`. Always check `isClosed` first.
- When the list is filtered by search, the index on screen is not the index in the real list. Edit / delete find the item by its value instead.

### Run it

```bash
flutter pub get
flutter run
flutter test
```

---

## Project structure

```
example/
└── streams_playground.dart   ⭐ pure Dart, every stream operator

lib/
├── main.dart
├── view_model/
│   └── blog_view_model.dart
└── view/
    ├── home_page.dart
    └── widgets/
        ├── add_blog_sheet.dart
        ├── blog_card.dart
        ├── blog_search_field.dart
        ├── blogs_count_badge.dart
        ├── blogs_list.dart
        ├── edit_blog_dialog.dart
        └── stream_control_buttons.dart

test/
└── widget_test.dart
```
