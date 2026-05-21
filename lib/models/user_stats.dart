import 'badge.dart';

class UserStats {
  final int points;
  final int level;
  final int streak;
  final List<Badge> badges;

  UserStats({
    required this.points,
    required this.level,
    required this.streak,
    required this.badges,
  });

  UserStats copyWith({
    int? points,
    int? level,
    int? streak,
    List<Badge>? badges,
  }) {
    return UserStats(
      points: points ?? this.points,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
    );
  }

  // Mock data factory
  static UserStats get mockStats => UserStats(
        points: 3450,
        level: 12,
        streak: 15,
        badges: [
          Badge(id: "1", name: "Green Thumb", icon: "🌱", unlocked: true),
          Badge(id: "2", name: "Caretaker", icon: "💚", unlocked: true),
          Badge(id: "3", name: "Streak Master", icon: "🔥", unlocked: true),
          Badge(id: "4", name: "Plant Doctor", icon: "🩺", unlocked: true),
          Badge(id: "5", name: "Collector", icon: "🏆", unlocked: false),
          Badge(id: "6", name: "Social Butterfly", icon: "🦋", unlocked: false),
          Badge(id: "7", name: "Trader", icon: "🤝", unlocked: false),
          Badge(id: "8", name: "Master Gardener", icon: "👑", unlocked: false),
        ],
      );
}
