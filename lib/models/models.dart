enum PlantHealth { excellent, good, warning }

class CareEvent {
  final String id;
  final String type; // 'water', 'note', 'photo', etc.
  final String timestamp; // ISO string
  final String? note;
  final String? photoPath;

  CareEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    this.note,
    this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp,
      'note': note,
      'photoPath': photoPath,
    };
  }

  factory CareEvent.fromMap(Map<String, dynamic> map) {
    return CareEvent(
      id: map['id'] as String,
      type: map['type'] as String,
      timestamp: map['timestamp'] as String,
      note: map['note'] as String?,
      photoPath: map['photoPath'] as String?,
    );
  }
}

class Plant {
  final String id;
  final String name;
  final String species;
  final String image;
  final String notes;
  String lastWatered;
  String nextWatering;
  PlantHealth health;
  final int level;
  final List<CareEvent> careHistory;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.image,
    this.notes = '',
    required this.lastWatered,
    required this.nextWatering,
    required this.health,
    required this.level,
    this.careHistory = const [],
  });

  Plant copyWith({
    String? name,
    String? species,
    String? image,
    String? notes,
    String? lastWatered,
    String? nextWatering,
    PlantHealth? health,
    int? level,
    List<CareEvent>? careHistory,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      image: image ?? this.image,
      notes: notes ?? this.notes,
      level: level ?? this.level,
      lastWatered: lastWatered ?? this.lastWatered,
      nextWatering: nextWatering ?? this.nextWatering,
      health: health ?? this.health,
      careHistory: careHistory ?? this.careHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'image': image,
      'notes': notes,
      'lastWatered': lastWatered,
      'nextWatering': nextWatering,
      'health': health.index,
      'level': level,
      'careHistory': careHistory.map((c) => c.toMap()).toList(),
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as String,
      name: map['name'] as String,
      species: map['species'] as String,
      image: map['image'] as String,
      notes: (map['notes'] as String?) ?? '',
      lastWatered: map['lastWatered'] as String,
      nextWatering: map['nextWatering'] as String,
      health: PlantHealth.values[map['health'] as int],
      level: map['level'] as int,
      careHistory: (map['careHistory'] as List<dynamic>?)
              ?.map((c) => CareEvent.fromMap(Map<String, dynamic>.from(c as Map)))
              .toList() ?? [],
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
  int tokens;

  UserStats({
    required this.points,
    required this.level,
    required this.streak,
    required this.badges,
    this.tokens = 0,
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
  bool reportedByMe;
  int reportCount;
  bool hidden;
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
    this.reportedByMe = false,
    this.reportCount = 0,
    this.hidden = false,
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
      'reportedByMe': reportedByMe,
      'reportCount': reportCount,
      'hidden': hidden,
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
        reportedByMe: (map['reportedByMe'] as bool?) ?? false,
      reportCount: (map['reportCount'] as int?) ?? 0,
      hidden: (map['hidden'] as bool?) ?? false,
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
  int stock;

  MarketplaceItem({
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

class ReceiptLine {
  final String itemId;
  final String itemName;
  final String emoji;
  final String priceLabel;
  final int quantity;

  ReceiptLine({
    required this.itemId,
    required this.itemName,
    required this.emoji,
    required this.priceLabel,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'emoji': emoji,
      'priceLabel': priceLabel,
      'quantity': quantity,
    };
  }

  factory ReceiptLine.fromMap(Map<String, dynamic> map) {
    return ReceiptLine(
      itemId: map['itemId'] as String,
      itemName: map['itemName'] as String,
      emoji: map['emoji'] as String,
      priceLabel: map['priceLabel'] as String,
      quantity: (map['quantity'] as num).toInt(),
    );
  }
}

class PurchaseReceipt {
  final String id;
  final String purchasedAt;
  final List<ReceiptLine> items;
  final String totalLabel;
  final int pointsAwarded;

  PurchaseReceipt({
    required this.id,
    required this.purchasedAt,
    required this.items,
    required this.totalLabel,
    required this.pointsAwarded,
  });

  int get totalItems => items.fold<int>(0, (sum, line) => sum + line.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchasedAt': purchasedAt,
      'items': items.map((item) => item.toMap()).toList(),
      'totalLabel': totalLabel,
      'pointsAwarded': pointsAwarded,
    };
  }

  factory PurchaseReceipt.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return PurchaseReceipt(
      id: map['id'] as String,
      purchasedAt: map['purchasedAt'] as String,
      items: rawItems
          .map((item) => ReceiptLine.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
      totalLabel: map['totalLabel'] as String,
      pointsAwarded: (map['pointsAwarded'] as num).toInt(),
    );
  }
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
