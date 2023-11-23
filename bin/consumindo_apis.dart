import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto_hash;
import 'package:http/http.dart' as http;

Future<void> main() async {
  final String publicKey = '33a7a8e0c30161d063e6bb258801488f';
  final String privateKey = '78efc93778279f22e82b3d065394b500c6a738a8';

  final String marvelCharacters =
      'https://gateway.marvel.com/v1/public/characters';
  final String time = DateTime.now().millisecondsSinceEpoch.toString();
  final String hash = convertCalculateInput(time + privateKey + publicKey);

  final String url = '$marvelCharacters?ts=$time&apikey=$publicKey&hash=$hash';

  try {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> marvelCharactersResponse =
          json.decode(response.body);

      print(marvelCharactersResponse);
    } else {
      print(
          'Erro de requisição: ${response.statusCode}, ${response.reasonPhrase}');
    }
  } catch (error) {
    print('Erro durante a requisição: $error');
  }
}

String convertCalculateInput(String input) {
  final List<int> bytesEncodedInUtf8 = utf8.encode(input);
  final crypto_hash.Digest result = crypto_hash.md5.convert(bytesEncodedInUtf8);
  return result.toString();
}
