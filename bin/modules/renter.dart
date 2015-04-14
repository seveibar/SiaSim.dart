library renter;

import 'dart:io';
import 'dart:async';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Renter{
  
  // Starts a file download
  shelf.Response Download(shelf.Request req);
  
  // Lists all files in the download queue
  shelf.Response DownloadQueue(shelf.Request req);
  
  // Lists the status of all files
  shelf.Response Files(shelf.Request req);
  
  // Upload a file
  shelf.Response Upload(shelf.Request req);
}

class RegularRenter implements Renter{
  shelf.Response Download(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    var destination = req.url.queryParameters["destination"];
    return new SuccessResponse();
  }
  shelf.Response DownloadQueue(shelf.Request req){
    /*
    This function returns JSON with the form...
    [{
        Complete    bool
        Filesize    uint64
        Received    uint64
        Destination string
        Nickname    string
    },...]
    */ 
    return new JSONResponse([]);
  }
  shelf.Response Files(shelf.Request req){
    return new JSONResponse([]);
  }
  shelf.Response Upload(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    var source = req.url.queryParameters["source"];
    print('$source, $nickname');
    var sourceFile = new File.fromUri(new Uri.file(source));
    Future<File> copyFuture = sourceFile.copy('../tmp/test.txt');
    copyFuture.catchError((fail){
      return new FailResponse();
    });

    return new SuccessResponse();
  }
  
}