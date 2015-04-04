
import "dart:convert";
import "package:shelf/shelf.dart";

class SuccessResponse extends Response{
  SuccessResponse() : super.ok(JSON.encode({
    "Success": true
  }));
}

class JSONResponse extends Response{
  JSONResponse(Object json) : super.ok(JSON.encode(json));
}