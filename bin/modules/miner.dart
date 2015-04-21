library miner;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Miner{
  int threads;
  bool running;
  
  // Tells the miner to begin mining on "threads" threads.
  shelf.Response Start(shelf.Request req);
  
  // Returns the status of the miner
  shelf.Response Stop(shelf.Request req);
  
  // Stops the miner
  shelf.Response Status(shelf.Request req);
}

class RegularMiner extends Miner{
  var wallet;
  RegularMiner(thewallet){
    wallet = thewallet;
    running = false;
    threads = 0;
  }
  shelf.Response Start(shelf.Request req){
    print("STarting");
    var qthreads = int.parse(req.url.queryParameters["threads"]);
    running = threads > 0;
    threads = qthreads;
    return new SuccessResponse();
  }
  shelf.Response Stop(shelf.Request req){
    running = false;
    threads = 0;
    return new SuccessResponse();
  }
  shelf.Response Status(shelf.Request req){
    if (threads > 0){
      wallet.Moneys += 1000000000000000000000000;
    }
    return new JSONResponse({
        "Mining": running,
        "State": "", // TODO what are possible states?
        "Threads": threads,
        "RunningThreads": threads,
        "Address": "123456789123456789123456789123456789123456789123456789123456789123456789a"
    });
  }
}