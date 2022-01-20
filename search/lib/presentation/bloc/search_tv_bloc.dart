import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:search/presentation/transforms/debounce_transform.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTV usecase;
  SearchTvBloc(this.usecase) : super(SearchTvEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;
      emit(SearchTvLoading());

      final result = await usecase.execute(query);

      result.fold((failure) {
        emit(SearchTvError(failure.message));
      }, (data) {
        emit(SearchTvHasData(data));
      });
    },
        transformer:
            DebounceTransform.debounce(const Duration(milliseconds: 500)));
  }
}
