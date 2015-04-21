// Copyright (c) 2015, Severin Ibarluzea. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

import 'modules/daemon.dart';
import 'modules/consensus.dart';
import 'modules/gateway.dart';
import 'modules/host.dart';
import 'modules/transactionpool.dart';
import 'modules/wallet.dart';
import 'modules/miner.dart';
import 'modules/renter.dart';

void main(List<String> args) {
  
  // Parse command line arguments
  var parser = new ArgParser()
      ..addOption('port', abbr: 'p', defaultsTo: '9980');

  var result = parser.parse(args);
  
  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });
  
  // Initialize the modules for receiving responses
  var wallet = new RegularWallet();
  var daemon = new RegularDaemon();
  var consensus = new RegularConsensus();
  var gateway = new RegularGateway();
  var host = new RegularHost();
  var transactionPool = new RegularTransactionPool();
  var miner = new RegularMiner(wallet);
  var renter = new RegularRenter();
  
  // Route the URLs to response callbacks
  var route = router()
      ..get("/", (_) => new shelf.Response.ok("SIA SIMULATOR (DART) V0.0.1"))
      ..get("/daemon/stop",         daemon.Stop)
      ..get("/daemon/update/apply", daemon.ApplyUpdate)
      ..get("/daemon/update/check", daemon.CheckForUpdate)
      ..get("/consensus/status",    consensus.Status)
      ..get("/gateway/status",      gateway.Status)
      ..get("/gateway/synchronize", gateway.Synchronize)
      ..get("/gateway/peer/add",    gateway.AddPeer)
      ..get("/gateway/peer/remove", gateway.RemovePeer)
      ..get("/host/announce",       host.Announce)
      ..get("/host/config",         host.Config)
      ..get("/host/status",         host.Status)
      ..get("/miner/start",         miner.Start)
      ..get("/miner/status",        miner.Status)
      ..get("/miner/stop",          miner.Stop)
      ..get("/renter/download",     renter.Download)
      ..get("/renter/downloadqueue",renter.DownloadQueue)
      ..get("/renter/files",        renter.Files)
      ..get("/renter/upload",       renter.Upload)
      ..get("/transactionpool/transactions", transactionPool.Transactions)
      ..get("/wallet/address",      wallet.Address)
      ..get("/wallet/send",         wallet.Send)
      ..get("/wallet/status",       wallet.Status);
  
  // Actually start the server
  io.serve(route.handler, 'localhost', port).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}
