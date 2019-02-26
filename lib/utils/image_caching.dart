import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:async';
import 'dart:io';

class ImageCachingService{

  preDownloadImage(String url) async {
    var provider = CachedNetworkImageProvider(url);
    var imageSub = StreamController<String>();
    final stream = imageSub.stream;
    provider.load(provider).addListener((image, yesNo) {
      if (image == null) {
        imageSub.sink.addError(Error());
      } else {
        imageSub.sink.add(url);
      }
      imageSub.sink.close();
    });
    return stream.single.whenComplete(() {
      imageSub?.close();
    });
  }

  Future<File> getCachedImage(String imageUrl) async {
    final cache = await CacheManager.getInstance();
    final file = await cache.getFile(imageUrl);
    return file;
  }



}