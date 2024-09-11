import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

// Middleware pour ajouter le header CORS à chaque requête
Middleware corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      // Passer la requête à la prochaine fonction
      final response = await handler(request);

      // Ajouter les headers CORS à la réponse
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token'
      });
    };
  };
}

// Fonction pour démarrer le serveur
Future<void> startServer() async {
  // Handler pour gérer les requêtes
  final handler = const Pipeline()
      .addMiddleware(corsMiddleware()) // Ajoute le middleware CORS
      .addHandler(_echoRequest);

  // Démarrer le serveur
  final server = await io.serve(handler, 'localhost', 8080);
  print('Server listening on port ${server.port}');
}

// Fonction simple qui retourne les informations de la requête
Response _echoRequest(Request request) =>
    Response.ok('Request for "${request.url}"');
