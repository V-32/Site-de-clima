import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  
  WeatherModel? _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';

  
  void _searchWeather() async {
    final cityName = _cityController.text.trim();

    if (cityName.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, digite o nome de uma cidade.';
        _weatherData = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _weatherData = null;
    });

    try {
      final result = await _weatherService.fetchWeather(cityName);
      setState(() {
        _weatherData = result;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Previsão do Tempo'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            TextField(
              controller: _cityController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Digite a cidade',
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: 'Ex: São Paulo',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                ),
                
                
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.blueAccent),
                    onPressed: _searchWeather,
                  ),
                ),
              ),
              onSubmitted: (_) => _searchWeather(),
            ),
            const SizedBox(height: 30),

         
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: _buildStateContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildStateContent() {
   
    if (_isLoading) {
      return const CircularProgressIndicator(color: Colors.blueAccent);
    }

    
    if (_errorMessage.isNotEmpty) {
      return Text(
        _errorMessage,
        style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }

    
    if (_weatherData != null) {
      return Card(
        elevation: 6,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              Text(
                _weatherData!.cityName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              
             
              Image.network(
                _weatherData!.iconUrl,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
              ),
              
              
              Text(
                '${_weatherData!.temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              ),
              const SizedBox(height: 10),
              
             
              Text(
                _weatherData!.description.toUpperCase(),
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white70),
              ),
              const Divider(height: 30, color: Colors.white24),
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop, color: Colors.cyanAccent),
                  const SizedBox(width: 5),
                  Text(
                    'Umidade: ${_weatherData!.humidity}%',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    
    return const Text(
      'Busque por uma cidade para ver as informações do clima atual.',
      style: TextStyle(fontSize: 16, color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }
}