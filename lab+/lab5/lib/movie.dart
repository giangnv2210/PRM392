class Trailer {
  final String title;
  final String duration;

  // Constructor for Trailer.
  // required means the value must be provided when creating a Trailer.
  const Trailer({required this.title, required this.duration});
}

// This class represents one movie.
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;

  //constructor for Movie.
  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}
