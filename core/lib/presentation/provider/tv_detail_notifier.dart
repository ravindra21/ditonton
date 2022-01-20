import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

class TVDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final SaveWatchlistTV saveWatchlist;
  final GetWatchlistTVStatus getWatchlistStatus;
  final RemoveTVWatchlist removeTVWatchlist;

  TVDetailNotifier({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.saveWatchlist,
    required this.getWatchlistStatus,
    required this.removeTVWatchlist,
  });

  late TVDetail _tv;
  TVDetail get tv => _tv;

  late List<TV> _tvRecommendation;
  List<TV> get tvRecommendation => _tvRecommendation;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  bool _isAddedtoWatchlist = false;
  bool get isAddedtoWatchlist => _isAddedtoWatchlist;

  String _message = '';
  String get message => _message;

  Future fetchTVDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTVDetail.execute(id);
    final recommendationResult = await getTVRecommendations.execute(id);

    detailResult.fold((failure) {
      _tvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tv) {
      _tv = tv;
      _recommendationState = RequestState.Loading;
      notifyListeners();
      recommendationResult.fold(
        (failure) {
          _recommendationState = RequestState.Error;
          _message = failure.message;
        },
        (tvs) {
          _recommendationState = RequestState.Loaded;
          _tvRecommendation = tvs;
        },
      );

      _tvState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> addWatchlist(TVDetail tv) async {
    final result = await saveWatchlist.execute(tv);

    await result.fold(
      (failure) async => _watchlistMessage = failure.message,
      (successMessage) async => _watchlistMessage = successMessage,
    );

    await loadWatchlistStatus(tv.id);
  }

  Future removeFromWatchlist(TVDetail tv) async {
    final result = await removeTVWatchlist.execute(tv);

    await result.fold(
      (failure) async => _watchlistMessage = failure.message,
      (successMessage) async => _watchlistMessage = successMessage,
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistStatus.execute(id);
    _isAddedtoWatchlist = result;

    notifyListeners();
  }
}
