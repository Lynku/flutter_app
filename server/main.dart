
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

void main() async {
  final String host = '127.0.0.1';
  final int port = 8080;

  final List<dynamic> products = await _loadProducts();

  final HttpServer server = await HttpServer.bind(host, port);
  print('Server listening on http://$host:$port');

  await for (HttpRequest request in server) {
    // Add CORS headers for development
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers
        .add('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
    request.response.headers
        .add('Access-Control-Allow-Headers', 'Origin, Content-Type');

    if (request.method == 'OPTIONS') {
      // Handle preflight OPTIONS requests
      request.response.statusCode = HttpStatus.ok;
    } else if (request.method == 'POST' && request.uri.path == '/save_json') {
      try {
        final String requestBody = await utf8.decodeStream(request);
        final Map<String, dynamic> data = json.decode(requestBody);

        final String formattedDate = data['formattedDate']; // Assuming formattedDate is part of the data
        final String fileName = 'dashboard_$formattedDate.json';

        final Directory currentDir = Directory.current;
        final Directory dashboardDataDir =
            Directory(p.join(currentDir.path, 'dashboard_data'));

        if (!await dashboardDataDir.exists()) {
          await dashboardDataDir.create(recursive: true);
        }

        final File file = File(p.join(dashboardDataDir.path, fileName));
        await file.writeAsString(json
            .encode(data['data'])); // Assuming the actual data is under a 'data' key

        request.response.statusCode = HttpStatus.ok;
        request.response.write('File saved successfully: ${file.path}');
      } catch (e) {
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write('Error saving file: $e');
      }
    } else if (request.method == 'GET' &&
        request.uri.path.startsWith('/read_json/')) {
      try {
        final String formattedDate = request.uri.pathSegments.last;
        final String fileName = 'dashboard_$formattedDate.json';

        final Directory currentDir = Directory.current;
        final Directory dashboardDataDir =
            Directory(p.join(currentDir.path, 'dashboard_data'));
        final File file = File(p.join(dashboardDataDir.path, fileName));

        if (await file.exists()) {
          final contents = await file.readAsString();
          request.response.statusCode = HttpStatus.ok;
          request.response.headers.contentType = ContentType.json;
          request.response.write(contents);
        } else {
          request.response.statusCode = HttpStatus.notFound;
          request.response.write('File not found');
        }
      } catch (e) {
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write('Error reading file: $e');
      }
    } else if (request.method == 'GET' &&
        request.uri.path.startsWith('/products/')) {
      final String barcode = request.uri.pathSegments.last;
      final product = products.firstWhere((p) => p['barcode'] == barcode,
          orElse: () => null);
      if (product != null) {
        request.response.statusCode = HttpStatus.ok;
        request.response.headers.contentType = ContentType.json;
        request.response.write(json.encode(product));
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Product not found');
      }
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found');
    }
    await request.response.close();
  }
}

Future<List<dynamic>> _loadProducts() async {
  final Directory currentDir = Directory.current;
  final File file = File(p.join(currentDir.path, 'server', 'products.json'));
  if (await file.exists()) {
    final contents = await file.readAsString();
    return json.decode(contents);
  }
  return [];
}
