import 'package:dio/dio.dart';
import 'package:face_controller_for_youtube/model/carousel_item.dart';
import 'package:face_controller_for_youtube/model/photo_item.dart';
import 'package:face_controller_for_youtube/routes/requests.dart';
import 'package:face_controller_for_youtube/widgets/carousel.dart';
import 'package:face_controller_for_youtube/widgets/carousel_list_item.dart';
import 'package:face_controller_for_youtube/widgets/chewie_list_item.dart';
import 'package:face_controller_for_youtube/widgets/heading.dart';
import 'package:face_controller_for_youtube/widgets/photo_list_item.dart';
import 'package:face_controller_for_youtube/widgets/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



/////////////////////////////////////////
/////////////// 얼굴바꾸기 //////////////
/////////////////////////////////////////

class ChangeContents extends StatefulWidget {
  @override
  _ChangeContentsState createState() => _ChangeContentsState();
}

class _ChangeContentsState extends State<ChangeContents> {
  // 모든 얼굴 바꾸기 parameter
  String all_video_path = '';
  bool all_video_visibility = false;
  String all_result_path = '';
  bool all_result_visibility = false;
  bool all_is_loading = false;
  int selct_given_image = 0; // 선택한 DST 이미지
  
  // 특정 얼굴 바꾸기 parameter
  String spf_video_path = '';
  bool spf_video_visibility = false;
  String spf_result_path = '';
  bool spf_result_visibility = false;
  bool spf_is_loading = false;

  // 주어진 DST 이미지 
  List given_images = [];
  
  // 특정 얼굴 바꾸기 업로드 items
  final listKey = GlobalKey<AnimatedListState>();
  final List<CarouselListItem> items = List.from([]);

  @override
  void initState() {
    super.initState();
    getGivenImage().then((value) => setState(() => given_images = value)); // DST 이미지 받아오기
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Heading(title: "모든 얼굴 바꾸기", subtitle: "모든 인물의 얼굴을 바꿉니다", screenSize: screenSize),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () { 
            setState(() {
              all_video_visibility = false;
            });
            uploadVideo().then((value) { 
              setState((){
                all_video_path = value; 
                all_video_visibility = true; 
                // print(all_video_path); 
              });
            });
          },
          child: Text(
            "동영상 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Container(
            child: Visibility(
              visible: all_video_visibility,
              child: ChewieListItem(
                  videoPlayerController: VideoPlayerController.asset(all_video_path),
                  looping: false,
              )
            ),
            width: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5
                : screenSize.width / 1.5,
            height: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5 / 16 * 9
                : screenSize.width / 1.5 / 16 * 9,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Visibility(
          visible: true,
          child: Text(
            "어떤 얼굴로 바꾸실 건가요?"
          ),
        ),
        SizedBox(
          height: 10,
        ),
        DestinationCarousel(
          images: given_images,
          selectValueCallback: (v) {
            setState(() {
              selct_given_image = v;
            });
          },
          initSelectValue: 0,
        ),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              all_is_loading = true;
              all_result_visibility = false;
            });
            // print(selct_given_image);
            selectGivenImage(given_images[selct_given_image]);
            multiSwapping().then((value) => { 
              setState(() {
                all_result_path = value; 
                all_result_visibility = true; 
                all_is_loading = false;
              })
            });
          },
          child: Text(
            "CONVERT",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Container(
            child: !all_is_loading? Visibility(
              visible: all_result_visibility,
              child: ChewieListItem(
                  videoPlayerController: VideoPlayerController.asset(all_result_path),
                  looping: true,
                ),
            ): Center(child: CircularProgressIndicator()),
            width: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5
                : screenSize.width / 1.5,
            height: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5 / 16 * 9
                : screenSize.width / 1.5 / 16 * 9,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),

        Heading(title: "특정 얼굴 바꾸기", subtitle: "특정 인물의 얼굴을 바꿉니다", screenSize: screenSize),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () { 
            setState(() {
              spf_video_visibility = false;
            });
            uploadVideo().then((value) { 
              setState((){ 
                spf_video_path = value; 
                spf_video_visibility = true; 
                // print(spf_video_path);
              });
            });
          },
          child: Text(
            "동영상 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Container(
              child: Visibility(
                visible: spf_video_visibility,
                child: ChewieListItem(
                    videoPlayerController: VideoPlayerController.asset(spf_video_path),
                    looping: true,
                  ),
              ),
              width: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5
                  : screenSize.width / 1.5,
              height: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5 / 16 * 9
                  : screenSize.width / 1.5 / 16 * 9,
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
            ),
          ),
        SizedBox(
          height: 40,
        ),
        Visibility(
          visible: true,
          child: Text(
            "어떤 얼굴을 바꾸실 건가요?"
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () {insertItem();},
          child: Text(
            "사진 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: AnimatedList(
            key: listKey,
            initialItemCount: items.length,
            itemBuilder: ((context, index, animation) => CarouselListItemWidget(
              images: given_images,
              item: items[index],
              animation: animation,
              onClicked: () => removeItem(index),
            )),
        ),),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              spf_is_loading = true;
              spf_result_visibility = false;
            });
            specificSwapping(given_images, items).then((value) => { 
              setState(() {
                spf_result_path = value; 
                spf_result_visibility = true; 
                spf_is_loading = false;
              })
            });
          },
          child: Text(
            "CONVERT",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Container(
            child: !spf_is_loading? Visibility(
              visible: spf_result_visibility,
              child: ChewieListItem(
                  videoPlayerController: VideoPlayerController.asset(spf_result_path),
                  looping: true,
                ),
            ): Center(child: CircularProgressIndicator()),
            width: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5
                : screenSize.width / 1.5,
            height: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5 / 16 * 9
                : screenSize.width / 1.5 / 16 * 9,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),
        SizedBox(height: screenSize.height / 10),
      ]
    );
  }

  void removeItem(int index) {
    final removedItem = items[index];
    items.removeAt(index);

    listKey.currentState!.removeItem(
      index,
      (context, animation) => CarouselListItemWidget(
        images: given_images,
        item: removedItem, 
        animation: animation, 
        onClicked: (){},
        )
      );
  }

  Future<void> insertItem() async {
    var select_image_path = '';
    var image_name = '';

    // 이미지 하나 선택
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      image_name = result.files.single.name;
      var uploadfile = result.files.single.bytes;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: image_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://$server:8000/upload_image', data: formData);

      if (response.statusCode == 200) {
        select_image_path = response.data['imgUrl'];
        // print(response.data['imgUrl']);
      }
      
    }
      
    final newIndex = 0; // listItems.length;
    final newItem = CarouselListItem(imageName: image_name, urlImage: select_image_path, selectIndex: 0);
    
    items.insert(newIndex, newItem);
    listKey.currentState!.insertItem(
      newIndex,
    );
  }
}



/////////////////////////////////////////
///////////////  모자이크  //////////////
/////////////////////////////////////////

class MosaicContents extends StatefulWidget {
  @override
  _MosaicContentsState createState() => _MosaicContentsState();
}

class _MosaicContentsState extends State<MosaicContents> {
  // 얼굴 모자이크 parameter
  String msc_video_path = '';
  bool msc_video_visibility = false;
  String msc_result_path = '';
  bool msc_result_visibility = false;
  bool msc_is_loading = false;

  // 특정 얼굴 바꾸기 업로드 items
  final listKey = GlobalKey<AnimatedListState>();
  final List<PhotoListItem> items = List.from([]);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Heading(title: "얼굴 모자이크하기", subtitle: "특정 인물을 제외한 나머지 얼굴을 모자이크합니다", screenSize: screenSize),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              msc_video_visibility = false;
            });
            uploadVideo().then((value) { 
              setState((){
                msc_video_path = value; 
                msc_video_visibility = true; 
                // print(msc_video_path); 
              });
            });
          },
          child: Text(
            "동영상 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
            child: Container(
              child: Visibility(
                visible: msc_video_visibility,
                child: ChewieListItem(
                    videoPlayerController: VideoPlayerController.asset(msc_video_path),
                    looping: true,
                ),
              ),
              width: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5
                  : screenSize.width / 1.5,
              height: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5 / 16 * 9
                  : screenSize.width / 1.5 / 16 * 9,
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
            ),
          ),
        SizedBox(
          height: 40,
        ),
        Visibility(
          visible: true,
          child: Text(
            "어떤 얼굴을 모자이크하지 않을 건가요?"
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () {insertItem();},
          child: Text(
            "사진 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: AnimatedList(
            key: listKey,
            initialItemCount: items.length,
            itemBuilder: ((context, index, animation) => PhotoListItemWidget(
              item: items[index],
              animation: animation,
              onClicked: () => removeItem(index),
            )),
        ),),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              msc_is_loading = true;
              msc_result_visibility = false;
            });
            selectImages(items);
            getMosaic().then((value) => { 
              setState(() {
                msc_result_path = value; 
                msc_result_visibility = true; 
                msc_is_loading = false;
              })
            });
          },
          child: Text(
            "CONVERT",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Container(
            child: !msc_is_loading? Visibility(
              visible: msc_result_visibility,
              child: ChewieListItem(
                  videoPlayerController: VideoPlayerController.asset(msc_result_path),
                  looping: true,
                ),
            ): Center(child: CircularProgressIndicator()),
            width: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5
                : screenSize.width / 1.5,
            height: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5 / 16 * 9
                : screenSize.width / 1.5 / 16 * 9,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),
        SizedBox(height: screenSize.height / 10),
      ]
    );
  }

  void removeItem(int index) {
    final removedItem = items[index];
    items.removeAt(index);

    listKey.currentState!.removeItem(
      index,
      (context, animation) => PhotoListItemWidget(
        item: removedItem, 
        animation: animation, 
        onClicked: (){},
        )
      );
  }

  Future<void> insertItem() async {
    var select_image_path = '';
    var image_name = '';

    // 이미지 하나 선택
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      image_name = result.files.single.name;
      var uploadfile = result.files.single.bytes;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: image_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://$server:8000/upload_image', data: formData);

      if (response.statusCode == 200) {
        select_image_path = response.data['imgUrl'];
        // print(response.data['imgUrl']);
      }
    }
      
    final newIndex = 0; // listItems.length;
    final newItem = PhotoListItem(imageName: image_name, urlImage: select_image_path);
    
    items.insert(newIndex, newItem);
    listKey.currentState!.insertItem(
      newIndex,
    );
  }

}