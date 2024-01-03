import 'package:animal/data/models/bear_model.dart';
import 'package:animal/data/repositories/bear_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animal_state.dart';

class AnimalCubit extends Cubit<AnimalState> {
  AnimalCubit(
    this._bearRepository,
  ) : super(AnimalLoaded([]));
  final BearRepository _bearRepository;

  int _currentPage = 1;
  bool reachedLastPage = false;
  Future<void> getBears() async {
    if (reachedLastPage || state is AnimalLoading) return;
    emit(
      AnimalLoading(state.bears),
    );
    final bears = await _bearRepository.getBears(_currentPage);
    bears.fold(
      (l) => emit(AnimalError(
        l.message,
        state.bears,
      )),
      (r) {
        _currentPage++;
        reachedLastPage = r.isEmpty;
        emit(AnimalLoaded(
          _currentPage > 2 ? [...state.bears, ...r] : [...r],
        ));
      },
    );
  }

  Future<void> refreshBears() async {
    _currentPage = 1;
    reachedLastPage = false;
    await getBears();
  }

  Future<void> createBear(Map<String, dynamic> bearData) async {
    emit(AnimalLoading(state.bears));
    final bear = await _bearRepository.createBear(bearData);
    bear.fold((l) => emit(AnimalError(l.message, state.bears)),
        (r) => refreshBears());
  }

  Future<void> updateBear(
      String bearId, Map<String, dynamic> updatedData) async {
    emit(AnimalLoading(state.bears));
    final bear = await _bearRepository.updateBear(bearId, updatedData);
    bear.fold((l) => emit(AnimalError(l.message, state.bears)),
        (r) => refreshBears());
  }

  Future<void> deleteBear(String bearId) async {
    emit(AnimalLoading(state.bears));
    final bear = await _bearRepository.deleteBear(bearId);
    bear.fold((l) => emit(AnimalError(l.message, state.bears)), (r) {
      List<Bear> updatedBears = [...state.bears];
      updatedBears.removeWhere((bear) => bear.id == bearId);

      return emit(
          AnimalLoadedWithMessage(updatedBears, "Deleted Successfully"));
    });
  }
}
