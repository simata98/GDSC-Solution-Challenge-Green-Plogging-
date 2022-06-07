import 'package:http/http.dart' as http;
import 'dart:convert';

var _apikey = 'AIzaSyDRTDJD5GwawXDDRqird92lGdpJWoauYfM';

Future<http.Response> voiceResponse(String text) async {
  String url =
      'https://texttospeech.googleapis.com/v1beta1/text:synthesize?key=$_apikey';

  var body = jsonEncode({
    "audioConfig": {"audioEncoding": "LINEAR16", "pitch": 0, "speakingRate": 1},
    "input": {"text": text},
    "voice": {"languageCode": "en-US", "name": "en-US-Wavenet-D"}
  });

  var response = http.post(Uri.parse(url),
      headers: {"Content-type": "application/json"}, body: body);

  return response;
}
