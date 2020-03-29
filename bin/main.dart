import 'dart:async';

import 'package:image/image.dart';
import 'dart:io';

Future main() async {
  int port = 8085;
  var server  = await HttpServer.bind('localhost', 8085);
  server.listen((HttpRequest request)
  {
    if(request.uri.path =='/getfalsestamped')
    {
      request.response.write(validateImage().toList());
      request.response.close();
    }
  });
}

List<File> validateImage()
{
  // ignore: prefer_collection_literals
  final List<File> stampedImages= List();
  final List<String> images= ['assets/2.jpg','assets/6.jpg','assets/11.png','assets/33.png','assets/34.png','assets/35.png','assets/36.png','assets/37.png'];
  for(int i=0;i<images.length;i++)
  {
    final File file  = File(images[i]);
    final String fileName=file.name;
    final Image image = decodeImage(File('${images[i]}').readAsBytesSync());
    Image falseLogo = decodeImage(File('assets/false.png').readAsBytesSync());
    falseLogo=copyResize(falseLogo,width: (image.width/3).round());
    final Image thumbnail = drawImage(image,falseLogo,blend: true,dstX:(image.width/3).round(),dstY:(image.height/3.15).round() );
    // ignore: avoid_single_cascade_in_expression_statements
    File stampedImage=File('stamped_${fileName.substring(0, fileName.indexOf('.'))}.png')..writeAsBytesSync(encodePng(thumbnail));
    stampedImages.add(stampedImage);
  }
  return stampedImages;
}

extension FileExtention on FileSystemEntity{
String get name {
  return this?.path?.split("/")?.last;
}
}