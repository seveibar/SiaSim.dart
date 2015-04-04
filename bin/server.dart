// Copyright (c) 2015, Severin Ibarluzea. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

import "daemon.dart";
import "consensus.dart";
import "gateway.dart";
import "host.dart";
import "transactionpool.dart";
import "wallet.dart";

void main(List<String> args) {
  var parser = new ArgParser()
      ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  var daemon = new RegularDaemon();
  var consensus = new RegularConsensus();
  var gateway = new RegularGateway();
  var host = new RegularHost();
  var transactionPool = new RegularTransactionPool();
  var wallet = new RegularWallet();
  
  var route = router()
      ..get("/", (_) => new shelf.Response.ok("SIA SIMULATOR (DART) V0.0.1"))
      ..get("/daemon/stop", daemon.Stop)
      ..get("/daemon/update/apply", daemon.ApplyUpdate)
      ..get("/daemon/update/check", daemon.CheckForUpdate)
      ..get("/consensus/status", consensus.Status)
      ..get("/gateway/status", gateway.Status)
      ..get("/gateway/synchronize", gateway.Synchronize)
      ..get("/gateway/peer/add", gateway.AddPeer)
      ..get("/gateway/peer/remove", gateway.RemovePeer)
      ..get("/host/announce", host.Announce)
      ..get("/host/config", host.Config)
      ..get("/host/status", host.Status)
      ..get("/miner/start", (_) => new shelf.Response.ok(""))
      ..get("/miner/status", (_) => new shelf.Response.ok(""))
      ..get("/miner/stop", (_) => new shelf.Response.ok(""))
      ..get("/renter/download", (_) => new shelf.Response.ok(""))
      ..get("/renter/downloadqueue", (_) => new shelf.Response.ok(""))
      ..get("/renter/files", (_) => new shelf.Response.ok(""))
      ..get("/renter/upload", (_) => new shelf.Response.ok(""))
      ..get("/transactionpool/transactions", transactionPool.Transactions)
      ..get("/wallet/address", wallet.Address)
      ..get("/wallet/send", wallet.Send)
      ..get("/wallet/status", wallet.Status);
  
  
  io.serve(route.handler, 'localhost', port).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

shelf.Response _echoRequest(shelf.Request request) {
  return new shelf.Response.ok('Request for "${request.url}"');
}
