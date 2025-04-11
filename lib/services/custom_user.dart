import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class CustomUser {

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createUserCollectionIfNotExists() async {

    final snapshot = await db.collection('users').doc(user!.uid).get();
    
    if(snapshot.data() == null) {

      final userDoc = db.collection('users').doc(user!.uid);

      await userDoc.set({
        'phone': user!.phoneNumber ?? '',
        'displayName': user!.displayName ?? '',
        'email': user!.email ?? '',
        'address': '',
        'documentId': '',
        'createdAt': Timestamp.now()
      });

    } else {
      print("Already exists");
    }
  }

  Future<dynamic> getUser() async {

    await createUserCollectionIfNotExists();
    
    try {

      final customUser = await db.collection('users').doc(user!.uid).get().then((doc) => doc.data() as Map<String, dynamic>);

      print("USER: $customUser");

      return customUser;

    } catch(e) {
      print("ERROR getting user: $e");
    }
  }


  Future<void> updateDisplayName(String newName) async {

    try {

      await db.collection('users').doc(user!.uid).update({
        'displayName': newName,
        'updatedAt': Timestamp.now(),
      });

      await user!.updateDisplayName(newName);

    } catch(e) {
      print("ERROR: $e");
    }

  }


  Future<void> updateDocumentId(String newDocumentId) async {

    try {
      await db.collection('users').doc(user!.uid).update({
        'documentId': newDocumentId,
        'updatedAt': Timestamp.now()
      });

    } catch(e) {

      print("ERROR: $e");

    }
  } 

  Future<void> updateAddress(String newAddress) async {

    try {

      await db.collection('users').doc(user!.uid).update({
        'address': newAddress,
        'updatedAt': Timestamp.now()
      });

    } catch(e) {
      print("ERROR: $e");
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      createUserCollectionIfNotExists();

      await db.collection('users').doc(user!.uid).update({
        'email': newEmail,
        'updatedAt': Timestamp.now()
      });
  
    } catch(e) {
      print("ERROR: $e");
    }
  }
}

