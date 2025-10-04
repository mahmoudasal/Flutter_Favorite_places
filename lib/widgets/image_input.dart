import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void takePic() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);

      widget.onPickImage(_selectedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      label: const Text("take pic"),
      onPressed: takePic,
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: takePic,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withAlpha(51),
            ),
          ),
      height: 250,
      alignment: Alignment.center,
      width: double.infinity,
      child: content,
    );
  }
}
