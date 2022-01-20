import 'package:core/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

class TVResponse extends Equatable {
  final List<TVModel> tvList;

  TVResponse({required this.tvList});

  factory TVResponse.fromJson(Map<String, dynamic> json) => TVResponse(
        tvList: List<TVModel>.from((json['results'] as List)
            .map((el) => TVModel.fromJson(el))
            .where((el) =>
                el.overview != null ||
                el.backdropPath != null ||
                el.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvList.map((el) => el.toJson())),
      };

  @override
  List<Object> get props => [tvList];
}
