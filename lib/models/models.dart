enum PlantHealth { excellent, good, warning }

class Plant {
  final String id;
  final String name;
  final String species;
  final String image;
  String lastWatered;
  String nextWatering;
  PlantHealth health;
  final int level;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.image,
    required this.lastWatered,
    required this.nextWatering,
    required this.health,
    required this.level,
  });

  Plant copyWith({
    String? lastWatered,
    String? nextWatering,
    PlantHealth? health,
  }) {
    return Plant(
      id: id,
      name: name,
      species: species,
      image: image,
      level: level,
      lastWatered: lastWatered ?? this.lastWatered,
      nextWatering: nextWatering ?? this.nextWatering,
      health: health ?? this.health,
    );
  }
}

class Badge {
  final String id;
  final String name;
  final String icon;
  final bool unlocked;

  const Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.unlocked,
  });
}

class UserStats {
  int points;
  int level;
  int streak;
  List<Badge> badges;

  UserStats({
    required this.points,
    required this.level,
    required this.streak,
    required this.badges,
  });
}

class CommunityComment {
  final String id;
  final String author;
  final String text;
  final String timeLabel;

  CommunityComment({
    required this.id,
    required this.author,
    required this.text,
    required this.timeLabel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'text': text,
      'timeLabel': timeLabel,
    };
  }

  factory CommunityComment.fromMap(Map<String, dynamic> map) {
    return CommunityComment(
      id: map['id'] as String,
      author: map['author'] as String,
      text: map['text'] as String,
      timeLabel: map['timeLabel'] as String,
    );
  }
}

class CommunityPost {
  final String id;
  final String userName;
  final String avatar;
  final String timeLabel;
  final String? imageUrl;
  final String caption;
  int likeCount;
  int commentCount;
  bool likedByMe;
  bool bookmarked;
  final List<CommunityComment> comments;

  CommunityPost({
    required this.id,
    required this.userName,
    required this.avatar,
    required this.timeLabel,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.likedByMe,
    required this.bookmarked,
    required this.comments,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'avatar': avatar,
      'timeLabel': timeLabel,
      'imageUrl': imageUrl,
      'caption': caption,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'likedByMe': likedByMe,
      'bookmarked': bookmarked,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory CommunityPost.fromMap(Map<String, dynamic> map) {
    final rawComments = map['comments'] as List<dynamic>? ?? [];
    return CommunityPost(
      id: map['id'] as String,
      userName: map['userName'] as String,
      avatar: map['avatar'] as String,
      timeLabel: map['timeLabel'] as String,
      imageUrl: map['imageUrl'] as String?,
      caption: map['caption'] as String,
      likeCount: map['likeCount'] as int,
      commentCount: map['commentCount'] as int,
      likedByMe: map['likedByMe'] as bool,
      bookmarked: map['bookmarked'] as bool,
      comments: rawComments
          .map((c) => CommunityComment.fromMap(Map<String, dynamic>.from(c as Map)))
          .toList(),
    );
  }
}

class MarketplaceItem {
  final String id;
  final String name;
  final String price;
  final String rating;
  final String seller;
  final String emoji;
  final String? badge;
  final String description;
  final int stock;

  const MarketplaceItem({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.seller,
    required this.emoji,
    required this.description,
    required this.stock,
    this.badge,
  });
}

class CartItem {
  final MarketplaceItem item;
  int quantity;

  CartItem({required this.item, required this.quantity});
}

class ScanResult {
  final String title;
  final String subtitle;
  final String emoji;
  final ColorTag colorTag;

  const ScanResult({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.colorTag,
  });
}

enum ColorTag { good, warning, neutral }
