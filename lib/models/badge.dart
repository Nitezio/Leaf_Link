class Badge {
  final String id;
  final String name;
  final String icon;
  final bool unlocked;

  Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.unlocked,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? icon,
    bool? unlocked,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
