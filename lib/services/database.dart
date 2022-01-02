import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addCustomerInfoToDB(
      String customerId,
      String email,
      String customerName,
      String name,
      String photoUrl,
      String customerRole) async {
    Map<String, dynamic> customerInfoMap = {
      "email": email,
      "customerName": customerName,
      "name": name,
      "imgUrl": photoUrl,
      "customerRole": customerRole
    };
    return FirebaseFirestore.instance
        .collection("customers")
        .doc(customerId)
        .set(customerInfoMap);
  }

  Future addProductToMealToDB(String customerId, String mealId,
      String productId, String messageId, Map<String, dynamic> productMap) {
    return FirebaseFirestore.instance
        .collection("customers")
        .doc(customerId)
        .collection("meals")
        .doc(mealId)
        .collection("products")
        .doc(productId)
        .set(productMap);
  }

  Future addMealToDateDB(
      String customerId, String mealId, Map<String, dynamic> mealMap) {
    return FirebaseFirestore.instance
        .collection("customers")
        .doc(customerId)
        .collection("meals")
        .doc(mealId)
        .set(mealMap);
  }

  Future<Stream<QuerySnapshot>> getMealsByCustomerAndStartEndDate(
      String customerId, DateTime startDate, DateTime endDate) async {
    return FirebaseFirestore.instance
        .collection("customers")
        .doc(customerId)
        .collection("meals")
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy("date")
        .snapshots();
  }

/*  Future<QuerySnapshot> getClientInfo(String trainerId, String clientId) async {
    return await FirebaseFirestore.instance
        .collection("trainers")
        .doc(trainerId)
        .collection("clients")
        .where(FieldPath.documentId, whereIn: clientId)
        .get();
  }*/
}
