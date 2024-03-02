import 'dart:io';
import 'package:construction/common/widgets/CustomDropdownButton.dart';
import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/common/widgets/CustomTextField.dart';
import 'package:construction/common/widgets/snackbar_helper.dart';
import 'package:construction/models/post.dart';
import 'package:construction/services/postService.dart';
import 'package:construction/services/userService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name;
  double? _price;
  String? _category;
  String? _note;
  bool _isLoading = false;
  File? _picture;
  String? _pictureUrl;
  final ImagePicker _picker = ImagePicker();
  final PostService _postService = PostService();
  UserService userService = UserService();
  _selectPicture() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _picture = File(pickedFile!.path);
    });
  }

  _uploadPicture() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String fileName = Path.basename(_picture!.path);
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(_picture!);
      TaskSnapshot snapshot = await uploadTask;
      _pictureUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      setState(() {
        _isLoading = false;
        showErrorSnackBar(context, e.toString());
      });
    }
  }

  void _add() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_picture != null) {
          await _uploadPicture();
        }
        Map<String, dynamic> user = await userService.getCurrentUser();

        if (user['type'] == 'restaurant') {
          String? restaurantId = user['id'];
          await _postService.addFood(Post(
              name: _name,
              price: _price,
              picture: _pictureUrl,
              category: _category,
              restaurantId: restaurantId));

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          showErrorSnackBar(context, e.toString());
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CustomTextField(
                  keyboardType: TextInputType.text,
                  label: 'Title',
                  iconPrefix: Icons.book_rounded,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter the post title';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  keyboardType: TextInputType.multiline,
                  label: 'content',
                  iconPrefix: Icons.monetization_on,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'write here';
                    }
                    return null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),

                const SizedBox(height: 10),

                CustomDropdownButton(
                  items: const ['B', 'L', 'D', 'S'],
                  label: 'Category',
                  iconPrefix: Icons.category,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  onChanged: (value) => _category = value,
                  onSaved: (value) => _category = value,
                  selectedItem: _category,
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 10),
                // ignore: unnecessary_null_comparison
                if (_picture == null)
                  CustomIconButton(
                    label: 'Select Picture',
                    icon: Icons.image,
                    onPressed: _selectPicture,
                    isLoading: _isLoading,
                  )
                else
                  Image.file(_picture!),
                const SizedBox(height: 10.0),
                const SizedBox(height: 10.0),
                CustomIconButton(
                  label: 'Add Post',
                  icon: Icons.add,
                  onPressed: _add,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
