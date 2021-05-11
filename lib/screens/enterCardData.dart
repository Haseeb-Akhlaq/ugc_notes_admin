// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
//
// class EnterCardData extends StatefulWidget {
//   final Function saveData;
//
//   const EnterCardData({this.saveData});
//   @override
//   _EnterCardDataState createState() => _EnterCardDataState();
// }
//
// class _EnterCardDataState extends State<EnterCardData> {
//   bool isUploading = false;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   String _imageURL = '';
//   String heading1 = '';
//   String cardContent1 = '';
//   String heading2 = '';
//   String cardContent2 = '';
//
//   File _image;
//   final picker = ImagePicker();
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         isUploading = true;
//       });
//
//       _image = File(pickedFile.path);
//       String fileName = basename(pickedFile.path);
//
//       final firebaseStorageRef =
//           FirebaseStorage.instance.ref().child('cardPics/$fileName');
//
//       final uploadTask = firebaseStorageRef.putFile(_image);
//
//       final taskSnapshot =
//           await uploadTask.whenComplete(() => print('image uploaded'));
//
//       uploadTask.asStream().listen((event) {
//         print('wqdddddd');
//         print(event.bytesTransferred / event.totalBytes);
//       });
//
//       taskSnapshot.ref.getDownloadURL().then(
//         (value) {
//           setState(() {
//             _imageURL = value;
//             print("Done: $value");
//             isUploading = false;
//           });
//         },
//       );
//     } else {
//       print('No image selected.');
//     }
//   }
//
//   saveData(BuildContext context) {
//     bool isValid = _formKey.currentState.validate();
//
//     if (!isValid) {
//       return;
//     }
//
//     _formKey.currentState.save();
//
//     widget.saveData(_imageURL, heading1, cardContent1, heading2, cardContent2);
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter Card Data'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.center,
//                               height: 130,
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.black)),
//                               child: isUploading
//                                   ? CircularProgressIndicator()
//                                   : _image == null
//                                       ? Text('No image')
//                                       : Image.file(_image),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               getImage();
//                             },
//                             child: Text(
//                               'Pick Image For Card',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '(Optional)',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 8,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Heading 1 (Optional)'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             textAlign: TextAlign.left,
//                             maxLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Heading',
//                               border: InputBorder.none,
//                             ),
//                             onSaved: (value) {
//                               heading1 = value;
//                             },
//                             validator: (String value) {
//                               if (value.length > 35) {
//                                 return 'Heading should not be greater than 15 characters';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Content 1'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             textAlign: TextAlign.left,
//                             maxLines: 5,
//                             decoration: InputDecoration(
//                               hintText: 'Card Content',
//                               border: InputBorder.none,
//                             ),
//                             onSaved: (value) {
//                               cardContent1 = value;
//                             },
//                             validator: (String value) {
//                               if (value.isEmpty) {
//                                 return 'Please enter valid Card Content';
//                               }
//                               if (value.length < 4) {
//                                 return 'Please Enter Content greater than 4 characters';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       Text('Heading 2 (Optional)'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             textAlign: TextAlign.left,
//                             maxLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Heading',
//                               border: InputBorder.none,
//                             ),
//                             onSaved: (value) {
//                               heading2 = value;
//                             },
//                             validator: (String value) {
//                               if (value.length > 35) {
//                                 return 'Heading should not be greater than 15 characters';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Content 2 (Optional)'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             textAlign: TextAlign.left,
//                             maxLines: 5,
//                             decoration: InputDecoration(
//                               hintText: 'Card Content',
//                               border: InputBorder.none,
//                             ),
//                             onSaved: (value) {
//                               cardContent2 = value;
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               isUploading
//                   ? Container()
//                   : GestureDetector(
//                       onTap: () {
//                         saveData(context);
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width * 0.8,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.blue,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Text(
//                             'Add Card',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
