import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

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

}