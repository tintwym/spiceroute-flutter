import 'package:flutter/material.dart';

enum LandingDifficulty { easy, medium, hard }

enum LandingSpiceLevel { mild, medium, hot, numbing }

class LandingRecipe {
  const LandingRecipe({
    required this.id,
    required this.name,
    required this.regionId,
    required this.regionName,
    required this.cookingTime,
    required this.calories,
    required this.difficulty,
    required this.spiceLevel,
    required this.aromaProfile,
    required this.description,
    required this.imageUrl,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.localTradition,
  });

  final String id;
  final String name;
  final String regionId;
  final String regionName;
  final String cookingTime;
  final int calories;
  final LandingDifficulty difficulty;
  final LandingSpiceLevel spiceLevel;
  final String aromaProfile;
  final String description;
  final String imageUrl;
  final int servings;
  final List<String> ingredients;
  final List<String> instructions;
  final String localTradition;

  String get difficultyLabel => switch (difficulty) {
    LandingDifficulty.easy => 'Easy',
    LandingDifficulty.medium => 'Medium',
    LandingDifficulty.hard => 'Hard',
  };

  String get spiceLevelLabel => switch (spiceLevel) {
    LandingSpiceLevel.mild => 'Mild',
    LandingSpiceLevel.medium => 'Medium',
    LandingSpiceLevel.hot => 'Hot',
    LandingSpiceLevel.numbing => 'Numbing',
  };
}

class LandingRegion {
  const LandingRegion({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.markerOffset,
    required this.recipes,
  });

  final String id;
  final String name;
  final String icon;
  final String description;
  final Offset markerOffset;
  final List<LandingRecipe> recipes;
}

class LandingCommunityPost {
  const LandingCommunityPost({
    required this.id,
    required this.username,
    required this.dishName,
    required this.regionName,
    required this.caption,
    required this.imageUrl,
    required this.tags,
    required this.timestamp,
    required this.likes,
  });

  final String id;
  final String username;
  final String dishName;
  final String regionName;
  final String caption;
  final String imageUrl;
  final List<String> tags;
  final String timestamp;
  final int likes;

  LandingCommunityPost copyWith({int? likes, String? imageUrl}) => LandingCommunityPost(
    id: id,
    username: username,
    dishName: dishName,
    regionName: regionName,
    caption: caption,
    imageUrl: imageUrl ?? this.imageUrl,
    tags: tags,
    timestamp: timestamp,
    likes: likes ?? this.likes,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'dishName': dishName,
    'regionName': regionName,
    'caption': caption,
    'imageUrl': imageUrl,
    'tags': tags,
    'timestamp': timestamp,
    'likes': likes,
  };

  factory LandingCommunityPost.fromJson(Map<String, dynamic> json) =>
      LandingCommunityPost(
        id: json['id'] as String,
        username: json['username'] as String,
        dishName: json['dishName'] as String,
        regionName: json['regionName'] as String,
        caption: json['caption'] as String,
        imageUrl: json['imageUrl'] as String,
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        timestamp: json['timestamp'] as String,
        likes: json['likes'] as int,
      );
}

class LandingChefMessage {
  const LandingChefMessage({
    required this.id,
    required this.isChef,
    required this.text,
    required this.timestamp,
  });

  final String id;
  final bool isChef;
  final String text;
  final DateTime timestamp;
}

class LandingSpinDestination {
  const LandingSpinDestination({
    required this.country,
    required this.city,
    required this.stamp,
    required this.dish,
    required this.aroma,
    required this.tip,
  });

  final String country;
  final String city;
  final String stamp;
  final String dish;
  final String aroma;
  final String tip;
}

enum LandingRecipeTab { heritage, ingredients, steps }
