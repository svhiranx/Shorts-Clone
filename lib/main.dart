import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:shortsclone/provider.dart';
import 'package:shortsclone/scroll_screen.dart';
import 'package:shortsclone/thumbnail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => VideoProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => PageProvider(),
          )
        ],
        builder: (context, child) => MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                textTheme: GoogleFonts.dmSansTextTheme(),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
                useMaterial3: true,
              ),
              home: const MyHomePage(title: 'Flutter Demo Home Page'),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _controller = PageController();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Provider.of<VideoProvider>(context, listen: false).fetchPaginatedVideos();
    });
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<VideoProvider>(context, listen: false).fetchPaginatedVideos();
      log('max reached');
    }
  }

  @override
  Widget build(BuildContext context) {
    VideoProvider videoProvider = Provider.of<VideoProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Shorts Clone',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            builder: (context, snapshot) => Expanded(
              child: GridView.builder(
                controller: _controller,
                cacheExtent: 15,
                itemCount: videoProvider.isInitialFetch
                    ? 12
                    : videoProvider.videos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        MediaQuery.of(context).size.width * 0.0014),
                itemBuilder: (context, index) {
                  if (videoProvider.isInitialFetch) {
                    return Shimmer.fromColors(
                      baseColor: Color.fromARGB(255, 41, 41, 41),
                      highlightColor: Colors.black54,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else {
                    return Thumbnail(index: index);
                  }
                },
              ),
            ),
          ),
          if (videoProvider.isLoading && !videoProvider.isInitialFetch)
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const LinearProgressIndicator(
                  color: Colors.black,
                ))
        ],
      ),
    );
  }
}
