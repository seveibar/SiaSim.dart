library daemon;

import "dart:io";

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Daemon {
  shelf.Response Stop(shelf.Request req);
  shelf.Response CheckForUpdate(shelf.Request req);
  shelf.Response ApplyUpdate(shelf.Request req);
}

/*
 * The regular daemon is up to date, returns successes.
 */
class RegularDaemon implements Daemon {
  shelf.Response Stop(shelf.Request req) {
    exit(0);
  }
  shelf.Response CheckForUpdate(shelf.Request req) {
    return new JSONResponse({
      "Available": false,
      "Version": "0.0.0"
    });
  }
  shelf.Response ApplyUpdate(shelf.Request req) {
    var version = req.url.queryParameters["version"];
    return new SuccessResponse();
  }
}
