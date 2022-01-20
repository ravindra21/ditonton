import 'package:core/common/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertWatchList(TVTable tv);
  Future<TVTable?> getTVById(int id);
  Future<String> removeWatchlist(TVTable tv);
  Future<List<TVTable>> getWatchlistTV();
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchList(TVTable tv) async {
    try {
      await databaseHelper.insertWatchlistTV(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVTable tv) async {
    try {
      await databaseHelper.removeWatchlistTV(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVTable?> getTVById(int id) async {
    final result = await databaseHelper.getTVById(id);
    if (result != null) {
      return TVTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTV() async {
    final result = await databaseHelper.getWatchlistTV();
    return result.map((data) => TVTable.fromMap(data)).toList();
  }
}
