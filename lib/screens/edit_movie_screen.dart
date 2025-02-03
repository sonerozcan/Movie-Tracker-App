import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';

class EditMovieScreen extends StatefulWidget {
  final Movie movie;

  const EditMovieScreen({required this.movie});

  @override
  _EditMovieScreenState createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  late TextEditingController _titleController;
  late TextEditingController _commentController;
  late String _category;
  late int _rating;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie.title);
    _commentController = TextEditingController(text: widget.movie.comment);
    _category = widget.movie.category;
    _rating = widget.movie.rating ?? 5;
    if (widget.movie.imagePath != null) {
      _imageFile = File(widget.movie.imagePath!);
    }
  }

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

    final updatedMovie = Movie(
      id: widget.movie.id,
      title: _titleController.text,
      category: _category,
      rating: _category == 'To Watch' ? null : _rating,
      comment: _commentController.text,
      imagePath: _imageFile?.path,
      dateAdded: widget.movie.dateAdded,
    );

    Navigator.pop(context, updatedMovie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Movie'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
              label: Text('Change Image'),
            ),
            if (_imageFile != null) ...[
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _imageFile!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }
} 