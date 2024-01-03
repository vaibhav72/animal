part of 'animal_cubit.dart';

class AnimalState extends Equatable {
  List<Bear> bears = [];
  AnimalState(this.bears);

  @override
  List<Object> get props => [bears];
}

class AnimalLoaded extends AnimalState {
  AnimalLoaded(List<Bear> bears) : super(bears);
}

class AnimalLoadedWithMessage extends AnimalState {
  final String message;
  AnimalLoadedWithMessage(List<Bear> bears, this.message) : super(bears);
  @override
  List<Object> get props => [message, bears];
}

class AnimalLoading extends AnimalState {
  AnimalLoading(List<Bear> bears) : super(bears);
}

class AnimalError extends AnimalState {
  final String message;
  AnimalError(this.message, List<Bear> bears) : super(bears);
  @override
  List<Object> get props => [message, bears];
}
