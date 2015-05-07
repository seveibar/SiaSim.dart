library renter;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:path/path.dart' as path;

import '../appstate.dart';
import 'response.dart';

class UploadedFile{
  
  int filesize;
  int remaining = 99999999;
  String nickname;
  bool available = true;
  bool repairing = false;
  
  UploadedFile(String nickname, int filesize){
    this.nickname = nickname;
    this.filesize = filesize;
  }
}

class DownloadingFile extends UploadedFile{
  
  bool complete = false;
  String destination;
  int received = 0; // out of total size
  
  DownloadingFile(String nickname, int filesize, this.destination):
    super(nickname, filesize);
  
  DownloadingFile.fromUploadedFile(UploadedFile file, this.destination):
    super(file.nickname, file.filesize);
}

abstract class Renter{
  
  List uploadedFiles = new List<UploadedFile>();
  List downloadQueue = new List<DownloadingFile>();
  AppState appState; 
  
  Renter(this.appState);
  
  // Starts a file download
  shelf.Response Download(shelf.Request req);
  
  // Lists all files in the download queue
  shelf.Response DownloadQueue(shelf.Request req);
  
  // Lists the status of all files
  shelf.Response FilesList(shelf.Request req);
  
  // Upload a file
  shelf.Response Upload(shelf.Request req);
  
  //Deletes a renter file entry
  shelf.Response Delete(shelf.Request req);
  
  // Called to update the DownloadQueue
  void updateDownloadQueue(timer);
}

class RegularRenter extends Renter{
  RegularRenter(appState):super(appState){
    
  }
  
  updateDownloadQueue(timer){  
    List newQueue = new List<DownloadingFile>();
    for (var file in downloadQueue){
      if(file.received < file.filesize) {
        file.received += 10000;
        if (file.received > file.filesize){
          file.received = file.filesize;
        }
        newQueue.add(file); 
      }
      else if(file.received >= file.filesize) {
        file.complete = true; 
      }
    }
    downloadQueue = newQueue;
  }
  
  shelf.Response Download(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    var destination = req.url.queryParameters["destination"];
    
    var destinationDir = new Directory(path.dirname(destination));
    destinationDir.createSync();
    
    var pathString = 'tmp/' + nickname;
    var sourceFile = new File(pathString);
    
    try {
      var copiedFile = sourceFile.copySync(destination);

      for(var file in uploadedFiles) {
        if(file.nickname == nickname) {
          downloadQueue.add(new DownloadingFile.fromUploadedFile(file, destination));
          break;
        }
      }
      
      Duration duration = new Duration(milliseconds:500);
      new Timer.periodic(duration, updateDownloadQueue);
      
    } catch(exception){
      print(exception);
      return new FailResponse();
    }
    
    return new SuccessResponse();
  }
  
  shelf.Response DownloadQueue(shelf.Request req){
    
    List<Map> JSONmap = [];
    for(DownloadingFile file in downloadQueue) {
      JSONmap.add({
        "Complete": file.complete,
        "Filesize": file.filesize,
        "Received": file.received,
        "Destination": file.destination,
        "Nickname": file.nickname
      });
    }
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

    return new JSONResponse(JSONmap);
  }
  shelf.Response FilesList(shelf.Request req){

    var tmpDir = new Directory('tmp');
    tmpDir.createSync();
    
    List<Map> JSONmap = []; 
    
    for(var file in uploadedFiles){
        JSONmap.add({
          "Available": file.available,
          "Nickname": file.nickname,
          "Repairing": file.repairing,
          "TimeRemaining": file.remaining
        });
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
      int filesize = copiedFile.lengthSync();
      uploadedFiles.add(new UploadedFile(nickname, filesize));
    } catch(exception){
      print(exception);
      return new FailResponse();
    }
    
    return new SuccessResponse();
  }
  
  shelf.Response Delete(shelf.Request req){
    var nickname = req.url.queryParameters["nickname"];
    List newUploadList = new List<UploadedFile>();
    for(var file in uploadedFiles){
      if (file.nickname != nickname){
        newUploadList.add(file);
      }
    }
    uploadedFiles = newUploadList;
    
    return new SuccessResponse();
  }

}