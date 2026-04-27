import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/bet_model.dart';
import '../models/transaction_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== AUTH SERVICES ====================

  /// Sign Up with Email & Password
  Future<UserCredential> signUp(String email, String password, String name, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user in Firestore
      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        walletBalance: 0.0,
        createdAt: DateTime.now(),
        isActive: true,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());

      return userCredential;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Login with Email & Password
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // ==================== USER SERVICES ====================

  /// Get User by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update User Profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Update Wallet Balance
  Future<void> updateWalletBalance(String uid, double amount) async {
    try {
      UserModel? user = await getUser(uid);
      if (user != null) {
        double newBalance = user.walletBalance + amount;
        await _firestore.collection('users').doc(uid).update({
          'walletBalance': newBalance,
        });
      }
    } catch (e) {
      throw Exception('Failed to update wallet: $e');
    }
  }

  // ==================== BET SERVICES ====================

  /// Place a Bet
  Future<String> placeBet(BetModel bet) async {
    try {
      DocumentReference docRef = await _firestore.collection('bets').add(bet.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to place bet: $e');
    }
  }

  /// Get User Bets
  Future<List<BetModel>> getUserBets(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bets')
          .where('uid', isEqualTo: uid)
          .orderBy('placedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => BetModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to get bets: $e');
    }
  }

  /// Get Bet by ID
  Future<BetModel?> getBetById(String betId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('bets').doc(betId).get();
      if (doc.exists) {
        return BetModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get bet: $e');
    }
  }

  /// Update Bet Status
  Future<void> updateBetStatus(String betId, String status, {double? winAmount}) async {
    try {
      Map<String, dynamic> updateData = {
        'status': status,
        'updatedAt': DateTime.now(),
      };
      if (winAmount != null) {
        updateData['winAmount'] = winAmount;
      }
      await _firestore.collection('bets').doc(betId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update bet: $e');
    }
  }

  // ==================== TRANSACTION SERVICES ====================

  /// Add Transaction
  Future<String> addTransaction(TransactionModel transaction) async {
    try {
      DocumentReference docRef = await _firestore.collection('transactions').add(transaction.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  /// Get User Transactions
  Future<List<TransactionModel>> getUserTransactions(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  /// Get Pending Transactions (for Admin)
  Future<List<TransactionModel>> getPendingTransactions() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to get pending transactions: $e');
    }
  }

  /// Update Transaction Status
  Future<void> updateTransactionStatus(String transactionId, String status) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).update({
        'status': status,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  // ==================== REAL-TIME LISTENERS ====================

  /// Listen to User Wallet Changes
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  /// Listen to User Bets
  Stream<List<BetModel>> getUserBetsStream(String uid) {
    return _firestore
        .collection('bets')
        .where('uid', isEqualTo: uid)
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BetModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  /// Listen to Pending Bets (for Admin)
  Stream<List<BetModel>> getPendingBetsStream() {
    return _firestore
        .collection('bets')
        .where('status', isEqualTo: 'pending')
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BetModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
