library gateway;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Gateway {
  List<String> peers;
  
  // Returns information about the gateway, including the
  // list of peers.
  shelf.Response Status(shelf.Request req);
  
  // Will force synchronization of the local node and the
  // rest of the network. May take a while. Should only
  // be necessary for debugging.
  shelf.Response Synchronize(shelf.Request req);
  
  // Will add a peer to the gateway.
  shelf.Response AddPeer(shelf.Request req);
  
  // Will remove a peer from the gateway.
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
