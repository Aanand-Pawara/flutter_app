import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class FirebaseService {
  // Singleton
  FirebaseService._privateConstructor();
  static final FirebaseService instance = FirebaseService._privateConstructor();

  bool _initialized = false;
  // Firebase instances
  firebase_auth.FirebaseAuth get auth {
    if (!_initialized) {
      print("❌ Attempted to access FirebaseAuth before initialization");
      throw Exception("Firebase not initialized");
    }
    print("🔹 Accessing FirebaseAuth instance");
    return firebase_auth.FirebaseAuth.instance;
  }

  FirebaseFirestore get db {
    if (!_initialized) {
      print("❌ Attempted to access Firestore before initialization");
      throw Exception("Firebase not initialized");
    }
    print("🔹 Accessing FirebaseFirestore instance");
    return FirebaseFirestore.instance;
  }

  Future<void> init() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      print("✅ Firebase initialized successfully");
    } catch (e) {
      print("❌ Firebase initialization error: $e");
    }
  }

  /// ------------------ AUTH METHODS ------------------

  // Sign Up with Email + Password + Username
  Future<firebase_auth.User?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    print("🔹 Starting Sign Up for email: $email");
    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info in Firestore
      await db.collection('users').doc(cred.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("✅ Sign Up Success: UID=${cred.user!.uid}, Username=$username");
      return cred.user;
    } catch (e) {
      print("❌ Sign Up Error: $e");
      return null;
    }
  }

  // Sign In with Email + Password
  Future<firebase_auth.User?> signIn({
    required String email,
    required String password,
  }) async {
    print("🔹 Starting Sign In for email: $email");
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch username
      final userDoc = await db.collection('users').doc(cred.user!.uid).get();
      final username = userDoc.get('username');
      print("✅ Sign In Success: UID=${cred.user!.uid}, Username=$username");

      return cred.user;
    } catch (e) {
      print("❌ Sign In Error: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    print("🔹 Signing Out");
    await auth.signOut();
    print("✅ Signed Out");
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    print("🔹 Sending password reset email to: $email");
    try {
      await auth.sendPasswordResetEmail(email: email);
      print("✅ Password reset email sent to $email");
    } catch (e) {
      print("❌ Error sending password reset email: $e");
    }
  }

  /// ------------------ USER DATA METHODS ------------------

  // Fetch current user Firestore document
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = auth.currentUser;
    if (user == null) return null;

    final doc = await db.collection('users').doc(user.uid).get();
    return doc.data();
  }

  /// Fetch the current user's username from Firestore
  Future<String> getUserName() async {
    final user = auth.currentUser;
    if (user == null) {
      print("❌ No user signed in");
      return "";
    }

    try {
      final doc = await db.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        print("❌ User document not found in Firestore");
        return "";
      }

      // Safely get username
      final username = doc.get('username') ?? "";
      print("✅ Fetched username: $username");
      return username;
    } catch (e) {
      print("❌ Error fetching username: $e");
      return "";
    }
  }

  String getUserId() {
    final user = auth.currentUser;
    if (user == null) {
      print("❌ No user signed in");
      return "";
    }
    print("✅ User UID: ${user.uid}");
    return user.uid;
  }

  Future<void> updateUsername(String newUsername) async {
    final user = auth.currentUser;
    if (user == null) return;

    await db.collection('users').doc(user.uid).update({
      'username': newUsername,
    });
    print("✅ Username updated to $newUsername");
  }
}
