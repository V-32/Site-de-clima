class WeatherModel {
  final String cityName;
  final double temperature;
  final int humidity;
  final String description;
  final String iconCode;

  
  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.iconCode,
  });

  
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '',
    );
  }

 
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}