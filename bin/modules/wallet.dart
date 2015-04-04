library wallet;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Wallet{
  shelf.Response Address(shelf.Request req);
  shelf.Response Send(shelf.Request req);
  shelf.Response Status(shelf.Request req);
}

class RegularWallet implements Wallet{
  shelf.Response Address(shelf.Request req){
    return new JSONResponse({
      "Address": "123456789101112131415161718192021222324252627282930313233343536370"
    });
  }
  shelf.Response Send(shelf.Request req){
    return new SuccessResponse();
  }
  shelf.Response Status(shelf.Request req){
    return new JSONResponse({
       "Balance": 0,
       "FullBalance": 0,
       "NumAddresses": 0
    });
  }
}