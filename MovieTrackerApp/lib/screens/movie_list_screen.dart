import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/movie.dart';
import '../services/database_helper.dart';
import 'add_movie_screen.dart';
import 'movie_detail_screen.dart';
import '../theme/app_theme.dart';

class MovieListScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const MovieListScreen({required this.onThemeToggle});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Movie> toWatchMovies = [];
  List<Movie> watchedMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final fetchedMovies = await _dbHelper.fetchMovies();
    setState(() {
      toWatchMovies = fetchedMovies.where((movie) => movie.category == 'To Watch').toList();
      watchedMovies = fetchedMovies.where((movie) => movie.category == 'Watched').toList();
    });
  }

  void _openAddMovieScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMovieScreen(onAddMovie: _addMovie),
      ),
    );
  }

  void _addMovie(Movie movie) async {
    await _dbHelper.insertMovie(movie);
    _loadMovies();
  }

  void _deleteMovie(String id) async {
    await _dbHelper.deleteMovie(id);
    _loadMovies();
  }

  void _updateMovie(Movie movie) async {
    await _dbHelper.insertMovie(movie);
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Movie Tracker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: widget.onThemeToggle,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.watch_later, color: Colors.white),
                text: 'To Watch',
              ),
              Tab(
                icon: Icon(Icons.done, color: Colors.white),
                text: 'Watched',
              ),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildMovieList(toWatchMovies),
            _buildMovieList(watchedMovies),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddMovieScreen,
          label: Text(
            'Add Movie',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No movies added yet!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildMovieCard(movies[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: isDark ? AppTheme.darkCardColor : Colors.white,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(
                movie: movie,
                onMovieUpdated: _updateMovie,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (movie.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.file(
                        File(movie.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (movie.rating != null)
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < movie.rating! ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      SizedBox(height: 8),
                      Text(
                        movie.comment,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? AppTheme.darkTextSecondaryColor : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: isDark ? AppTheme.darkAccentColor : AppTheme.accentColor,
                  ),
                  onPressed: () => _showDeleteDialog(movie.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Delete Movie?'),
        content: Text('Are you sure you want to delete this movie?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteMovie(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
} 