import 'package:equatable/equatable.dart';

class StreamModel extends Equatable {
  final String id;
  final String streamerName;
  final String streamerAvatarUrl;
  final String viewerCount;
  final String imageUrl;
  final String countryName;
  final String countryFlag;
  final bool isFollowing;
  final String category; // "Stream", "Hot", "Follow"

  const StreamModel({
    required this.id,
    required this.streamerName,
    required this.streamerAvatarUrl,
    required this.viewerCount,
    required this.imageUrl,
    required this.countryName,
    required this.countryFlag,
    required this.isFollowing,
    required this.category,
  });

  StreamModel copyWith({
    String? id,
    String? streamerName,
    String? streamerAvatarUrl,
    String? viewerCount,
    String? imageUrl,
    String? countryName,
    String? countryFlag,
    bool? isFollowing,
    String? category,
  }) {
    return StreamModel(
      id: id ?? this.id,
      streamerName: streamerName ?? this.streamerName,
      streamerAvatarUrl: streamerAvatarUrl ?? this.streamerAvatarUrl,
      viewerCount: viewerCount ?? this.viewerCount,
      imageUrl: imageUrl ?? this.imageUrl,
      countryName: countryName ?? this.countryName,
      countryFlag: countryFlag ?? this.countryFlag,
      isFollowing: isFollowing ?? this.isFollowing,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        id,
        streamerName,
        streamerAvatarUrl,
        viewerCount,
        imageUrl,
        countryName,
        countryFlag,
        isFollowing,
        category,
      ];
}
