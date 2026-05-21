import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';

class WeatherPanel extends StatelessWidget {
  const WeatherPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.weatherSunny, Color(0xFFFBBF24)], // Mock sunny gradient
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '24°C',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Partly Cloudy',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.droplets, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '65%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 5-Day Forecast Mock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildForecastDay('Mon', LucideIcons.cloudSun, Colors.white, ''),
              _buildForecastDay('Tue', LucideIcons.sun, Colors.white, ''),
              _buildForecastDay('Wed', LucideIcons.cloudRain, Colors.white, '2mm'),
              _buildForecastDay('Thu', LucideIcons.cloudRain, Colors.white, '5mm'),
              _buildForecastDay('Fri', LucideIcons.cloud, Colors.white, ''),
            ],
          ),
          const SizedBox(height: 12),
          // Rain Alert Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('☔'),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rain ahead! Watering adjusted automatically',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastDay(String day, IconData icon, Color color, String rain) {
    return Column(
      children: [
        Text(day, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        if (rain.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(rain, style: const TextStyle(color: Colors.white, fontSize: 10)),
          )
        else
          const SizedBox(height: 14),
      ],
    );
  }
}
