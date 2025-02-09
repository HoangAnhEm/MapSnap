
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapsnap_fe/Model/City.dart';
import 'package:mapsnap_fe/Model/Location.dart';
import 'package:mapsnap_fe/Model/LocationCategory.dart';
import '../Model/Picture.dart';
import '../Model/Posts.dart';
import '../Model/Token_2.dart';
import '../Model/User_2.dart';


// Class để quản lý các biến dùng chung
class AccountModel extends ChangeNotifier {

  // ================ Phần cho user =================================
  User? _user;
  late Token _token;


  String get avatar => _user?.avatar ?? ".....";
  String get phoneNumber => _user?.numberPhone ?? "??????";
  String get token_access => _token.token_access;
  String get token_refresh => _token.token_refresh;
  DateTime get token_refresh_expires => _token.token_access_expires;
  String get idUser => _user?.idUser ?? 'Chua co id';
  String get username => _user?.username ?? 'Chưa có tên người dùng';
  String get email => _user?.email ?? 'Chưa có email';
  String get address => _user?.address ?? 'Thêm địa chỉ';
  String get role => _user?.role ?? '.....';


  // Setter để cập nhật `User`
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners(); // Thông báo thay đổi
  }

  void setToken(Token newToken) {
    _token = newToken;
    notifyListeners(); // Thông báo thay đổi
  }


  //================== Quản lý ảnh theo ngày =====================
  Map<String, List<Picture>> _groupedImages = {};
  Map<String, List<Picture>> get groupedImages => _groupedImages;


   void resetGroupedImages() {
     _groupedImages = {};
     notifyListeners();
   }
  // Hàm lưu ảnh theo ngày
  void addImageDay(Picture image,String dayString) {
    if (_groupedImages.containsKey(dayString)) {
      _groupedImages[dayString]!.insert(0,image);
    } else {
      _groupedImages[dayString] = [image];
    }
    notifyListeners();
  }

  // Hàm lưu ảnh theo ngày
  void removeImageDay(Picture image,int dayIndex,String dayString) {
    if (dayIndex < _groupedImages.length) {
      _groupedImages[dayString]!.remove(image);
      // Nếu ngày đó không còn ảnh nào, xóa cả ngày (tuỳ chọn)
      if (_groupedImages[dayString]!.isEmpty) {
        _groupedImages.remove(dayString);
      }
      notifyListeners(); // Cập nhật giao diện
    }
  }


//================== Quản lý ảnh theo địa điểm =====================
  Map<Location,List<Picture>> _imageLocation = {};
  Map<Location,List<Picture>> get imageLocation => _imageLocation;


  // Hàm lưu ảnh theo địa điểm
  void addImageLocation(Location location, Picture picture) {
    if (_imageLocation.containsKey(location)) {
      _imageLocation[location]!.add(picture);
    } else {
      _imageLocation[location] = [picture];
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  // Hàm xóa ảnh theo địa điểm
  void removeImageLocation(Location location, Picture picture) {
    _imageLocation[location]!.remove(picture);
    if(_imageLocation[location]!.length == 0) {
      _imageLocation.remove(location);
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  void resetImageLocation() {
    _imageLocation = {};
  }

  //=========================Quản lý location================================
  Map<City,List<Location>> _locationManager = {};
  Map<City,List<Location>> get locationManager => _locationManager;

  void addLocation(City city, Location? location) {
    // Kiểm tra nếu hành trình đã tồn tại
    if (_locationManager.containsKey(city)) {
      _locationManager[city]?.insert(0, location!);
    } else if(location != null) {
      // Nếu địa điểm chưa có, tạo mới danh sách ảnh
      _locationManager[city] = [location] ;
    } else {
      _locationManager[city] = [] ;
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }


  void removeLocation(City city, Location location) {
    // Kiểm tra nếu hành trình đã tồn tại
    if (_locationManager.containsKey(city)) {
      _locationManager[city]?.remove(location);
    }
    if( _locationManager[city]!.isEmpty) {
      _locationManager.remove(city);
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  void removeCity(City city) {
    _locationManager.remove(city);
    notifyListeners();
  }

  void resetCity() {
    _locationManager = {};
    notifyListeners();
  }

  void resetLocation(City city) {
    _locationManager[city] = [];
    notifyListeners();
  }


  //=============================

  List<Location> _locationManager3 = [];
  List<Location> get locationManager3 => _locationManager3;

  void addLocation3(Location? location) {
    _locationManager3.add(location!);
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }


  void removeLocation3(Location location) {
    _locationManager3.remove(location);
    notifyListeners();
  }

  void resetLocation3() {
    _locationManager3 = [];
    notifyListeners();
  }


//===================

  Map<LocationCategory,List<Location>> _locationCategoryManager = {};
  Map<LocationCategory,List<Location>> get locationCategoryManager => _locationCategoryManager;

  void addLocationCategory(LocationCategory category, Location? location) {
    // Kiểm tra nếu hành trình đã tồn tại
    if (_locationCategoryManager.containsKey(category)) {
      _locationCategoryManager[category]?.insert(0, location!);
    } else if(location != null) {
      // Nếu địa điểm chưa có, tạo mới danh sách ảnh
      _locationCategoryManager[category] = [location] ;
    } else {
      _locationCategoryManager[category] = [] ;
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  void removeLocation2(LocationCategory category, Location location) {
    // Kiểm tra nếu hành trình đã tồn tại
    if (_locationCategoryManager.containsKey(category)) {
      _locationCategoryManager[category]?.remove(location);
    }
    if( _locationCategoryManager[category]!.isEmpty) {
      _locationCategoryManager.remove(category);
    }
    notifyListeners(); // Gọi hàm để cập nhật lại UI
  }

  void removeLocationCategory(LocationCategory locationCategory) {
    _locationCategoryManager.remove(locationCategory);
    notifyListeners();
  }


  void resetLocationCategory() {
    _locationCategoryManager = {};
    notifyListeners();
  }

  void resetLocation2(LocationCategory category) {
    _locationCategoryManager[category] = [];
    notifyListeners();
  }
  //=====================================================================
  List<Picture> _fullImage = [];
  List<Picture> get fullImage => _fullImage;

  void resetFullImage() {
    _fullImage = [];
    notifyListeners();
  }


  void addFullImage(Picture picture) {
    _fullImage.insert(0,picture);
    notifyListeners();
  }

}
