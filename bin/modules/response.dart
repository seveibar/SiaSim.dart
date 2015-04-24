
import "dart:convert";
import "package:shelf/shelf.dart";

class SuccessResponse extends Response{
  SuccessResponse() : super.ok(JSON.encode({
    "Success": true
  }));
}

class FailResponse extends Response{
  FailResponse() : super.ok(JSON.encode({
    "Success": false
  }));
}

class JSONResponse extends Response{
  JSONResponse(Object json) : super.ok(JSON.encode(json));
}