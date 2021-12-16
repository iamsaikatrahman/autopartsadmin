import 'package:cloud_firestore/cloud_firestore.dart';

class CarouselModel {
  Timestamp publishedDate;
  String carouselImgUrl;
  String carouselId;
  CarouselModel({
    this.publishedDate,
    this.carouselImgUrl,
    this.carouselId,
  });

  CarouselModel.fromJson(Map<String, dynamic> json) {
    publishedDate = json['publishedDate'];
    carouselImgUrl = json['carouselImgUrl'];
    carouselId = json['carouselId'];
    
  }
  CarouselModel.fromSnaphot(DocumentSnapshot snapshot) {
    publishedDate = snapshot.data()['publishedDate'];
    carouselImgUrl = snapshot.data()['carouselImgUrl'];
    carouselId = snapshot.data()['carouselId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publishedDate'] = this.publishedDate;
    data['carouselImgUrl'] = this.carouselImgUrl;
    data['carouselId'] = this.carouselId;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
