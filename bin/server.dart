import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';
const _port = 8080;

void main(List<String> args) async {
  // Cascade handlers
  final handlerCascade = shelf.Cascade().add((request) {
    if (request.url.path == 'a') {
      // if path matches exit cascade
      return shelf.Response.ok('handler a');
    }
    return shelf.Response.notFound('not found');
  }).add((request) {
    if (request.url.path == 'b') {
      // if path matches exit cascade
      return shelf.Response.ok('handler b');
    }
    return shelf.Response.notFound('not found');
  }).add((request) {
    if (request.url.path == 'c') {
      // if path matches exit cascade
      return shelf.Response.ok('handler c');
    }
    return shelf.Response.notFound('not found');
  }).add((request) {
    // if all else fails throw not found
    return shelf.Response.notFound('not found');
  }).handler;

  // Pipeline handlers
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(handlerCascade);

  // Create a shelf server 1
  final server = await io.serve(
    handler,
    _hostname,
    _port,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}
