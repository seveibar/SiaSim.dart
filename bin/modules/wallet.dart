library wallet;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import '../appstate.dart';
import 'response.dart';

abstract class Wallet{
  AppState appState;

  // Constructor that gives relationship to appState
  Wallet(this.appState);

  // Returns an address that is spendable by the wallet.
  shelf.Response Address(shelf.Request req);

  // Sends coins to a destination address.
  shelf.Response Send(shelf.Request req);

  // Get the status of the wallet.
  shelf.Response Status(shelf.Request req);
}

class RegularWallet extends Wallet{
  //AppState appState;

  RegularWallet(appState):super(appState);
  shelf.Response Address(shelf.Request req){
    appState.numAddresses++;
    return new JSONResponse({
      "Address": "123456789101112131415161718192021222324252627282930313233343536370"
    });
  }
  shelf.Response Send(shelf.Request req){
    return new SuccessResponse();
  }
  shelf.Response Status(shelf.Request req){
    return new JSONResponse({
       "Balance": appState.balance,
       "FullBalance": appState.fullBalance,
       "NumAddresses": appState.numAddresses
    });
  }
}