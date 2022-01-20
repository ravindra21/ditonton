import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTV getPopularTv;

  PopularTvBloc({
    required this.getPopularTv,
  }) : super(PopularTvEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(PopularTvLoading());

      final popularTv = await getPopularTv.execute();

      popularTv.fold((l) => emit(PopularTvError(l.message)), (tv) {
        emit(PopularTvHasData(
          tv: tv,
        ));
      });
    });
  }
}
