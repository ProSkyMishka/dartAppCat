import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/liked_cat.dart';

class LikeState {
  final List<LikedCat> likedCats;
  final String? selectedBreed;

  LikeState({required this.likedCats, this.selectedBreed});

  List<LikedCat> get filtered =>
      selectedBreed == null || selectedBreed!.isEmpty || selectedBreed == 'Все породы'
          ? likedCats
          : likedCats.where((c) => c.cat.breedName == selectedBreed).toList();
}

class LikeCubit extends Cubit<LikeState> {
  LikeCubit() : super(LikeState(likedCats: []));

  void add(LikedCat cat) => emit(
    LikeState(
      likedCats: [...state.likedCats, cat],
      selectedBreed: state.selectedBreed,
    ),
  );

  void remove(LikedCat cat) => emit(
    LikeState(
      likedCats: state.likedCats.where((c) => c != cat).toList(),
      selectedBreed: state.selectedBreed,
    ),
  );

  void filterByBreed(String? breed) => emit(
    LikeState(
      likedCats: state.likedCats,
      selectedBreed: breed == 'Все породы' ? null : breed,
    ),
  );

  void clearFilter() => emit(LikeState(likedCats: state.likedCats));
}
