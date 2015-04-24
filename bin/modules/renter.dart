library renter;

import 'dart:io';
import 'dart:async';
import "dart:convert";
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
    var source = req.url.queryParameters["source"];
    print('$source, $nickname');
    

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

    var tmpDir = new Directory('tmp');
    tmpDir.createSync();
    
    List contents = tmpDir.listSync();
    List<String> nicknames; 
    for(var fileOrDir in contents) {
      if (fileOrDir is File) {
        nicknames.add(fileOrDir.toString());
      } else if (fileOrDir is Directory) {
        continue;
      }
        
    }
    return new JSONResponse(nicknames);
  }
  shelf.Response Upload(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    var source = req.url.queryParameters["source"];
    print('$source, $nickname');
    var sourceFile = new File.fromUri(new Uri.file(source));
    print('$sourceFile');
    
    var tmpDir = new Directory('tmp');
    tmpDir.createSync();
    
    var pathString = '../tmp/' + nickname;
    try {
      var copiedFile = sourceFile.copySync(pathString);
    } catch(exception){
      print(exception);
      return new FailResponse();
    }
  
    return new SuccessResponse();
  }
  

}