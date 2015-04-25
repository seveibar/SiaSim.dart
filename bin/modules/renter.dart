library renter;

import 'dart:io';
import 'dart:async';
import "dart:convert";
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:path/path.dart' as path;

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
    var destination = req.url.queryParameters["source"];
    
    var destinationDir = new Directory(path.dirname(destination));
    destinationDir.createSync();
    
    var pathString = 'tmp/' + nickname;
    var sourceFile = new File(pathString);
    
    try {
      var copiedFile = sourceFile.copySync(destination);
    } catch(exception){
      print(exception);
      return new FailResponse();
    }
    
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
    List<Map> JSONmap = []; 
    
    for(var fileOrDir in contents){
      if (fileOrDir is File) {
        JSONmap.add({
          "Available": true,
          "Nickname": path.basename(fileOrDir.path),
          "Repairing": false,
          "TimeRemaining": 9999999999
        });
      } else if (fileOrDir is Directory) {
        continue;
      }        
    }
    
    return new JSONResponse(JSONmap);
  }
  shelf.Response Upload(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    var source = req.url.queryParameters["source"];
    var sourceFile = new File(source);
    
    var tmpDir = new Directory('tmp');
    tmpDir.createSync();
    
    var pathString = 'tmp/' + nickname;
    try {
      var copiedFile = sourceFile.copySync(pathString);
    } catch(exception){
      print(exception);
      return new FailResponse();
    }
  
    return new SuccessResponse();
  }
  

}