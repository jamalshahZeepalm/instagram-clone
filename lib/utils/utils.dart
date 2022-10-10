import 'package:image_picker/image_picker.dart';

Future pickerImages(ImageSource source) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }

  
}
