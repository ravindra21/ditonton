part of 'home_tv_bloc.dart';

abstract class HomeTvEvent extends Equatable {
  const HomeTvEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends HomeTvEvent {}
