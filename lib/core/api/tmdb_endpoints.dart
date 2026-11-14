/// TMDB API specific relative endpoint routes.
class TmdbEndpoints {
  TmdbEndpoints._();

  // Trending
  static const String trendingMoviesDay = '/trending/movie/day';
  static const String trendingMoviesWeek = '/trending/movie/week';
  static const String trendingTvDay = '/trending/tv/day';
  static const String trendingTvWeek = '/trending/tv/week';

  // Movies
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String upcomingMovies = '/movie/upcoming';
  static String movieDetails(int movieId) => '/movie/$movieId';
  static String movieCredits(int movieId) => '/movie/$movieId/credits';
  static String movieSimilar(int movieId) => '/movie/$movieId/similar';
  static String movieRecommendations(int movieId) => '/movie/$movieId/recommendations';
  static String movieVideos(int movieId) => '/movie/$movieId/videos';
  static String movieReviews(int movieId) => '/movie/$movieId/reviews';
  static String movieReleaseDates(int movieId) => '/movie/$movieId/release_dates';
  static String personMovieCredits(int personId) => '/person/$personId/movie_credits';

  // TV Shows
  static const String popularTv = '/tv/popular';
  static const String topRatedTv = '/tv/top_rated';
  static const String onTheAirTv = '/tv/on_the_air';
  static String tvDetails(int tvId) => '/tv/$tvId';

  // Search & Genres
  static const String searchMovie = '/search/movie';
  static const String searchTv = '/search/tv';
  static const String searchMulti = '/search/multi';
  static const String movieGenres = '/genre/movie/list';
  static const String tvGenres = '/genre/tv/list';
}

