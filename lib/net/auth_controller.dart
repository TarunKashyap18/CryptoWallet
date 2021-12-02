// import 'dart:async';

// import 'package:crypto_wallet/net/flutterfire.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// final authControllerProvider = StateNotifierProvider<AuthController>(
//     (ref) => AuthController(ref.read).appStarted());

// class AuthController extends StateNotifier<User?> {
//   final Reader _read;

//   StreamSubscription<User?>? _authStateChangesSubscription;

//   AuthController(this._read) : super(null) {
//     _authStateChangesSubscription?.cancel();
//     _authStateChangesSubscription = _read(authRepositoryProvider)
//         .authStateChanges
//         .listen((user) => state = user);
//   }
//   @override
//   void dispose() {
//     _authStateChangesSubscription?.cancel();
//     super.dispose();
//   }

//   void appStarted() async {
//     final user = _read(authRepositoryProvider).getCurrentUser();
//   }

//   void signOut() async {
//     await _read(authRepositoryProvider).signout();
//   }
// }
