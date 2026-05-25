import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  static const _communityPrefsKey = 'community_posts_v1';

  AppState() {
    _communityPosts.addAll(_seedCommunityPosts());
    _loadCommunityPosts();
    // Attempt background migration to Firestore (idempotent)
    migrateLocalPostsToFirestore();
  }

  List<Plant> plants = [
    Plant(
      id: '1',
      name: 'Monstera Deliciosa',
      species: 'Swiss Cheese Plant',
      image: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400',
      lastWatered: '2 days ago',
      nextWatering: 'Tomorrow',
      health: PlantHealth.excellent,
      level: 5,
    ),
    Plant(
      id: '2',
      name: 'Golden Pothos',
      species: 'Epipremnum aureum',
      image: 'https://images.unsplash.com/photo-1632207691143-643e2753a2c4?w=400',
      lastWatered: 'Yesterday',
      nextWatering: 'In 2 days',
      health: PlantHealth.good,
      level: 3,
    ),
    Plant(
      id: '3',
      name: 'Snake Plant',
      species: 'Sansevieria trifasciata',
      image: 'https://images.unsplash.com/photo-1593482892290-d86fe3016e13?w=400',
      lastWatered: '5 days ago',
      nextWatering: 'Today',
      health: PlantHealth.warning,
      level: 4,
    ),
  ];

  UserStats userStats = UserStats(
    points: 3450,
    level: 12,
    streak: 15,
    badges: const [
      Badge(id: '1', name: 'Green Thumb', icon: '🌱', unlocked: true),
      Badge(id: '2', name: 'Caretaker', icon: '💚', unlocked: true),
      Badge(id: '3', name: 'Streak Master', icon: '🔥', unlocked: true),
      Badge(id: '4', name: 'Plant Doctor', icon: '🩺', unlocked: true),
      Badge(id: '5', name: 'Collector', icon: '🏆', unlocked: false),
      Badge(id: '6', name: 'Social Butterfly', icon: '🦋', unlocked: false),
      Badge(id: '7', name: 'Trader', icon: '🤝', unlocked: false),
      Badge(id: '8', name: 'Master Gardener', icon: '👑', unlocked: false),
    ],
  );

  final List<CommunityPost> _communityPosts = [];
  bool _communityLoaded = false;
  final FirestoreService _firestore = FirestoreService();

  final List<MarketplaceItem> marketplaceItems = const [
    MarketplaceItem(
      id: 'market-1',
      name: 'Peace Lily',
      price: '\$18.99',
      rating: '4.8',
      seller: 'GreenShop',
      emoji: '🌸',
      badge: 'Best Seller',
      description: 'Air-purifying indoor plant with elegant white blooms.',
      stock: 18,
    ),
    MarketplaceItem(
      id: 'market-2',
      name: 'ZZ Plant',
      price: '\$24.99',
      rating: '4.9',
      seller: 'Urban Roots',
      emoji: '🌿',
      badge: 'Popular',
      description: 'Low-maintenance, glossy leaves, thrives in low light.',
      stock: 12,
    ),
    MarketplaceItem(
      id: 'market-3',
      name: 'Bird of Paradise',
      price: '\$45.00',
      rating: '4.7',
      seller: 'Leaf & Co.',
      emoji: '🌴',
      description: 'Statement indoor plant with bold tropical foliage.',
      stock: 6,
    ),
    MarketplaceItem(
      id: 'market-4',
      name: 'Fiddle Leaf Fig',
      price: '\$39.99',
      rating: '4.6',
      seller: 'Plant Haven',
      emoji: '🌳',
      badge: 'New',
      description: 'A dramatic floor plant that loves bright filtered light.',
      stock: 9,
    ),
  ];

  final List<CartItem> cartItems = [];

  List<CommunityPost> get communityPosts => List.unmodifiable(_communityPosts);
  bool get communityLoaded => _communityLoaded;

  int get cartCount => cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

  bool isInCart(String itemId) => cartItems.any((item) => item.item.id == itemId);

  CartItem? cartItemFor(String itemId) {
    for (final item in cartItems) {
      if (item.item.id == itemId) return item;
    }
    return null;
  }

  CommunityPost? getCommunityPost(String id) {
    for (final post in _communityPosts) {
      if (post.id == id) {
        return post;
      }
    }
    return null;
  }

  void waterPlant(String id) {
    final idx = plants.indexWhere((p) => p.id == id);
    if (idx != -1) {
      plants[idx] = plants[idx].copyWith(
        lastWatered: 'Just now',
        nextWatering: 'In 3 days',
        health: PlantHealth.excellent,
      );
      userStats.points += 50;
      userStats.streak += 1;
      notifyListeners();
    }
  }

  void addCommunityPost(String caption, {String? imageUrl}) {
    final trimmed = caption.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final post = CommunityPost(
      id: _generateId(),
      userName: 'You',
      avatar: '🧑',
      timeLabel: 'Just now',
      caption: trimmed,
      imageUrl: imageUrl,
      likeCount: 0,
      commentCount: 0,
      likedByMe: false,
      bookmarked: false,
      comments: [],
    );
    _communityPosts.insert(0, post);
    _saveCommunityPosts();
    notifyListeners();
  }

  void addToCart(MarketplaceItem item) {
    final existing = cartItemFor(item.id);
    if (existing != null) {
      if (existing.quantity < item.stock) {
        existing.quantity += 1;
      }
    } else {
      cartItems.add(CartItem(item: item, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    cartItems.removeWhere((item) => item.item.id == itemId);
    notifyListeners();
  }

  void incrementCartItem(String itemId) {
    final existing = cartItemFor(itemId);
    if (existing == null || existing.quantity >= existing.item.stock) return;
    existing.quantity += 1;
    notifyListeners();
  }

  void decrementCartItem(String itemId) {
    final existing = cartItemFor(itemId);
    if (existing == null) return;
    if (existing.quantity <= 1) {
      removeFromCart(itemId);
      return;
    }
    existing.quantity -= 1;
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  void toggleCommunityLike(String postId) {
    final post = getCommunityPost(postId);
    if (post == null) {
      return;
    }
    post.likedByMe = !post.likedByMe;
    post.likeCount += post.likedByMe ? 1 : -1;
    if (post.likeCount < 0) {
      post.likeCount = 0;
    }
    _saveCommunityPosts();
    notifyListeners();
  }

  void toggleCommunityBookmark(String postId) {
    final post = getCommunityPost(postId);
    if (post == null) {
      return;
    }
    post.bookmarked = !post.bookmarked;
    _saveCommunityPosts();
    notifyListeners();
  }

  void addCommunityComment(String postId, String text) {
    final post = getCommunityPost(postId);
    final trimmed = text.trim();
    if (post == null || trimmed.isEmpty) {
      return;
    }
    post.comments.add(
      CommunityComment(
        id: _generateId(),
        author: 'You',
        text: trimmed,
        timeLabel: 'Just now',
      ),
    );
    post.commentCount += 1;
    _saveCommunityPosts();
    notifyListeners();
  }

  Future<void> _loadCommunityPosts() async {
    // Attempt to load from Firestore first (if available), otherwise fall back
    // to local SharedPreferences. This enables migration and remote sync.
    try {
      await _loadCommunityFromFirestore();
      _communityLoaded = true;
      notifyListeners();
      return;
    } catch (_) {
      // If Firestore isn't available or network fails, continue to local load.
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_communityPrefsKey);
      if (raw == null || raw.isEmpty) {
        _communityLoaded = true;
        await _saveCommunityPosts();
        notifyListeners();
        return;
      }
      final decoded = jsonDecode(raw) as List<dynamic>;
      final posts = decoded
          .map((p) => CommunityPost.fromMap(Map<String, dynamic>.from(p as Map)))
          .toList();
      _communityPosts
        ..clear()
        ..addAll(posts);
      _communityLoaded = true;
      notifyListeners();
    } catch (_) {
      _communityPosts
        ..clear()
        ..addAll(_seedCommunityPosts());
      _communityLoaded = true;
      await _saveCommunityPosts();
      notifyListeners();
    }
  }

  Future<void> _loadCommunityFromFirestore() async {
    if (!_firestore.isAvailable) {
      throw StateError('Firestore unavailable');
    }
    final snapshot = await _firestore.watchPosts().first;
    final posts = snapshot.docs
        .map((d) => CommunityPost.fromMap(Map<String, dynamic>.from(d.data())))
        .toList();
    if (posts.isNotEmpty) {
      _communityPosts
        ..clear()
        ..addAll(posts);
    }
    _communityLoaded = true;
  }

  Future<void> _saveCommunityPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(_communityPosts.map((p) => p.toMap()).toList());
    await prefs.setString(_communityPrefsKey, payload);
    // Also attempt to save newest posts to Firestore (best-effort).
    try {
      for (final p in _communityPosts) {
        await _firestore.setPost(p.id, p.toMap());
      }
    } catch (_) {
      // ignore write failures for prototype.
    }
  }

  /// Migrate locally stored community posts to Firestore. Idempotent.
  Future<void> migrateLocalPostsToFirestore() async {
    if (!_firestore.isAvailable) return;
    final prefs = await SharedPreferences.getInstance();
    final migrated = prefs.getBool('community_migrated_v1') ?? false;
    if (migrated) return;
    final raw = prefs.getString(_communityPrefsKey);
    if (raw == null || raw.isEmpty) {
      await prefs.setBool('community_migrated_v1', true);
      return;
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final posts = decoded
          .map((p) => CommunityPost.fromMap(Map<String, dynamic>.from(p as Map)))
          .toList();
      for (final post in posts) {
        try {
          await _firestore.setPost(post.id, post.toMap());
        } catch (_) {
          // ignore per-post failures
        }
      }
      await prefs.setBool('community_migrated_v1', true);
    } catch (_) {
      // migration failed, keep flag false for retry
    }
  }

  List<CommunityPost> _seedCommunityPosts() {
    return [
      CommunityPost(
        id: 'seed-1',
        userName: 'GreenThumb_Alice',
        avatar: '🌿',
        timeLabel: '2 hours ago',
        imageUrl: 'https://images.unsplash.com/photo-1636818033571-c0a5bb1f9eda?w=400',
        caption: 'My Monstera just unfurled a new leaf! 🎉 So excited about this beauty.',
        likeCount: 142,
        commentCount: 23,
        likedByMe: false,
        bookmarked: false,
        comments: [],
      ),
      CommunityPost(
        id: 'seed-2',
        userName: 'PlantDad_Marco',
        avatar: '🌱',
        timeLabel: '5 hours ago',
        imageUrl: 'https://images.unsplash.com/photo-1463936575829-25148e1db1b8?w=400',
        caption: 'Morning light through the succulents 🌵 Nothing better to start the day.',
        likeCount: 89,
        commentCount: 11,
        likedByMe: false,
        bookmarked: false,
        comments: [],
      ),
      CommunityPost(
        id: 'seed-3',
        userName: 'UrbanJungle_Mia',
        avatar: '🏡',
        timeLabel: 'Yesterday',
        imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
        caption: 'Finally put together my living room jungle corner! 🌿🌿',
        likeCount: 210,
        commentCount: 38,
        likedByMe: false,
        bookmarked: false,
        comments: [],
      ),
    ];
  }

  String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
