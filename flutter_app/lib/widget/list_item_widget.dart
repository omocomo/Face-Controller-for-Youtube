import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../data/list_items.dart';
import '../model/list_item.dart';

class ListItemWidget extends StatelessWidget {
  final ListItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  const ListItemWidget({
    required this.item,
    required this.animation,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizeTransition(
    key: ValueKey(item.urlImage),
    sizeFactor: animation,
    child: buildItem(),
  );

  Widget buildItem() => Container(
    height: 200,
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.blue,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      
      children: [
        Container(
          width: 200,
          child: Image.network(item.urlImage),
        ),
        SizedBox(width: 20),
        Container(
          width: 400,
          child: CarouselSlider(
            items: 
              given_img_list.map((imgName) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: 200, //MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image.network(
                        'http://localhost:8000/DATA/given/$imgName', fit: BoxFit.fitHeight), 
                    );
                  },
                );
              }).toList(),
            options: CarouselOptions(
              height: 200.0,
              initialPage: 0,
              onPageChanged: (index, e) => (item.selectValue = index)
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red, size: 32), 
          onPressed: onClicked,
        ),
      ]
    )
    
    // ListTile(
    //   contentPadding: EdgeInsets.all(16),
    //   leading: CircleAvatar(
    //     radius: 32,
    //     backgroundImage: NetworkImage(item.urlImage),
    //   ),
    //   title: Text(
    //     item.title,
    //     style: TextStyle(
    //       fontSize: 20, color: Colors.black),
    //     ),
    //     trailing: IconButton(
    //       icon: Icon(Icons.delete, color: Colors.red, size: 32), 
    //       onPressed: onClicked,
    //     ),
    //   ),
    );
}