import 'dart:io';

import 'package:doc_text_extractor/doc_text_extractor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class FileService {
  Future<String?> pickAndExtractText() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final extractor = TextExtractor();

      File file = File(result.files.single.path!);
      String extension = result.files.single.extension!;
      // String fileName = result.files.single.name;

      // Map<String, String?> fileData = {
      //   'fileName': fileName,
      //   'text': null,
      // };

      if (extension == 'txt') {
        return await file.readAsString();
        // return fileData;
      } else if (extension == 'pdf') {
        try {
          return await ReadPdfText.getPDFtext(file.path);
          // return fileData;
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      } else if (extension == 'doc' || extension == 'docx') {
        try {
          final result = await extractor.extractText(file.path, isUrl: false);
          return result.text;
          // return fileData;
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      }
      return null;
    } else {
      return null;
    }
  }
}
