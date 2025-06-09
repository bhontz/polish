import 'package:flutter_bloc/flutter_bloc.dart';

// Event
sealed class VisionAPIEvent {}

final class ImageCapture extends VisionAPIEvent {}

final class BrandCapture extends VisionAPIEvent {}

final class ChangeBC extends VisionAPIEvent {}

// State
sealed class VisionAPIState {}

final class Loading extends VisionAPIState {}

final class CapturedImage extends VisionAPIState {}

final class ChangingBC extends VisionAPIState {}

class VisionAPIBloc extends Bloc<VisionAPIEvent, VisionAPIState> {
  VisionAPIBloc() : super(Loading()) {
    on<ImageCapture>((event, emit) {
      emit(CapturedImage());
    });
    on<ChangeBC>((event, emit) {
      emit(ChangingBC());
    });
  }
}
