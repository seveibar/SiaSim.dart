library gateway;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Gateway {
  List<String> peers;

  shelf.Response Status(shelf.Request req);
  shelf.Response Synchronize(shelf.Request req);
  shelf.Response AddPeer(shelf.Request req);
  shelf.Response RemovePeer(shelf.Request req);
}

class RegularGateway extends Gateway {
  RegularGateway() {
    peers = new List<String>();
  }
  shelf.Response Status(shelf.Request req) {
    return new JSONResponse(
        {"Peers": ["12.34.56.78:8499", "21.43.56.87:8499"]});
  }
  shelf.Response Synchronize(shelf.Request req) {
    return new SuccessResponse();
  }
  shelf.Response AddPeer(shelf.Request req) {
    var peer = req.url.queryParameters["address"];
    peers.add(peer);
    return new SuccessResponse();
  }
  shelf.Response RemovePeer(shelf.Request req) {
    var peer = req.url.queryParameters["address"];
    peers.remove(peer);
    return new SuccessResponse();
  }
}
