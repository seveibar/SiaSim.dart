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
  
  bool fileUploadAttempt = false;
  int timeSince = 0;
  String fileUploadName = "";
  
  shelf.Response Download(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    var source = req.url.queryParameters["source"];
    print('$source, $nickname');
    return new SuccessResponse();
    var tempFile = new File.fromUri(new Uri.file('../tmp/test.txt'));
    Future<File> copyFuture = tempFile.copy(source);
    copyFuture.catchError((fail){
      return new FailResponse();
    });
    
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
    if (fileUploadAttempt){
        return new JSONResponse([{
          "Complete": timeSince * 200 >= 24000,
          "Available": timeSince * 200 >= 24000,
          "Filesize": 24000,
          "Received": timeSince * 200,
          "Destination": "/home/seve",
          "Nickname": fileUploadName
        }]);
      }else{
        return new JSONResponse([]);
      }
  }
  shelf.Response Files(shelf.Request req){
    timeSince ++;
    if (fileUploadAttempt){
      return new JSONResponse([{
        "Complete": timeSince * 20 >= 24000,
        "Available": timeSince * 20 >= 24000,
        "Filesize": 24000,
        "Received": timeSince * 20,
        "Destination": "/home/seve",
        "Nickname": fileUploadName
      }]);
    }else{
      return new JSONResponse([]);
    }
  }
  shelf.Response Upload(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    var source = req.url.queryParameters["source"];
    fileUploadName = nickname;
    fileUploadAttempt = true;
    return new SuccessResponse();
    print('$source, $nickname');
    var sourceFile = new File.fromUri(new Uri.file(source));
    print('$sourceFile');
    Future<File> copyFuture = sourceFile.copy('../tmp/test.txt');
    copyFuture.catchError((fail){
      return new FailResponse();
    });

    return new SuccessResponse();
  }
  

}