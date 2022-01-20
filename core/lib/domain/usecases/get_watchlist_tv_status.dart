import 'package:core/domain/repositories/tv_repository.dart';

class GetWatchlistTVStatus {
  TVRepository repository;

  GetWatchlistTVStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
