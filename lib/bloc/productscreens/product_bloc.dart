import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
sealed class VisionAPIEvent {}

final class ColorScan extends VisionAPIEvent {}

final class BrandScan extends VisionAPIEvent {}

// State
sealed class VisionAPIState {}

final class Loading extends VisionAPIState {}

final class ScannedColors extends VisionAPIState {}

final class ScannedBrand extends VisionAPIState {}

class VisionAPIBloc extends Bloc<VisionAPIEvent, VisionAPIState> {
  VisionAPIBloc() : super(Loading()) {
    on<ColorScan>((event, emit) {
      emit(ScannedColors());
    });
    on<BrandScan>((event, emit) {
      emit(ScannedBrand());
    });
  }
}
