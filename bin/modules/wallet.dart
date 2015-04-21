library wallet;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Wallet{
  // Returns an address that is spendable by the wallet.
  shelf.Response Address(shelf.Request req);
  
  // Sends coins to a destination address.
  shelf.Response Send(shelf.Request req);
  
  // Get the status of the wallet.
  shelf.Response Status(shelf.Request req);
}

class RegularWallet implements Wallet{
  static int _Moneys = 0;
  get Moneys => _Moneys;
  set Moneys(amt) => _Moneys = amt;
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
       "Balance": Moneys,
       "FullBalance": Moneys,
       "NumAddresses": 1
    });
  }
}