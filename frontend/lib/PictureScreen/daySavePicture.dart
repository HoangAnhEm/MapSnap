import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Model/Picture.dart';
import 'package:mapsnap_fe/Widget/accountModel.dart';
import 'package:mapsnap_fe/Widget/bottomNavigationBar.dart';
import 'package:provider/provider.dart';
import '../Manager/CURD_picture.dart';
import 'ImageScreen.dart';

class daySaveScreen extends StatefulWidget {
  const daySaveScreen({Key? key}) : super(key: key);

  @override
  State<daySaveScreen> createState() => _daySaveScreenState();
}

class _daySaveScreenState extends State<daySaveScreen> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchImagesByUserId();
    });
  }

  int currentTabIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
    print("Tab $index selected");
  }

  Future<void> fetchImagesByUserId() async {
    var accountModel = Provider.of<AccountModel>(context, listen: false);

    // Kiểm tra xem đã tải ảnh chưa
    accountModel.resetGroupedImages();
    List<Picture> images = await getInfoImages(accountModel.idUser, 'user_id');
    if (images.isNotEmpty) {
      for (var image in images) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(image.capturedAt, isUtc: true);
        String dayString = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
        // Phân nhóm ảnh theo ngày
        accountModel.addImageDay(image, dayString);
      }
    } else {
      print('Không có ảnh nào được tìm thấy.');
    }
  }



  // Hàm chuyển đến màn hình hiển thị ảnh lớn
  void navigateToImageScreen(BuildContext context, Picture picture, int dayIndex,String dayString) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(
          picture: picture,
          onDelete: (Picture path) {
            Provider.of<AccountModel>(context, listen: false)
                .removeImageDay(path, dayIndex, dayString);
          },
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    String dateTime;

    String formatDate(String dayString) {
      DateTime now = DateTime.now();
      DateTime vietnamTime = now.toUtc().add(Duration(hours: 7)); // Múi giờ Việt Nam

      // Tách các phần ngày, tháng, năm từ chuỗi
      List<String> parts = dayString.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      // Tạo đối tượng DateTime
      DateTime date = DateTime(year, month, day);

      // Kiểm tra nếu ngày nằm trong năm hiện tại
      if (date.year == vietnamTime.year) {
        // Nếu đúng, chỉ hiển thị tháng và ngày
        return '${date.day}-${date.month}';
      } else {
        // Nếu khác năm, hiển thị cả năm, tháng và ngày
        return '${date.day}-${date.month}-${date.year}';
      }
    }

    DateTime now = DateTime.now();
    DateTime vietnamTime = now.toUtc().add(Duration(hours: 7)); // Chuyển sang múi giờ UTC+7
    String nowDay = '${vietnamTime.day}-${vietnamTime.month}-${vietnamTime.year}';
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image.asset(
              'assets/Image/Background.png',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.none,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight / 80),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Hehheheh");
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.chevron_left, size: 50,),
                                ),
                              ),
                              Text('Hình ảnh', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                              Container(
                                width: 50,
                                height: 50,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: screenHeight * 4 / 5 + 15,
                          child: Consumer<AccountModel>(  // Lắng nghe thay đổi trong ImageProvider
                            builder: (context, imageProvider, child) {
                              final groupedImages = imageProvider.groupedImages;
                              final List<String> daysList = groupedImages.keys.toList();
                              return SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    for(int i = daysList.length - 1; i >= 0; i--) ...[
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                spreadRadius: 3,
                                                blurRadius: 6,
                                                offset: Offset(5, 5)
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                dateTime = (daysList[i] == nowDay) ? 'Hôm nay' : formatDate(daysList[i]),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Container(
                                              height: 2,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(height: 10,),
                                            GridView.builder(
                                              shrinkWrap: true,
                                              // reverse: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: imageProvider.groupedImages[daysList[i]]?.length,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                              ),
                                              itemBuilder: (BuildContext context, int index) {
                                                // Đảo ngược thứ tự khi hiển thị
                                                final String? imagePath = imageProvider.groupedImages[daysList[i]]?[index].link;
      
                                                return GestureDetector(
                                                  onTap: () {
                                                    navigateToImageScreen(context,imageProvider.groupedImages[daysList[i]]![index],i,daysList[i]);
                                                  },
                                                  child: Container(
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        image: DecorationImage(
                                                          image: NetworkImage(imagePath!),
                                                          fit: BoxFit.cover,
                                                        )
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 20,),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 3,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: CustomBottomNav(
                      onTabTapped: onTabTapped,
                      currentIndex: currentTabIndex,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

