library daemon;

import "dart:io";

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import 'response.dart';

abstract class Daemon {
  // Cleanly shuts down the daemon. May take a while.
  shelf.Response Stop(shelf.Request req);
  
  // Applies the update specified by version.
  shelf.Response CheckForUpdate(shelf.Request req);
  
  // Checks for an update, returning a bool indicating whether
  // there is an update and a version indicating the version
  // of the update.
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
