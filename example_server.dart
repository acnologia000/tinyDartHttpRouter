import 'dart:io';
import 'dart:convert';
import 'muxer.dart';

const PORT = 2000;
const IP = "0.0.0.0";


Future main() async {
  var app = Mux(IP, PORT);
  
  app.AddPath("/lemon", lemon);
  await app.Listen();

  print('Listening on $IP:$PORT');
}

void lemon(HttpRequest request) {
  print("request by ${request.connectionInfo.remoteAddress.address}:${request.connectionInfo.remotePort}");
  request.response.write("request by ${request.connectionInfo.remoteAddress.address}:${request.connectionInfo.remotePort}");
  request.response.close();
}
