import 'movie.dart';

// Static sample movie data.
final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Dune: Part Two',
    posterUrl: 'https://picsum.photos/seed/dune/600/400',
    rating: 8.6,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    overview:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge against the people who destroyed his family.',
    trailers: [
      Trailer(title: 'Official Trailer #1', duration: '2:30'),
      Trailer(title: 'IMAX Sneak Peek', duration: '1:45'),
      Trailer(title: 'Final Trailer', duration: '2:10'),
    ],
  ),

  Movie(
    id: 2,
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://picsum.photos/seed/deadpool/600/400',
    rating: 8.3,
    genres: ['Action', 'Comedy'],
    overview:
        'The multiverse gets messy when Wade Wilson teams up with Wolverine for a chaotic and funny mission.',
    trailers: [
      Trailer(title: 'Red Band Trailer', duration: '2:20'),
      Trailer(title: 'Behind the Scenes', duration: '3:05'),
      Trailer(title: 'Official Teaser', duration: '1:30'),
    ],
  ),

  Movie(
    id: 3,
    title: 'Inside Out 2',
    posterUrl: 'https://picsum.photos/seed/insideout/600/400',
    rating: 7.9,
    genres: ['Animation', 'Family', 'Comedy'],
    overview:
        'Riley enters her teenage years, and new emotions appear inside her mind, changing how she sees the world.',
    trailers: [
      Trailer(title: 'Official Trailer', duration: '2:15'),
      Trailer(title: 'Meet the Emotions', duration: '1:50'),
    ],
  ),
];
