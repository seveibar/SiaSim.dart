library consensus;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Consensus{
  shelf.Response Status(shelf.Request req);
}

class RegularConsensus implements Consensus{
  shelf.Response Status(shelf.Request req){
    return new JSONResponse({
      "Height": 0,
      "CurrentBlock": 0,
      "Target": 0
    });
  }
}