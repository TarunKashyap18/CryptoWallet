// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

abstract class BaseAuthRepsoitory {
  Stream<User?> get authStateChanges;
  Future<String> signin({required String email, required String pswd});
  Future<String> signup(
      {required String username, required String email, required String pswd});
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
      _read(firebaseAuthProvider).userChanges();

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
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  @override
  Future<void> signout() async {
    await _read(firebaseAuthProvider).signOut();
  }

  @override
  Future<String> signup(
      {required String username,
      required String email,
      required String pswd}) async {
    try {
      UserCredential req = await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: pswd);
      User? user = req.user;
      user!.updateDisplayName(username);

      credit_in_wallet(200);

      return "Successfully registered";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  void debite_in_wallet(double unit) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Wallet')
        .doc(DateTime.now().toIso8601String())
        .set(
      {
        'amount': unit,
        'transaction_type': 'debited',
      },
    );
  }

  void credit_in_wallet(double unit) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Wallet')
        .doc(DateTime.now().toIso8601String())
        .set(
      {
        'amount': unit,
        'transaction_type': 'credited',
      },
    );
  }

  Future<String> forgetPassword({required String email}) async {
    try {
      await _read(firebaseAuthProvider).sendPasswordResetEmail(email: email);
      return "Password Reset mail has been sent Pls check yours mails";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<bool> purchaseCoin(
      {required String name,
      required String id,
      required String amount,
      required String imageUrl,
      required String price}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String status = "Purchased";
      var value = double.parse(amount);
      var purchasePrice = double.parse(price);
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Transaction')
          .doc(DateTime.now().toIso8601String());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
            documentReference,
            {
              'name': name,
              'id': id,
              'status': status,
              'count': value / purchasePrice,
              'image_url': imageUrl,
              'purchase_price': purchasePrice,
              'date': DateTime.now().toString()
            },
            SetOptions(merge: true));
        // return true;
      });
      debite_in_wallet(value);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sellCoin(
      {required String name,
      required String id,
      required String amount,
      required String imageUrl,
      required String price}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String status = "Sold";
      var value = double.parse(amount);
      var purchasePrice = double.parse(price);
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Transaction')
          .doc(DateTime.now().toIso8601String());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
            documentReference,
            {
              'name': name,
              'id': id,
              'status': status,
              'count': value / purchasePrice,
              'image_url': imageUrl,
              'purchase_price': purchasePrice,
              'date': DateTime.now().toString()
            },
            SetOptions(merge: true));
        // return true;
      });
      credit_in_wallet(value);

      return true;
    } catch (e) {
      print("error : " + e.toString());
      return false;
    }
  }

  getWalletBalance() {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Wallet')
        .snapshots();
  }

  deleteAccountDetails() {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }
}
