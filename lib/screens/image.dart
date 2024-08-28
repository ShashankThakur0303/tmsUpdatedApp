// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// File? _imageFile;

// class Imagepick extends StatefulWidget {
//   @override
//   _ImagepickState createState() => _ImagepickState();
// }

// class _ImagepickState extends State<Imagepick> {
//   FilePickerResult? result;

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pick Image'),
//       ),
//       body: Column(
//         children: [
//           result != null
//               ? Image.file(_imageFile!)
//               // Image.file(_imageFile!,
//               //     height: 300, width: double.infinity, fit: BoxFit.cover)
//               : Container(
//                   height: 300,
//                   width: double.infinity,
//                   color: Colors.grey[300],
//                   child: Icon(Icons.image, size: 100, color: Colors.grey),
//                 ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                   onPressed: () async {
//                     result = await FilePicker.platform.pickFiles(
//                         withData: true,
//                         type: FileType.any,
//                         allowMultiple: false,
//                         allowedExtensions: null);
//                     if (result == null) {
//                       print("No file selected");
//                     } else {
//                       setState(() {});
//                       result?.files.forEach((element) {
//                         _imageFile = File(result!.files.first.path!);
//                         print(element.name);
//                       });
//                     }
//                   },
//                   child: const Text(
//                     'Pick file',
//                     style: TextStyle(fontSize: 16),
//                   )),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (await _requestGalleryPermission()) {
//                     await _pickImage(ImageSource.gallery);
//                   }
//                 },
//                 child: const Text('Pick Image from Gallery'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No image selected')),
//       );
//     }
//   }

//   Future<bool> _requestCameraPermission() async {
//     var status = await Permission.storage.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Camera permission denied')),
//       );
//       return false;
//     }
//     return true;
//   }

//   Future<bool> _requestGalleryPermission() async {
//     var status = await Permission.storage.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gallery permission denied')),
//       );
//       return false;
//     }
//     return true;
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class ImageScreen extends StatefulWidget {
  final List<dynamic> imageFiles;
  final int initialIndex;
  final String pageTitle;

  const ImageScreen({
    required this.imageFiles,
    required this.initialIndex,
    required String imageFile,
    required ticketId,
    required this.pageTitle,
  });

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text('Image'),
      ),
      body: Center(
        child: CarouselSlider.builder(
          itemCount: widget.imageFiles.length,
          options: CarouselOptions(
            initialPage: widget.initialIndex,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIdx) {
            return Container(
              child: widget.pageTitle == 'pendingPage'
                  ? PhotoView(
                      imageProvider: NetworkImage(widget.imageFiles[index]),
                      //imageProvider: FileImage(File(widget.imageFiles[index])),
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.black),
                    )
                  : PhotoView(
                      imageProvider: FileImage(File(widget.imageFiles[index])),
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.black),
                    ),
            );
          },
        ),
      ),
    );
  }
}
