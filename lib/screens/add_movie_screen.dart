import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';

class AddMovieScreen extends StatefulWidget {
  final Function(Movie) onAddMovie;

  const AddMovieScreen({required this.onAddMovie});

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  String _category = 'Watched';
  int _rating = 5;
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_titleController.text.isEmpty) return;

    final movie = Movie(
      id: const Uuid().v4(),
      title: _titleController.text,
      category: _category,
      rating: _category == 'To Watch' ? null : _rating,
      comment: _commentController.text,
      imagePath: _imageFile?.path,
    );

    widget.onAddMovie(movie);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Movie')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _category,
              isExpanded: true,
              items: ['Watched', 'To Watch'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            SizedBox(height: 16),
            if (_category == 'Watched')
              RatingBar.builder(
                initialRating: _rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating.toInt();
                  });
                },
              ),
            SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Comment'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo),
              label: Text('Pick Image'),
            ),
            if (_imageFile != null) ...[
              SizedBox(height: 16),
              Image.file(_imageFile!, height: 200, fit: BoxFit.cover),
            ],
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save Movie'),
            ),
          ],
        ),
      ),
    );
  }
} 