import 'package:flutter/material.dart';

class WeatherPanel extends StatelessWidget {
  const WeatherPanel({super.key});

  static const _forecast = [
    {'day': 'Mon', 'icon': '☀️', 'rain': 0},
    {'day': 'Tue', 'icon': '⛅', 'rain': 0},
    {'day': 'Wed', 'icon': '🌧️', 'rain': 12},
    {'day': 'Thu', 'icon': '🌧️', 'rain': 8},
    {'day': 'Fri', 'icon': '☀️', 'rain': 0},
  ];

  @override
  Widget build(BuildContext context) {
    // Partly cloudy → grey gradient
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF52B788).withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Local Weather',
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 13)),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('24°',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          )),
                      SizedBox(width: 8),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Icon(Icons.cloud, color: Color(0xCCFFFFFF), size: 28),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text('Partly Cloudy',
                      style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.water_drop, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('65%', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Humidity', style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0x33FFFFFF), thickness: 1),
          const SizedBox(height: 12),

          // 5-day forecast
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('5-Day Forecast',
                style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _forecast.map((d) {
              return Column(
                children: [
                  Text(d['day'] as String,
                      style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11)),
                  const SizedBox(height: 6),
                  Text(d['icon'] as String, style: const TextStyle(fontSize: 20)),
                  if ((d['rain'] as int) > 0) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${d['rain']}mm',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Rain alert
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Text('☔', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rain ahead! Watering adjusted automatically',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
