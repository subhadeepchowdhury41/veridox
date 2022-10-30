import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_providers/form_provider.dart';
import '../app_services/database/uploader.dart';
import '../app_utils/app_constants.dart';
import 'image_upload.dart';

class FormImageInput extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const FormImageInput({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<FormImageInput> createState() => _FormImageInputState();
}

class _FormImageInputState extends State<FormImageInput>
    with AutomaticKeepAliveClientMixin {
  final List<Uint8List> _imageFileList = [];
  final List<String> _imageFileListPaths = [];
  String appBarTitle = " length ";

  Future<void> _addImageToList(List<Uint8List> image) async {
    int j = 0;
    for (int i = _imageFileList.length; i < 3 && j < image.length; i++) {
      _imageFileList.add(image[j++]);

      _addImage(image[j - 1], i);
    }
  }

  Future<void> _addImage(Uint8List image, int index) async {
    String _dbPath =
        '${widget.provider.assignmentId}/${widget.pageId},${widget.fieldId}/${index}';
    UploadTask? task =
        await FileUploader.uploadFile(dbPath: _dbPath, fileData: image);

    if (task != null) {
      _imageFileListPaths.add(_dbPath);
      widget.provider.updateData(
        pageId: widget.pageId,
        fieldId: widget.fieldId,
        value: _imageFileListPaths,
      );
    }
  }

  Future<void> _deleteImage(int index) async {
    /// todo: delete image from database

    String _dbPath =
        '${widget.provider.assignmentId}/${widget.pageId},${widget.fieldId}/${index}';

    try {
      await FirebaseStorage.instance.ref(_dbPath).delete();
      setState(() {
        _imageFileList.removeAt(index);
        _imageFileListPaths.removeAt(index);
      });
    } catch (e) {
      return;
    } finally {
      widget.provider.updateData(
        pageId: widget.pageId,
        fieldId: widget.fieldId,
        value: _imageFileListPaths,
      );
    }
  }

  void setAppBarTitle(String path) {
    appBarTitle = _imageFileList.length as String;
  }

  int _getCrossAxisCount() {
    try {
      Size size = MediaQuery.of(context).size;
      // double height = size.height;
      double width = size.width;
      int count = width ~/ 120;
      return count;
    } catch (e) {
      return 4;
    }
  }

  Future<void> _setInitialImagesData() async {
    dynamic listOfImagesFromDatabase =
        widget.provider.getResult['${widget.pageId},${widget.fieldId}'];

    if (listOfImagesFromDatabase != null &&
        listOfImagesFromDatabase.isNotEmpty) {
      // todo: check the length of the list if it 3 or more
      for (String stref in listOfImagesFromDatabase) {
        _imageFileListPaths.add(stref);
      }
      for (String path in _imageFileListPaths) {
        var image = await FirebaseStorage.instance.ref(path).getData();
        if (image != null) {
          _imageFileList.add(image);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String _getLabel() {
    String label = widget.widgetJson['label'];

    if (widget.widgetJson.containsKey('required') &&
        widget.widgetJson['required'] == true) {
      label += '*';
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: containerElevationDecoration,
      child: FutureBuilder(
          future: _setInitialImagesData(),
          builder: (context, AsyncSnapshot<void> form) {
            if (form.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return FormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: _imageFileList,
                validator: (list) {
                  if (widget.widgetJson.containsKey('required') &&
                      widget.widgetJson['required'] == true &&
                      _imageFileList.isEmpty) {
                    return 'Please add some images';
                  }
                  return null;
                },
                builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getLabel(),
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _imageFileList.length + 1,
                        gridDelegate:
                            // crossAxisCount stands for number of columns you want for displaying
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(),
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          if (index <= 2) {
                            if (index == _imageFileList.length) {
                              /// give option to add images
                              return Container(
                                height: 400,
                                width: 400,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: const Offset(0.0, 2.5), //(x,y)
                                      blurRadius: 3.5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.add_a_photo_outlined,
                                        size: 24),
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return const ImagePickerImageInput(
                                          title: "Image",
                                        );
                                      })).then((value) async {
                                        if (value != null) {
                                          debugPrint(
                                              'we got images ${value.length}');
                                          await _addImageToList(value);
                                          formState.didChange(_imageFileList);
                                        }
                                      });
                                      setState(() {
                                        appBarTitle =
                                            _imageFileList.length.toString();
                                      });
                                    },
                                  ),
                                ),
                              );
                            } else {
                              /// display images
                              return Container(
                                height: 200,
                                width: 200,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: const Offset(0.0, 2.5), //(x,y)
                                      blurRadius: 3.5,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        _imageFileList[index],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () async {
                                          await _deleteImage(index);
                                          // setState(() {
                                          //   _imageFileList.removeAt(index);
                                          // });
                                          formState.didChange(_imageFileList);
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                      if (formState.hasError)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: CupertinoColors.systemRed,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                formState.errorText!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: CupertinoColors.systemRed,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              );
            }
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
