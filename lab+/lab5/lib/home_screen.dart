// home_screen.dart

import 'package:flutter/material.dart';

import 'movie.dart';
import 'sample_data.dart';
import 'movie_detail_screen.dart';

// HomeScreen shows a scrollable list of movies.
// It is StatefulWidget because the search text can change.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// This class stores the changing state for HomeScreen.
class _HomeScreenState extends State<HomeScreen> {
  // Stores what the user types in the search box.
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    // Filter the movie list based on the search text.
    // If searchText is empty, all movies are shown.
    final List<Movie> filteredMovies = sampleMovies.where((movie) {
      final title = movie.title.toLowerCase();
      final search = searchText.toLowerCase();

      return title.contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),

      body: Column(
        children: [
          // Search box section.
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search movies',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),

              // This runs every time the user types.
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),

          // Expanded gives the movie list the remaining screen height.
          Expanded(
            child: ListView.builder(
              // Number of movie cards to display.
              itemCount: filteredMovies.length,

              // Builds each movie card.
              itemBuilder: (context, index) {
                final movie = filteredMovies[index];

                return MovieCard(movie: movie);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// This widget displays one movie item in the list.
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Adds space around each card.
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        // Movie poster on the left.
        leading: Hero(
          // Hero tag must match the Hero tag on the detail screen.
          // This creates a smooth transition animation.
          tag: 'movie-poster-${movie.id}',

          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,

              // Shows an icon if the image cannot load.
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.movie),
                );
              },
            ),
          ),
        ),

        // Movie title.
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        // Movie rating and genres.
        subtitle: Text('★ ${movie.rating} • ${movie.genres.join(", ")}'),

        // Arrow icon on the right.
        trailing: const Icon(Icons.chevron_right),

        // When the card is tapped, open the detail screen.
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            ),
          );
        },
      ),
    );
  }
}
