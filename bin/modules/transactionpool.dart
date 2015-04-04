library transactionpool;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class TransactionPool{
  // Returns of all of the transactions in the
  // transactions pool
  shelf.Response Transactions(shelf.Request req);
}

class RegularTransactionPool implements TransactionPool{
  shelf.Response Transactions(shelf.Request req){
    return new JSONResponse({
      // TODO what is actually in here?
    });
  }
}