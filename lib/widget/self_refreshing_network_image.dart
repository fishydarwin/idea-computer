import 'dart:async';

import 'package:flutter/material.dart';

class SelfRefreshingNetworkImage extends StatefulWidget {
  final String url;
  const SelfRefreshingNetworkImage({super.key, required this.url});

  @override
  State<StatefulWidget> createState() => _SelfRefreshingNetworkImageState();
}

class _SelfRefreshingNetworkImageState
    extends State<SelfRefreshingNetworkImage> {

  String? url;
  Timer? timer;
  bool needsRefreshing = false;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    timer = Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) {
          if (needsRefreshing) {
            needsRefreshing = false;
            setState(() {
              url = "${url!}#";
            });
          }
        }
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(url!,
      errorBuilder: (context, exception, stackTrace) {
        needsRefreshing = true;
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 4),
            CircularProgressIndicator.adaptive(),
            Text("Image is being generated...")
          ],
        );
      },
    );
  }
}
