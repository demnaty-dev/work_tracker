import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../profile/services/profile_service.dart';
import '../../Authentication/models/user_model.dart';
import '../../../common_widgets/old_text_field.dart';
import '../../../constants/palette.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit-profile';

  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late FutureOr<UserModel?> _userModel;

  File? _pickedImage;
  String? _displayName;
  String? _phone;

  Future<void> _tryUpdateProfile(VoidCallback onSuccess) async {
    if (_formKey.currentState == null) return;

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);
      final user = _userModel as UserModel;
      if (_pickedImage != null || _displayName != user.displayName || _phone != user.phone) {
        try {
          await context.read<ProfileService?>()!.updateUser(
                user,
                _pickedImage,
                _displayName!,
                _phone!,
              );
        } catch (err) {
          debugPrint('_________________________err_________________________');
        }
      }
      onSuccess();
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (image == null) return;
    setState(() {
      _pickedImage = File(image.path);
    });
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (image == null) return;
    setState(() {
      _pickedImage = File(image.path);
    });
  }

  Widget _buildUI(UserModel? user) {
    if (user == null) {
      return const Center(
        child: Text('empty'),
      );
    }

    ImageProvider image;

    if (_pickedImage != null) {
      image = FileImage(_pickedImage!);
    } else if (user.photoUrl.startsWith('assets')) {
      image = AssetImage(user.photoUrl);
    } else {
      image = NetworkImage(user.photoUrl);
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: image,
            radius: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _pickImageFromGallery,
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
              ),
              const SizedBox(width: 30),
              TextButton.icon(
                onPressed: _pickImageFromCamera,
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
              ),
            ],
          ),
          const SizedBox(height: 50),
          OldTextField(
            placeholder: 'Full name',
            text: user.displayName,
            onSaved: (value) {
              _displayName = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please provide a full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          OldTextField(
            placeholder: 'Phone',
            text: user.phone,
            keyboardType: TextInputType.phone,
            onSaved: (value) {
              _phone = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please provide a phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFutureUI() {
    return FutureBuilder<UserModel?>(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return _buildUI(snapshot.data);
        }
      },
      future: _userModel as Future<UserModel?>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profSer = context.read<ProfileService?>()!;
    if (profSer.userModel == null) {
      _userModel = profSer.userFromFirebase();
    } else {
      _userModel = profSer.userModel!;
    }

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 63,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'cancel',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Edit Profile',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline6,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : InkWell(
                              onTap: () => _tryUpdateProfile(() => Navigator.pop(context)),
                              child: const Text(
                                'save',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: _userModel is Future ? _buildFutureUI() : _buildUI(_userModel as UserModel?),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
