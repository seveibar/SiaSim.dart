library miner;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import '../appstate.dart';
import 'response.dart';
import 'dart:async';
import 'dart:math';

abstract class Miner{
  int threads;
  bool running;
  Duration duration;
  AppState appState;

  // Constructor that gives relationship to appState
  Miner(this.appState);

  // Tells the miner to begin mining on "threads" threads.
  shelf.Response Start(shelf.Request req);

  // Tells the miner to stop mining
  shelf.Response Stop(shelf.Request req);

  // Returns the status of the miner
  shelf.Response Status(shelf.Request req);
}

class RegularMiner extends Miner{
  RegularMiner(appState):super(appState){
    running = false;
    threads = 0;
    duration = new Duration(milliseconds:500);
    new Timer.periodic(duration, incrementBalance);
  }
  incrementBalance(timer) {
    appState.balance += pow(10, 22) * threads;
    appState.fullBalance += pow(10, 22) * threads;
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
