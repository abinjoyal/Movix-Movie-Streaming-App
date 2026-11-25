import '../models/cast_model.dart';
import '../models/movie_details_model.dart';

/// Keyless development fallback catalog used ONLY when `TMDB_API_KEY` is not yet configured.
/// Reuses the exact verified TMDB IDs and CDN paths from Home and Explore fallback lists.
class LocalMovieDetailsFallback {
  LocalMovieDetailsFallback._();

  static MovieDetailsModel? findById(int id) {
    for (final movie in _catalog) {
      if (movie.id == id) return movie;
    }
    return null;
  }

  static List<CastModel> castForMovie(MovieDetailsModel movie) {
    if (movie.director.isEmpty) return const [];
    return [
      CastModel(
        id: movie.id,
        name: movie.director,
        role: 'Director',
        profilePath: '',
        isDirector: true,
      ),
    ];
  }

  static List<SimilarMovieModel> similarFor(int movieId) {
    return _catalog
        .where((m) => m.id != movieId)
        .take(12)
        .map(_toSimilar)
        .toList();
  }

  static List<SimilarMovieModel> moviesForPerson(String? personName) {
    final query = (personName ?? '').trim().toLowerCase();
    final matched = query.isEmpty
        ? const <MovieDetailsModel>[]
        : _catalog
            .where((m) => m.director.toLowerCase() == query)
            .toList();

    final seenIds = matched.map((m) => m.id).toSet();
    final rest = _catalog.where((m) => !seenIds.contains(m.id)).take(10);
    return [...matched, ...rest].map(_toSimilar).toList();
  }

  static SimilarMovieModel _toSimilar(MovieDetailsModel m) {
    return SimilarMovieModel(
      id: m.id,
      title: m.title,
      posterPath: m.posterPath,
      backdropPath: m.backdropPath,
      voteAverage: m.voteAverage,
      releaseDate: m.releaseDate,
    );
  }

  static const List<MovieDetailsModel> _catalog = [
    MovieDetailsModel(
      id: 76600,
      title: 'Avatar: The Way of Water',
      overview:
          'Set more than a decade after the events of the first film, learn the story of the Sully family, the trouble that follows them, the lengths they go to keep each other safe, the battles they fight to stay alive, and the tragedies they endure.',
      posterPath: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      backdropPath: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg',
      voteAverage: 9.8,
      releaseDate: '2022-12-16',
      runtime: 192,
      genres: ['Action', 'Adventure', 'Science Fiction'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'James Cameron',
    ),
    MovieDetailsModel(
      id: 453395,
      title: 'Dr. Strange 2',
      overview:
          'Doctor Strange teams up with a mysterious teenage girl from his dreams who can travel across multiverses to battle multiple threats across the multiverse.',
      posterPath: '/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
      backdropPath: '/wcKFYIiVDvRURrzglV9kGu7fpfY.jpg',
      voteAverage: 9.2,
      releaseDate: '2022-05-06',
      runtime: 126,
      genres: ['Action', 'Superhero', 'Science Fiction'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Sam Raimi',
    ),
    MovieDetailsModel(
      id: 718789,
      title: 'Lightyear',
      overview:
          'Legendary Space Ranger Buzz Lightyear embarks on an intergalactic adventure alongside ambitious recruits and his robot companion Sox.',
      posterPath: '/vpILbP9eOQEtdQgl4vgjZUNY07r.jpg',
      backdropPath: '/2k9tBsv5NOtMzYVRbyeNTXpq7Al.jpg',
      voteAverage: 9.7,
      releaseDate: '2022-06-17',
      runtime: 105,
      genres: ['Animation', 'Adventure', 'Family'],
      productionCountries: ['United States'],
      certification: 'PG',
      director: 'Angus MacLane',
    ),
    MovieDetailsModel(
      id: 414906,
      title: 'The Batman',
      overview:
          'In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler.',
      posterPath: '/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      backdropPath: '/tRS6jvPM9qPrrnx2KRx3ew96Yot.jpg',
      voteAverage: 9.6,
      releaseDate: '2022-03-04',
      runtime: 176,
      genres: ['Action', 'Crime', 'Drama'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Matt Reeves',
    ),
    MovieDetailsModel(
      id: 507086,
      title: 'Jurassic World Dominion',
      overview:
          'Four years after the destruction of Isla Nublar, dinosaurs now live—and hunt—alongside humans all over the world.',
      posterPath: '/kAVRgw7GgK1CfYEJq8ME6EvRIgU.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.5,
      releaseDate: '2022-06-10',
      runtime: 147,
      genres: ['Adventure', 'Action', 'Sci-Fi'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Colin Trevorrow',
    ),
    MovieDetailsModel(
      id: 634649,
      title: 'Spider-Man: No Way Home',
      overview:
          'Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero.',
      posterPath: '/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
      backdropPath: '/4HodYYKEIsGOdinkGi2Ucz6X9i0.jpg',
      voteAverage: 9.4,
      releaseDate: '2021-12-17',
      runtime: 148,
      genres: ['Action', 'Adventure', 'Sci-Fi'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Jon Watts',
    ),
    MovieDetailsModel(
      id: 675353,
      title: 'Sonic the Hedgehog 2',
      overview:
          'After settling in Green Hills, Sonic is eager to prove he has what it takes to be a true hero.',
      posterPath: '/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg',
      backdropPath: '/egoyMDLqCflOTx1qA43yK5b9oI5.jpg',
      voteAverage: 9.2,
      releaseDate: '2022-04-08',
      runtime: 122,
      genres: ['Animation', 'Action', 'Family'],
      productionCountries: ['United States'],
      certification: 'PG',
      director: 'Jeff Fowler',
    ),
    MovieDetailsModel(
      id: 508947,
      title: 'Turning Red',
      overview:
          'Thirteen-year-old Mei poofs into a giant red panda whenever she gets too excited.',
      posterPath: '/qsdjk9oAKSQMWs0Vt5Pyfh6O4GZ.jpg',
      backdropPath: '/fOy2Jurz9k6RnJnMUMRDAgBwru2.jpg',
      voteAverage: 9.5,
      releaseDate: '2022-03-10',
      runtime: 100,
      genres: ['Animation', 'Comedy', 'Family'],
      productionCountries: ['United States'],
      certification: 'PG',
      director: 'Domee Shi',
    ),
    MovieDetailsModel(
      id: 616037,
      title: 'Thor: Love and Thunder',
      overview:
          'Thor enlists the help of Valkyrie, Korg and ex-girlfriend Jane Foster to fight Gorr the God Butcher.',
      posterPath: '/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg',
      backdropPath: '/jsoz1HlxczSuTx0mDl2h0lxy36l.jpg',
      voteAverage: 9.7,
      releaseDate: '2022-07-08',
      runtime: 119,
      genres: ['Action', 'Adventure', 'Fantasy'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Taika Waititi',
    ),
    MovieDetailsModel(
      id: 436270,
      title: 'Black Adam',
      overview:
          'Nearly 5,000 years after he was bestowed with the almighty powers of the Egyptian gods, Black Adam is freed.',
      posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
      backdropPath: '/bQXAqRx2Fgc46uCVWgoPz5L5Dtr.jpg',
      voteAverage: 9.6,
      releaseDate: '2022-10-21',
      runtime: 125,
      genres: ['Action', 'Fantasy', 'Sci-Fi'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Jaume Collet-Serra',
    ),
    MovieDetailsModel(
      id: 505642,
      title: 'Black Panther: Wakanda Forever',
      overview:
          'Queen Ramonda, Shuri, M\'Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T\'Challa\'s death.',
      posterPath: '/sv1xJUazXeYqALzczSZ3O6nkH75.jpg',
      backdropPath: '/yYrvNvt2aqS13437gh5hkj14x2v.jpg',
      voteAverage: 9.5,
      releaseDate: '2022-11-11',
      runtime: 161,
      genres: ['Action', 'Adventure', 'Sci-Fi'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Ryan Coogler',
    ),
    MovieDetailsModel(
      id: 526896,
      title: 'Morbius',
      overview:
          'Dangerously ill with a rare blood disorder, and determined to save others suffering his same fate, Dr. Morbius attempts a desperate gamble.',
      posterPath: '/6JjfSchsU6daXk2AKX8EEBjO3Fm.jpg',
      backdropPath: '/sp7MPK2Kudo4HbPWsbNXwtDCa0q.jpg',
      voteAverage: 9.4,
      releaseDate: '2022-04-01',
      runtime: 104,
      genres: ['Action', 'Sci-Fi', 'Fantasy'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Daniel Espinosa',
    ),
    MovieDetailsModel(
      id: 872585,
      title: 'Oppenheimer',
      overview:
          'The story of J. Robert Oppenheimer\'s role in the development of the atomic bomb.',
      posterPath: '/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
      backdropPath: '/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg',
      voteAverage: 9.7,
      releaseDate: '2023-07-19',
      runtime: 181,
      genres: ['Drama', 'History'],
      productionCountries: ['United States'],
      certification: '16+',
      director: 'Christopher Nolan',
    ),
    MovieDetailsModel(
      id: 19995,
      title: 'Avatar',
      overview:
          'In the 22nd century, a paraplegic Marine is dispatched to the moon Pandora.',
      posterPath: '/kyeqWdyUXW608qlYkRqosgbbJyK.jpg',
      backdropPath: '/vL5LR6WdxWPjC3U14697P14Zk9P.jpg',
      voteAverage: 9.5,
      releaseDate: '2009-12-18',
      runtime: 162,
      genres: ['Action', 'Adventure', 'Fantasy', 'Sci-Fi'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'James Cameron',
    ),
    MovieDetailsModel(
      id: 361743,
      title: 'Top Gun: Maverick',
      overview:
          'After thirty years, Maverick is pushing the envelope as a top naval aviator.',
      posterPath: '/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      backdropPath: '/odJ4hx6g6vBt4lBWKFD1tI8WS4x.jpg',
      voteAverage: 9.7,
      releaseDate: '2022-05-27',
      runtime: 131,
      genres: ['Action', 'Drama'],
      productionCountries: ['United States'],
      certification: '13+',
      director: 'Joseph Kosinski',
    ),
    MovieDetailsModel(
      id: 864116,
      title: 'Clean',
      overview:
          'Tormented by a past life, garbage man Clean attempts a quiet life.',
      posterPath: '/ynu0fCQydIcXLFLwzZWLUHKSkrZ.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.6,
      releaseDate: '2022-01-28',
      runtime: 94,
      genres: ['Action', 'Thriller', 'Crime'],
      productionCountries: ['United States'],
      certification: '16+',
      director: 'Paul Solet',
    ),
    MovieDetailsModel(
      id: 66732,
      title: 'Stranger Things',
      overview: 'When a young boy vanishes, a small town uncovers a mystery.',
      posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.8,
      releaseDate: '2022-05-27',
      runtime: 50,
      genres: ['Sci-Fi', 'Drama', 'Mystery'],
      productionCountries: ['United States'],
      certification: 'TV-14',
      director: 'The Duffer Brothers',
    ),
    MovieDetailsModel(
      id: 119051,
      title: 'Wednesday',
      overview:
          'Wednesday Addams investigates twisted mysteries at Nevermore Academy.',
      posterPath: '/9PFonBhy4cQy7Jz20NpMygczOkv.jpg',
      backdropPath: '/iHSwvRVsRyxpX7FE7GbviaDvgGZ.jpg',
      voteAverage: 9.7,
      releaseDate: '2022-11-23',
      runtime: 45,
      genres: ['Comedy', 'Mystery', 'Sci-Fi'],
      productionCountries: ['United States'],
      certification: 'TV-14',
      director: 'Tim Burton',
    ),
    MovieDetailsModel(
      id: 71446,
      title: 'Money Heist',
      overview: 'Eight thieves take hostages in the Royal Mint of Spain.',
      posterPath: '/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg',
      backdropPath: '/gFZriCkpJYsApPZEF3jhxL4yLzG.jpg',
      voteAverage: 9.6,
      releaseDate: '2021-12-03',
      runtime: 50,
      genres: ['Crime', 'Action', 'Drama'],
      productionCountries: ['Spain'],
      certification: 'TV-MA',
      director: 'Álex Pina',
    ),
    MovieDetailsModel(
      id: 71912,
      title: 'The Witcher',
      overview:
          'Geralt of Rivia, a mutated monster-hunter for hire, journeys toward his destiny.',
      posterPath: '/7vjaCdMw15FEbXyLQTVa04URsPm.jpg',
      backdropPath: '/jBJWaqoSCiARWtfV0GlqHrcdidd.jpg',
      voteAverage: 9.5,
      releaseDate: '2019-12-20',
      runtime: 60,
      genres: ['Action', 'Adventure', 'Fantasy'],
      productionCountries: ['United States'],
      certification: 'TV-MA',
      director: 'Lauren Schmidt Hissrich',
    ),
    MovieDetailsModel(
      id: 110492,
      title: 'Halo',
      overview:
          'Depicting an epic 26th-century conflict between humanity and an alien threat.',
      posterPath: '/4UmNhZCEu8Vt3byMvNxNEPyf8EY.jpg',
      backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
      voteAverage: 9.6,
      releaseDate: '2022-03-24',
      runtime: 55,
      genres: ['Sci-Fi', 'Action', 'Adventure'],
      productionCountries: ['United States'],
      certification: 'TV-14',
      director: 'Kyle Killen',
    ),
    MovieDetailsModel(
      id: 93405,
      title: 'Squid Game',
      overview:
          'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games.',
      posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
      backdropPath: '/oaGvjB0DvdhX9ar97a6Cc9Qph2W.jpg',
      voteAverage: 9.8,
      releaseDate: '2021-09-17',
      runtime: 55,
      genres: ['Action', 'Mystery', 'Drama'],
      productionCountries: ['South Korea'],
      certification: 'TV-MA',
      director: 'Hwang Dong-hyuk',
    ),
    MovieDetailsModel(
      id: 99966,
      title: 'All of Us Are Dead',
      overview:
          'A high school becomes ground zero for a zombie virus outbreak.',
      posterPath: '/pTEFqAjLd5YTsMD6NSUxV6Dq7A6.jpg',
      backdropPath: '/hPea3jqhYmngcxpsveHICLFhKcu.jpg',
      voteAverage: 9.7,
      releaseDate: '2022-01-28',
      runtime: 60,
      genres: ['Action', 'Drama', 'Horror'],
      productionCountries: ['South Korea'],
      certification: 'TV-MA',
      director: 'Lee Jae-kyoo',
    ),
    MovieDetailsModel(
      id: 94796,
      title: 'Crash Landing on You',
      overview:
          'A paragliding mishap drops a South Korean heiress into North Korea.',
      posterPath: '/fgBNLPr6mC8pxuR79ENAJY4nBmj.jpg',
      backdropPath: '/issNnZKtD56SfcP37UTzsNeyoBK.jpg',
      voteAverage: 9.7,
      releaseDate: '2019-12-14',
      runtime: 70,
      genres: ['Romance', 'Comedy', 'Drama'],
      productionCountries: ['South Korea'],
      certification: 'TV-14',
      director: 'Lee Jung-hyo',
    ),
    MovieDetailsModel(
      id: 117376,
      title: 'Vincenzo',
      overview:
          'During a visit to his motherland, a Korean-Italian mafia lawyer confronts a conglomerate.',
      posterPath: '/qbkSS1cTjT4DzIwD44bdhTuYgdT.jpg',
      backdropPath: '/gMMnf8VRg3Z98WaFmOLr9Jk8pIs.jpg',
      voteAverage: 9.6,
      releaseDate: '2021-02-20',
      runtime: 80,
      genres: ['Crime', 'Comedy', 'Drama'],
      productionCountries: ['South Korea'],
      certification: 'TV-MA',
      director: 'Kim Hee-won',
    ),
    MovieDetailsModel(
      id: 154825,
      title: 'Business Proposal',
      overview:
          'In disguise on a blind date, Ha-ri discovers her date is the CEO of her company.',
      posterPath: '/iLh7L8ZuvgdxFaM9sImyv2iKYLe.jpg',
      backdropPath: '/cengzh6wjo938X0lFvI5pYJqWk8.jpg',
      voteAverage: 9.5,
      releaseDate: '2022-02-28',
      runtime: 60,
      genres: ['Comedy', 'Romance', 'Drama'],
      productionCountries: ['South Korea'],
      certification: 'TV-14',
      director: 'Park Seon-ho',
    ),
    MovieDetailsModel(
      id: 1429,
      title: 'Attack on Titan',
      overview:
          'After his hometown is destroyed, young Eren Jaeger vows to cleanse the earth of the giant humanoids.',
      posterPath: '/rqbCbjB19amtOtFQbb3K2lgm2zv.jpg',
      backdropPath: '/mDeUmPe4MF35WWlAqj4QFX5UauJ.jpg',
      voteAverage: 9.8,
      releaseDate: '2022-01-10',
      runtime: 24,
      genres: ['Animation', 'Action', 'Fantasy'],
      productionCountries: ['Japan'],
      certification: 'TV-MA',
      director: 'Tetsurō Araki',
    ),
    MovieDetailsModel(
      id: 610150,
      title: 'Dragon Ball Super: Super Hero',
      overview:
          'The Red Ribbon Army from Goku\'s past has returned with two new androids.',
      posterPath: '/uR0FopHrAjDlG5q6PZB07a1JOva.jpg',
      backdropPath: '/xs9zz3lkLXRSL7gbNYL2WOS6WqL.jpg',
      voteAverage: 9.6,
      releaseDate: '2022-06-11',
      runtime: 100,
      genres: ['Animation', 'Action', 'Sci-Fi'],
      productionCountries: ['Japan'],
      certification: 'PG-13',
      director: 'Tetsuro Kodama',
    ),
    MovieDetailsModel(
      id: 85937,
      title: 'Demon Slayer',
      overview:
          'Tanjiro Kamado sets out to become a demon slayer to avenge his family and cure his sister.',
      posterPath: '/xUfRZu2mi8jH6SzQEJGP6tjBuYj.jpg',
      backdropPath: '/nTvM4mhqNlHIvUkI1gVnW6XP7GG.jpg',
      voteAverage: 9.8,
      releaseDate: '2022-12-05',
      runtime: 24,
      genres: ['Animation', 'Action', 'Fantasy'],
      productionCountries: ['Japan'],
      certification: 'TV-MA',
      director: 'Haruo Sotozaki',
    ),
  ];
}

