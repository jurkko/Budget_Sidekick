import 'package:budget_sidekick/Models/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //User ID
  final String uid;

  DatabaseService({this.uid});
  //User Services
  final CollectionReference accountCollection =
      Firestore.instance.collection('Accounts');

  Future updateAccount(int balance) async {
    return await accountCollection.document(uid).setData({'balance': balance});
  }

  Account _accountFromSnapshot(DocumentSnapshot snapshot) {
    return Account(balance: snapshot.data['balance']);
  }

  Stream<Account> get account {
    return accountCollection
        .document(uid)
        .snapshots()
        .map(_accountFromSnapshot);
  }
}
