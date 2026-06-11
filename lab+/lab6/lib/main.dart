import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// Simple model class for one movie item.
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = <Movie>[
  Movie(
    title: 'Dune: Part Two',
    year: 2024,
    genres: <String>['Sci-Fi', 'Drama', 'Adventure'],
    posterUrl: 'https://picsum.photos/seed/dune2/400/600',
    rating: 8.6,
  ),
  Movie(
    title: 'Inside Out 2',
    year: 2024,
    genres: <String>['Animation', 'Comedy', 'Family'],
    posterUrl: 'https://picsum.photos/seed/insideout2/400/600',
    rating: 7.9,
  ),
  Movie(
    title: 'The Batman',
    year: 2022,
    genres: <String>['Action', 'Crime', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/batman/400/600',
    rating: 8.0,
  ),
  Movie(
    title: 'Barbie',
    year: 2023,
    genres: <String>['Comedy', 'Fantasy'],
    posterUrl: 'https://picsum.photos/seed/barbie/400/600',
    rating: 7.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: <String>['Sci-Fi', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/interstellar/400/600',
    rating: 8.7,
  ),
  Movie(
    title: 'Top Gun: Maverick',
    year: 2022,
    genres: <String>['Action', 'Adventure'],
    posterUrl: 'https://picsum.photos/seed/topgun/400/600',
    rating: 8.2,
  ),
];

const List<String> allGenres = <String>[
  'Action',
  'Adventure',
  'Animation',
  'Comedy',
  'Crime',
  'Drama',
  'Family',
  'Fantasy',
  'Sci-Fi',
];

enum SortOption { az, za, year, rating }

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 6 Responsive Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF244B7A)),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  final Set<String> selectedGenres = <String>{};
  SortOption selectedSort = SortOption.az;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final List<Movie> visibleMovies = _buildVisibleMovies();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width >= 800 ? 24 : 16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isWide = constraints.maxWidth >= 800;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeroSection(isWide: isWide),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildGenreSection(),
                  const SizedBox(height: 16),
                  _buildSortBar(visibleMovies.length),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder:
                          (
                            BuildContext context,
                            BoxConstraints listConstraints,
                          ) {
                            final bool useGrid =
                                listConstraints.maxWidth >= 800;

                            if (visibleMovies.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No movies match the current filters.',
                                ),
                              );
                            }

                            if (useGrid) {
                              return GridView.builder(
                                itemCount: visibleMovies.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 2.1,
                                    ),
                                itemBuilder: (BuildContext context, int index) {
                                  return MovieCard(movie: visibleMovies[index]);
                                },
                              );
                            }

                            return ListView.separated(
                              itemCount: visibleMovies.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 12),
                              itemBuilder: (BuildContext context, int index) {
                                return MovieCard(movie: visibleMovies[index]);
                              },
                            );
                          },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // This function applies search, genre filtering, and sorting.
  List<Movie> _buildVisibleMovies() {
    final List<Movie> movies = allMovies.where((Movie movie) {
      final bool matchesSearch = movie.title.toLowerCase().contains(
        searchQuery.trim().toLowerCase(),
      );

      final bool matchesGenres =
          selectedGenres.isEmpty ||
          movie.genres.any((String genre) => selectedGenres.contains(genre));

      return matchesSearch && matchesGenres;
    }).toList();

    switch (selectedSort) {
      case SortOption.az:
        movies.sort((Movie a, Movie b) => a.title.compareTo(b.title));
      case SortOption.za:
        movies.sort((Movie a, Movie b) => b.title.compareTo(a.title));
      case SortOption.year:
        movies.sort((Movie a, Movie b) => b.year.compareTo(a.year));
      case SortOption.rating:
        movies.sort((Movie a, Movie b) => b.rating.compareTo(a.rating));
    }

    return movies;
  }

  Widget _buildHeroSection({required bool isWide}) {
    final Widget textSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Find a Movie',
          style: TextStyle(
            fontSize: isWide ? 34 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Search titles, tap genres, and switch layouts automatically on wider screens.',
        ),
      ],
    );

    final Widget artCard = Container(
      width: isWide ? 220 : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.movie_filter_rounded, size: 40),
          SizedBox(width: 12),
          Expanded(child: Text('Responsive layout changes at 800px width.')),
        ],
      ),
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: textSection),
          const SizedBox(width: 20),
          artCard,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[textSection, const SizedBox(height: 16), artCard],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by title or keyword',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (String value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  Widget _buildGenreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Text(
              'Genres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            if (selectedGenres.isNotEmpty)
              Chip(label: Text('${selectedGenres.length} selected')),
            const Spacer(),
            TextButton(
              onPressed: selectedGenres.isEmpty && searchQuery.isEmpty
                  ? null
                  : () {
                      setState(() {
                        searchQuery = '';
                        selectedGenres.clear();
                        selectedSort = SortOption.az;
                      });
                    },
              child: const Text('Clear filters'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allGenres.map((String genre) {
            return FilterChip(
              label: Text(genre),
              selected: selectedGenres.contains(genre),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedGenres.add(genre);
                  } else {
                    selectedGenres.remove(genre);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortBar(int count) {
    return Row(
      children: <Widget>[
        Expanded(child: Text('$count movie(s) found')),
        const SizedBox(width: 12),
        DropdownButton<SortOption>(
          value: selectedSort,
          onChanged: (SortOption? value) {
            if (value == null) {
              return;
            }

            setState(() {
              selectedSort = value;
            });
          },
          items: const <DropdownMenuItem<SortOption>>[
            DropdownMenuItem(value: SortOption.az, child: Text('A-Z')),
            DropdownMenuItem(value: SortOption.za, child: Text('Z-A')),
            DropdownMenuItem(value: SortOption.year, child: Text('Year')),
            DropdownMenuItem(value: SortOption.rating, child: Text('Rating')),
          ],
        ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double posterWidth = constraints.maxWidth < 420 ? 92 : 120;
          final double posterHeight = constraints.maxWidth < 420 ? 140 : 170;

          return Row(
            children: <Widget>[
              Image.network(
                movie.posterUrl,
                width: posterWidth,
                height: posterHeight,
                fit: BoxFit.cover,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) => Container(
                      width: posterWidth,
                      height: posterHeight,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Year: ${movie.year}'),
                      const SizedBox(height: 6),
                      Text('Genres: ${movie.genres.join(', ')}'),
                      const SizedBox(height: 6),
                      Text('Rating: ${movie.rating.toStringAsFixed(1)} / 10'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
