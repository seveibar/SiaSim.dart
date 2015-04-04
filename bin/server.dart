// Copyright (c) 2015, Severin Ibarluzea. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

import "daemon.dart";

void main(List<String> args) {
  var parser = new ArgParser()
      ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

//  var handler = const shelf.Pipeline()
//      .addMiddleware(shelf.logRequests())
//      .addHandler(_echoRequest);
  
  var daemon = new RegularDaemon();
  
  var route = router()
      ..get("/", (_) => new shelf.Response.ok("SIA SIMULATOR (DART) V0.0.1"))
      ..get("/daemon/stop", daemon.Stop)
      ..get("/daemon/update/apply", daemon.ApplyUpdate)
      ..get("/daemon/update/check", daemon.CheckForUpdate)
      ..get("/consensus/status", (_) => new shelf.Response.ok(""))
      ..get("/gateway/status", (_) => new shelf.Response.ok(""))
      ..get("/gateway/synchronize", (_) => new shelf.Response.ok(""))
      ..get("/gateway/peer/add", (_) => new shelf.Response.ok(""))
      ..get("/gateway/peer/remove", (_) => new shelf.Response.ok(""))
      ..get("/host/announce", (_) => new shelf.Response.ok(""))
      ..get("/host/config", (_) => new shelf.Response.ok(""))
      ..get("/host/status", (_) => new shelf.Response.ok(""))
      ..get("/miner/start", (_) => new shelf.Response.ok(""))
      ..get("/miner/status", (_) => new shelf.Response.ok(""))
      ..get("/miner/stop", (_) => new shelf.Response.ok(""))
      ..get("/renter/download", (_) => new shelf.Response.ok(""))
      ..get("/renter/downloadqueue", (_) => new shelf.Response.ok(""))
      ..get("/renter/files", (_) => new shelf.Response.ok(""))
      ..get("/renter/upload", (_) => new shelf.Response.ok(""))
      ..get("/transactionpool/transactions", (_) => new shelf.Response.ok(""))
      ..get("/wallet/address", (_) => new shelf.Response.ok(""))
      ..get("/wallet/send", (_) => new shelf.Response.ok(""))
      ..get("/wallet/status", (_) => new shelf.Response.ok(""));
  
  
  io.serve(route.handler, 'localhost', port).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

shelf.Response _echoRequest(shelf.Request request) {
  return new shelf.Response.ok('Request for "${request.url}"');
}
