library miner;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import "response.dart";

abstract class Miner{
  int threads;
  bool running;
  
  shelf.Response Start(shelf.Request req);
  shelf.Response Stop(shelf.Request req);
  shelf.Response Status(shelf.Request req);
}

class RegularMiner extends Miner{
  RegularMiner(){
    running = false;
    threads = 0;
  }
  shelf.Response Start(shelf.Request req){
    var qthreads = int.parse(req.url.queryParameters["threads"]);
    running = true;
    threads = qthreads;
    return new SuccessResponse();
  }
  shelf.Response Stop(shelf.Request req){
    running = false;
    threads = 0;
    return new SuccessResponse();
  }
  shelf.Response Status(shelf.Request req){
    return new JSONResponse({
        "Mining": running,
        "State": "", // TODO what are possible states?
        "Threads": threads,
        "RunningThreads": threads,
        "Address": "123456789123456789123456789123456789123456789123456789123456789123456789a"
    });
  }
}