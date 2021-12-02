// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

abstract class BaseAuthRepsoitory {
  Stream<User?> get authStateChanges;
  Future<String> signin({required String email, required String pswd});
  Future<String> signup({required String email, required String pswd});
  User? getCurrentUser();
  Future<void> signout();
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository extends BaseAuthRepsoitory {
  final Reader _read;
  AuthRepository(this._read);
  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    return _read(firebaseAuthProvider).currentUser;
  }

  @override
  Future<String> signin({required String email, required String pswd}) async {
    try {
      await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: pswd);
      return "Signed In";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<void> signout() async {
    await _read(firebaseAuthProvider).signOut();
  }

  @override
  Future<String> signup({required String email, required String pswd}) async {
    try {
      await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: pswd);
      return "Successfully registered";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'waek-password') {
        return "The password is too weak";
      } else if (e.code == 'email-already-in-use') {
        return "The account already exists for that email";
      }
      return "Oops got some error";
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> addCoin(
      {required String name,
      required String amount,
      required String imageUrl,
      required String price}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var value = double.parse(amount);
      var purchasePrice = double.parse(price);
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Transaction')
          .doc(DateTime.now().toIso8601String());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          documentReference.set({
            'name': name,
            'count': value,
            "image_url": imageUrl,
            'purchase_price': purchasePrice,
            'date': DateTime.now().toIso8601String()
          });
          return true;
        }
        transaction.set(
            documentReference,
            {
              'name': name,
              'count': value,
              'image_url': imageUrl,
              'purchase_price': purchasePrice,
              'date': DateTime.now().toIso8601String()
            },
            SetOptions(merge: true));
        // transaction.update(documentReference, {
        //   'Amount': newAmount,
        //   'Image_Url': imageUrl,
        //   'Purchase_Price': purchasePrice,
        // });
        return true;
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// FlutterFire(this._firebaseAuth);

Future<void> signout() async {
  await _firebaseAuth.signOut();
}
