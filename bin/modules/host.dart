library host;

import 'package:shelf/shelf.dart' as shelf;

import 'response.dart';

abstract class Host {
  int totalStorage;
  int minFileSize;
  int maxFileSize;
  int minDuration;
  int maxDuration;
  int windowSize;
  int price;
  int collateral;
  
  int numContracts;
  int storageRemaining;

  // The host will announce itself to the network as
  // a source of storage. Generally only needs to be
  // called once.
  shelf.Response Announce(shelf.Request req);
  
  // Sets the configuration of the host.
  shelf.Response Config(shelf.Request req);
  
  // Queries the host for its configuration values,
  // as well as the amount of storage remaining and
  // the number of contracts formed.
  shelf.Response Status(shelf.Request req);
}

class RegularHost extends Host {
  
  RegularHost(){
    totalStorage = 2 * 10^9;
    maxFileSize = 300 * 10^6;
    minFileSize = 0;
    maxDuration = 5 * 10^3;
    minDuration = 0;
    windowSize = 288;
    price = 1 * 10^9;
    collateral = 0;
    storageRemaining = totalStorage;
    numContracts = 0;
    
  }
  
  shelf.Response Announce(shelf.Request req) {
    return new SuccessResponse();
  }
  shelf.Response Config(shelf.Request req) {
    var getParams = req.url.queryParameters;
    totalStorage = int.parse(getParams["totalStorage"]);
    minFileSize = int.parse(getParams["minFilesize"]);
    maxFileSize = int.parse(getParams["maxFilesize"]);
    minDuration = int.parse(getParams["minDuration"]);
    maxDuration = int.parse(getParams["maxDuration"]);
    windowSize = int.parse(getParams["windowSize"]);
    price = int.parse(getParams["price"]);
    collateral = int.parse(getParams["collateral"]);
    return new SuccessResponse();
  }
  shelf.Response Status(shelf.Request req){
    return new JSONResponse({
      "TotalStorage" :  totalStorage,
      "MinFilesize" :  minFileSize,
      "MaxFilesize" :  maxFileSize,
      "MinDuration" :  minDuration,
      "MaxDuration" :  maxDuration,
      "WindowSize" :  windowSize,
      "Price" :  price,
      "Collateral" :  collateral,
      "NumContracts": numContracts,
      "StorageRemaining": storageRemaining
    });
  }
}
