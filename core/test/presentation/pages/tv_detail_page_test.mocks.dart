// Mocks generated by Mockito 5.0.17 from annotations
// in core/test/presentation/pages/tv_detail_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;

import 'package:bloc/bloc.dart' as _i9;
import 'package:core/domain/usecases/get_tv_detail.dart' as _i2;
import 'package:core/domain/usecases/get_tv_recommendations.dart' as _i3;
import 'package:core/domain/usecases/get_watchlist_tv_status.dart' as _i4;
import 'package:core/domain/usecases/remove_tv_watchlist.dart' as _i6;
import 'package:core/domain/usecases/save_watchlist_tv.dart' as _i5;
import 'package:core/presentation/bloc/home_detail_tv_bloc.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeGetTVDetail_0 extends _i1.Fake implements _i2.GetTVDetail {}

class _FakeGetTVRecommendations_1 extends _i1.Fake
    implements _i3.GetTVRecommendations {}

class _FakeGetWatchlistTVStatus_2 extends _i1.Fake
    implements _i4.GetWatchlistTVStatus {}

class _FakeSaveWatchlistTV_3 extends _i1.Fake implements _i5.SaveWatchlistTV {}

class _FakeRemoveTVWatchlist_4 extends _i1.Fake
    implements _i6.RemoveTVWatchlist {}

class _FakeHomeDetailTvState_5 extends _i1.Fake
    implements _i7.HomeDetailTvState {}

class _FakeStreamSubscription_6<T> extends _i1.Fake
    implements _i8.StreamSubscription<T> {}

/// A class which mocks [HomeDetailTvBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeDetailTvBloc extends _i1.Mock implements _i7.HomeDetailTvBloc {
  MockHomeDetailTvBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetTVDetail get getTVDetail =>
      (super.noSuchMethod(Invocation.getter(#getTVDetail),
          returnValue: _FakeGetTVDetail_0()) as _i2.GetTVDetail);
  @override
  _i3.GetTVRecommendations get getTVRecommendations => (super.noSuchMethod(
      Invocation.getter(#getTVRecommendations),
      returnValue: _FakeGetTVRecommendations_1()) as _i3.GetTVRecommendations);
  @override
  _i4.GetWatchlistTVStatus get getWatchListStatus => (super.noSuchMethod(
      Invocation.getter(#getWatchListStatus),
      returnValue: _FakeGetWatchlistTVStatus_2()) as _i4.GetWatchlistTVStatus);
  @override
  _i5.SaveWatchlistTV get saveWatchlist =>
      (super.noSuchMethod(Invocation.getter(#saveWatchlist),
          returnValue: _FakeSaveWatchlistTV_3()) as _i5.SaveWatchlistTV);
  @override
  _i6.RemoveTVWatchlist get removeWatchlist =>
      (super.noSuchMethod(Invocation.getter(#removeWatchlist),
          returnValue: _FakeRemoveTVWatchlist_4()) as _i6.RemoveTVWatchlist);
  @override
  _i7.HomeDetailTvState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeHomeDetailTvState_5()) as _i7.HomeDetailTvState);
  @override
  _i8.Stream<_i7.HomeDetailTvState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i7.HomeDetailTvState>.empty())
          as _i8.Stream<_i7.HomeDetailTvState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i7.HomeDetailTvEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i7.HomeDetailTvEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i8.Stream<_i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>>
      transformEvents(
              _i8.Stream<_i7.HomeDetailTvEvent>? events,
              _i9.TransitionFunction<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>?
                  transitionFn) =>
          (super.noSuchMethod(
                  Invocation.method(#transformEvents, [events, transitionFn]),
                  returnValue:
                      Stream<_i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>>.empty())
              as _i8.Stream<
                  _i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>>);
  @override
  void emit(_i7.HomeDetailTvState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i7.HomeDetailTvEvent>(
          _i9.EventHandler<E, _i7.HomeDetailTvState>? handler,
          {_i9.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  _i8.Stream<_i7.HomeDetailTvState> mapEventToState(
          _i7.HomeDetailTvEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i7.HomeDetailTvState>.empty())
          as _i8.Stream<_i7.HomeDetailTvState>);
  @override
  void onTransition(
          _i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i8.Stream<_i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>>
      transformTransitions(
              _i8.Stream<_i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>>?
                  transitions) =>
          (super.noSuchMethod(
                  Invocation.method(#transformTransitions, [transitions]),
                  returnValue:
                      Stream<_i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>>.empty())
              as _i8.Stream<
                  _i9.Transition<_i7.HomeDetailTvEvent, _i7.HomeDetailTvState>>);
  @override
  _i8.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.StreamSubscription<_i7.HomeDetailTvState> listen(
          void Function(_i7.HomeDetailTvState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue: _FakeStreamSubscription_6<_i7.HomeDetailTvState>())
          as _i8.StreamSubscription<_i7.HomeDetailTvState>);
  @override
  void onChange(_i9.Change<_i7.HomeDetailTvState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}
