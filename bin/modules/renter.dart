library renter;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Renter{
  shelf.Response Download(shelf.Request req);
  shelf.Response DownloadQueue(shelf.Request req);
  shelf.Response Files(shelf.Request req);
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
    return new SuccessResponse();
  }
}