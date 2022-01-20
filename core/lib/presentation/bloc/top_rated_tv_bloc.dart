import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTV getTopRatedTv;

  TopRatedTvBloc({
    required this.getTopRatedTv,
  }) : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TopRatedTvLoading());

      final topRatedTv = await getTopRatedTv.execute();

      topRatedTv.fold((l) => emit(TopRatedTvError(l.message)), (tv) {
        emit(TopRatedTvHasData(
          tv: tv,
        ));
      });
    });
  }
}
