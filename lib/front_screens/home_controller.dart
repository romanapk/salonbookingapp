import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Future<QuerySnapshot> getDoctorList() {
    return FirebaseFirestore.instance.collection('stylists').get();
  }
}
