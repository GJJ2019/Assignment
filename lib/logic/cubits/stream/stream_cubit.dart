import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/stream_repository.dart';
import '../../../data/models/stream_model.dart';
import 'stream_state.dart';

class StreamCubit extends Cubit<StreamState> {
  final StreamRepository _streamRepository;

  StreamCubit(this._streamRepository) : super(StreamInitial());

  Future<void> loadStreams() async {
    emit(StreamLoading());
    try {
      final streams = await _streamRepository.getStreams();
      _filterAndEmit(
        all: streams,
        cat: 'Stream',
        coun: 'Global',
      );
    } catch (e) {
      emit(StreamError('Failed to load streams: ${e.toString()}'));
    }
  }

  void setCategory(String category) {
    if (state is StreamLoaded) {
      final loaded = state as StreamLoaded;
      _filterAndEmit(
        all: loaded.allStreams,
        cat: category,
        coun: loaded.selectedCountry,
      );
    }
  }

  void setCountry(String country) {
    if (state is StreamLoaded) {
      final loaded = state as StreamLoaded;
      _filterAndEmit(
        all: loaded.allStreams,
        cat: loaded.selectedCategory,
        coun: country,
      );
    }
  }

  Future<void> toggleFollow(String id) async {
    if (state is StreamLoaded) {
      final loaded = state as StreamLoaded;
      try {
        final updatedStreams = await _streamRepository.toggleFollow(id);
        _filterAndEmit(
          all: updatedStreams,
          cat: loaded.selectedCategory,
          coun: loaded.selectedCountry,
        );
      } catch (e) {
        emit(StreamError('Failed to toggle follow status: ${e.toString()}'));
      }
    }
  }

  void _filterAndEmit({
    required List<StreamModel> all,
    required String cat,
    required String coun,
  }) {
    final filtered = all.where((stream) {
      final matchCat = stream.category.toLowerCase() == cat.toLowerCase();
      final matchCoun = coun.toLowerCase() == 'global' ||
          stream.countryName.toLowerCase() == coun.toLowerCase();
      return matchCat && matchCoun;
    }).toList();

    emit(StreamLoaded(
      allStreams: all,
      filteredStreams: filtered,
      selectedCategory: cat,
      selectedCountry: coun,
    ));
  }
}
