import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart'; 

class WeatherService {
  final String _apiKey = '63d99d2c472af81335b9696cdf09f4bf';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

 
  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric&lang=pt_br');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        return WeatherModel.fromJson(decodedJson);
      } 
      else if (response.statusCode == 404) {
        throw Exception('Cidade não encontrada (Erro 404). Verifique a ortografia.');
      } 
      else {
        throw Exception('Erro ao carregar dados do clima. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('404')) {
        rethrow;
      }
      throw Exception('Falha na conexão. Verifique se o dispositivo está conectado à internet.');
    }
  }
}