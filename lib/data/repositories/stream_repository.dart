import 'dart:async';
import '../models/stream_model.dart';

abstract class StreamRepository {
  Future<List<StreamModel>> getStreams();
  Future<List<StreamModel>> toggleFollow(String streamId);
}

class MockStreamRepository implements StreamRepository {
  List<StreamModel> _streams = [
    const StreamModel(
      id: 'stream_1',
      streamerName: 'Sofia Chen',
      streamerAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
      viewerCount: '8.2K',
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=500&q=80',
      countryName: 'Philippines',
      countryFlag: '🇵🇭',
      isFollowing: false,
      category: 'Stream',
    ),
    const StreamModel(
      id: 'stream_2',
      streamerName: 'Aria Dev',
      streamerAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
      viewerCount: '12.4K',
      imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=500&q=80',
      countryName: 'Global',
      countryFlag: '🌐',
      isFollowing: true,
      category: 'Stream',
    ),
    const StreamModel(
      id: 'stream_3',
      streamerName: 'Karan Sharma',
      streamerAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
      viewerCount: '5.1K',
      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=500&q=80',
      countryName: 'India',
      countryFlag: '🇮🇳',
      isFollowing: false,
      category: 'Hot',
    ),
    const StreamModel(
      id: 'stream_4',
      streamerName: 'Thiago Silva',
      streamerAvatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
      viewerCount: '19.8K',
      imageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=500&q=80',
      countryName: 'Brazil',
      countryFlag: '🇧🇷',
      isFollowing: false,
      category: 'Hot',
    ),
    const StreamModel(
      id: 'stream_5',
      streamerName: 'Chloe Kim',
      streamerAvatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80',
      viewerCount: '2.3K',
      imageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=500&q=80',
      countryName: 'Global',
      countryFlag: '🌐',
      isFollowing: false,
      category: 'Follow',
    ),
    const StreamModel(
      id: 'stream_6',
      streamerName: 'Marcus Aurelius',
      streamerAvatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80',
      viewerCount: '9.5K',
      imageUrl: 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?auto=format&fit=crop&w=500&q=80',
      countryName: 'India',
      countryFlag: '🇮🇳',
      isFollowing: true,
      category: 'Follow',
    ),
  ];

  @override
  Future<List<StreamModel>> getStreams() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate api call latency
    return List.from(_streams);
  }

  @override
  Future<List<StreamModel>> toggleFollow(String streamId) async {
    _streams = _streams.map((stream) {
      if (stream.id == streamId) {
        return stream.copyWith(isFollowing: !stream.isFollowing);
      }
      return stream;
    }).toList();
    return List.from(_streams);
  }
}
