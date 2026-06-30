import 'package:equatable/equatable.dart';
import '../../../data/models/stream_model.dart';

abstract class StreamState extends Equatable {
  const StreamState();

  @override
  List<Object?> get props => [];
}

class StreamInitial extends StreamState {}

class StreamLoading extends StreamState {}

class StreamLoaded extends StreamState {
  final List<StreamModel> allStreams;
  final List<StreamModel> filteredStreams;
  final String selectedCategory; // "Stream", "Hot", "Follow"
  final String selectedCountry;  // "Global", "India", "Philippines", "Brazil", etc.

  const StreamLoaded({
    required this.allStreams,
    required this.filteredStreams,
    required this.selectedCategory,
    required this.selectedCountry,
  });

  StreamLoaded copyWith({
    List<StreamModel>? allStreams,
    List<StreamModel>? filteredStreams,
    String? selectedCategory,
    String? selectedCountry,
  }) {
    return StreamLoaded(
      allStreams: allStreams ?? this.allStreams,
      filteredStreams: filteredStreams ?? this.filteredStreams,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCountry: selectedCountry ?? this.selectedCountry,
    );
  }

  @override
  List<Object?> get props => [
        allStreams,
        filteredStreams,
        selectedCategory,
        selectedCountry,
      ];
}

class StreamError extends StreamState {
  final String message;

  const StreamError(this.message);

  @override
  List<Object?> get props => [message];
}
