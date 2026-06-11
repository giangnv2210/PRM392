// movie_detail_screen.dart

import 'package:flutter/material.dart';

import 'movie.dart';

// MovieDetailScreen shows full information about one movie.
// It is StatefulWidget because the favorite button changes state.
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

// This class stores the changing state for the detail screen });

@override
State<MovieDetailScreen> createState() => _MovieDetailScreenState();

// This class stores the changing state for the detail screen.
class _MovieDetailScreenState extends State<MovieDetailScreen> {
  // Stores whether the movie is marked as favorite.
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar shows the movie title at the top.
      appBar: AppBar(title: Text(widget.movie.title)),

      // SingleChildScrollView makes the whole page scrollable.
      // This prevents overflow on small screens.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster banner section.
            buildHeroBanner(),

            const SizedBox(height: 16),

            // Title and rating section.
            buildTitleSection(),

            const SizedBox(height: 12),

            // Genre chips section.
            buildGenreChips(),

            const SizedBox(height: 16),

            // Overview text section.
            buildOverview(),

            const SizedBox(height: 16),

            // Favorite / Rate / Share buttons.
            buildActionButtons(),

            const SizedBox(height: 16),

            // Trailer list section.
            buildTrailerSection(),
          ],
        ),
      ),
    );
  }

  // Builds the large poster image at the top.
  Widget buildHeroBanner() {
    return Hero(
      tag: 'movie-poster-${widget.movie.id}',

      child: Stack(
        children: [
          // Movie poster image.
          Image.network(
            widget.movie.posterUrl,
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,

            // Fallback UI if image fails to load.
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 240,
                color: Colors.grey.shade300,
                child: const Icon(Icons.movie, size: 80),
              );
            },
          ),

          // Gradient overlay.
          // This makes text easier to read on top of the image.
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
              ),
            ),
          ),

          // Movie title on top of the image.
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              widget.movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the title and rating row.
  Widget buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [
          // Expanded allows the title to take available space.
          Expanded(
            child: Text(
              widget.movie.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const Icon(Icons.star, color: Colors.orange),

          const SizedBox(width: 4),

          Text(
            widget.movie.rating.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Builds genre chips like Action, Comedy, Sci-Fi.
  Widget buildGenreChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      // Wrap moves chips to the next line if there is not enough space.
      child: Wrap(
        spacing: 8,
        runSpacing: 8,

        // Convert each genre string into a Chip widget.
        children: widget.movie.genres.map((genre) {
          return Chip(label: Text(genre));
        }).toList(),
      ),
    );
  }

  // Builds the movie overview section.
  Widget buildOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            widget.movie.overview,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  // Builds Favorite, Rate, and Share buttons.
  Widget buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Favorite button.
          IconButtonWithLabel(
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            label: 'Favorite',

            onPressed: () {
              // setState updates the favorite value and refreshes the UI.
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),

          // Rate button.
          IconButtonWithLabel(
            icon: Icons.star_border,
            label: 'Rate',

            onPressed: () {
              // SnackBar shows a small message at the bottom.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rate button clicked')),
              );
            },
          ),

          // Share button.
          IconButtonWithLabel(
            icon: Icons.share,
            label: 'Share',

            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share button clicked')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Builds the trailer list section.
  Widget buildTrailerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trailers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // ListView.builder creates the trailer rows.
          // shrinkWrap is needed because this ListView is inside SingleChildScrollView.
          ListView.builder(
            shrinkWrap: true,

            // Disable separate scrolling for this inner ListView.
            physics: const NeverScrollableScrollPhysics(),

            itemCount: widget.movie.trailers.length,

            itemBuilder: (context, index) {
              final trailer = widget.movie.trailers[index];

              return ListTile(
                leading: const Icon(Icons.play_circle),
                title: Text(trailer.title),
                subtitle: Text(trailer.duration),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Reusable widget for action buttons with icon and label.
// This keeps the Favorite, Rate, and Share buttons clean.
class IconButtonWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const IconButtonWithLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(icon), onPressed: onPressed),

        Text(label),
      ],
    );
  }
}
