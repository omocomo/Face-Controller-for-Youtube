import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:face_controller_for_youtube/model/carousel_item.dart';
import 'package:face_controller_for_youtube/model/photo_item.dart';
import 'package:file_picker/file_picker.dart';

var server = 'localhost'; // server 0.0.0.0

Future<String> uploadVideo() async {
    // 비디오 하나 선택
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      var video_name = result.files.single.name;
      var uploadfile = result.files.single.bytes;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: video_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://$server:8000/upload_video', data: formData);

      if (response.statusCode == 200) {
        // print(response.data['videoUrl']);
        return response.data['videoUrl'];
      }
  }
  return 'None';
}

Future<List> getGivenImage() async {
    var dio = Dio();
    final response = 
         await dio.get('http://$server:8000/given_image');
    

    if (response.statusCode == 200) {
      List given_img_list = response.data['imgList'];
      // print('given img request');
      // print(given_img_list);
      return given_img_list;
    }
    return [];
}

Future selectGivenImage(image) async {
    var dio = Dio();
    // 업로드 요청
    final response =
        await dio.post('http://$server:8000/select_given_image/' + image);
    if (response.statusCode == 200) {

    }
}

Future<String> multiSwapping() async {
    var dio = Dio();
    final response =
        await dio.post('http://$server:8000/multi_swapping',
        // onSendProgress: (count, total) {
        //    var progress = count / total;
        //    print('progress: $progress ($count/$total)');
        //   },
        // onReceiveProgress: (count, total) {
        //    var progress = count / total;
        //    print('progress: $progress ($count/$total)');
        //   },
        );

    if (response.statusCode == 200) {
        print(response.data['outputUrl']);
        return response.data['outputUrl'];
      }
    return 'None';
}

Future<String> specificSwapping(List given_images, List items) async {
    var dio = Dio();
    var formData = {
      'src_images': List.generate(
          items.length,
          ((index) => items[index].imageName.toString())),
      'dst_images': List.generate(
          items.length, 
          ((index) => given_images[items[index].getValue].toString()))
    };

    final response =
        await dio.post('http://$server:8000/get_specific_swapping', data: formData, 
        );

    if (response.statusCode == 200) {
        // print(response.data['outputUrl']);
        return response.data['outputUrl'];
      }
    return 'None';
}

Future selectImages(List<PhotoListItem> images) async {
    // print(images);
    

    var dio = Dio();
    var formData = {
      'file_names': List.generate(
        images.length,
        ((index) => images[index].imageName.toString())),
      'image_names': List.generate(
        images.length,
        ((index) => images[index].imageName.toString())),
    };

    // print(formData);

    final response =
        await dio.post('http://$server:8000/upload_images', data: formData);

    if (response.statusCode == 200) {
      // print(select_image_list);
    }

}


Future<String> getMosaic() async {
    var dio = Dio();
    final response =
        await dio.post('http://$server:8000/get_mosaic');

    if (response.statusCode == 200) {
        // print(response.data['outputUrl']);
        return response.data['outputUrl'];
    }
    return 'None';
}