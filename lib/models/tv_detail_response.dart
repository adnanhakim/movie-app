class TvDetailResponse {
  dynamic backdropPath;
  List<int> episodeRunTime;
  DateTime firstAirDate;
  String homepage;
  int id;
  List<String> languages;
  DateTime lastAirDate;
  List<Network> networks;
  int numberOfEpisodes;
  int numberOfSeasons;
  String originalLanguage;
  List<Season> seasons;

  TvDetailResponse({
    this.backdropPath,
    this.episodeRunTime,
    this.firstAirDate,
    this.homepage,
    this.id,
    this.languages,
    this.lastAirDate,
    this.networks,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.originalLanguage,
    this.seasons,
  });

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        backdropPath: json["backdrop_path"],
        episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        firstAirDate: DateTime.parse(json["first_air_date"]),
        homepage: json["homepage"],
        id: json["id"],
        languages: List<String>.from(json["languages"].map((x) => x)),
        lastAirDate: DateTime.parse(json["last_air_date"]),
        networks: List<Network>.from(
            json["networks"].map((x) => Network.fromJson(x))),
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        originalLanguage: json["original_language"],
        seasons:
            List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "episode_run_time": List<dynamic>.from(episodeRunTime.map((x) => x)),
        "first_air_date":
            "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
        "homepage": homepage,
        "id": id,
        "languages": List<dynamic>.from(languages.map((x) => x)),
        "last_air_date":
            "${lastAirDate.year.toString().padLeft(4, '0')}-${lastAirDate.month.toString().padLeft(2, '0')}-${lastAirDate.day.toString().padLeft(2, '0')}",
        "networks": List<dynamic>.from(networks.map((x) => x.toJson())),
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "original_language": originalLanguage,
        "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
      };
}

class LastEpisodeToAir {
  DateTime airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  String productionCode;
  int seasonNumber;
  int showId;
  String stillPath;
  int voteAverage;
  int voteCount;

  LastEpisodeToAir({
    this.airDate,
    this.episodeNumber,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.seasonNumber,
    this.showId,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
  });

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) =>
      LastEpisodeToAir(
        airDate: DateTime.parse(json["air_date"]),
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        productionCode: json["production_code"],
        seasonNumber: json["season_number"],
        showId: json["show_id"],
        stillPath: json["still_path"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "air_date":
            "${airDate.year.toString().padLeft(4, '0')}-${airDate.month.toString().padLeft(2, '0')}-${airDate.day.toString().padLeft(2, '0')}",
        "episode_number": episodeNumber,
        "id": id,
        "name": name,
        "overview": overview,
        "production_code": productionCode,
        "season_number": seasonNumber,
        "show_id": showId,
        "still_path": stillPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

class Network {
  String name;
  int id;
  String logoPath;
  String originCountry;

  Network({
    this.name,
    this.id,
    this.logoPath,
    this.originCountry,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        name: json["name"],
        id: json["id"],
        logoPath: json["logo_path"] == null ? null : json["logo_path"],
        originCountry: json["origin_country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "logo_path": logoPath == null ? null : logoPath,
        "origin_country": originCountry,
      };
}

class Season {
  String airDate;
  int episodeCount;
  int id;
  String name;
  String overview;
  String posterPath;
  int seasonNumber;

  Season({
    this.airDate,
    this.episodeCount,
    this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        airDate: json["air_date"],
        episodeCount: json["episode_count"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "episode_count": episodeCount,
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath == null ? null : posterPath,
        "season_number": seasonNumber,
      };
}
