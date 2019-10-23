import 'dart:io';

class Mux {
  Future<HttpServer> server;

  Mux(String ip, int port) {
    if (port >= 1024) {
      print("Please provide a port number bigger than 1024");
    }

    server = HttpServer.bind(
      ip,
      port,
    );
  }

  List<Function> exec = [];
  List<String> paths = [];

  var mxMap = new Map();

  void AddPath(String path, Function fn) {
    exec.add(fn);
    paths.add(path);
  }

  void CreateMap() {
    for (var i = 0; i < exec.length; i++) {
      mxMap[paths[i]] = exec[i];
    }
  }

  void Handle(HttpRequest request) {
    try {
      mxMap[request.uri.toString()](request);
    } catch (e) {
      print("ROUE NOT FOUND");
      request.response.write("ERR 404 NOT FOUND");
      exec[0](request);
    }
  }

  void Listen() async {
    this.CreateMap();

    server.then((e) async {
      await for (var req in e) {
        this.Handle(req);
      }
    });
  }
}
