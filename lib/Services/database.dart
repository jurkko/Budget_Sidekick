import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //User ID
  final String uid;

  DatabaseService({this.uid});
  //User Services
  final CollectionReference accountCollection =
      Firestore.instance.collection('Accounts');
  final CollectionReference expenseCollection =
      Firestore.instance.collection('Expenses');
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

  //Expenses Services

  Future updateExpense(Expense expense) {
    //Update expense
  }

  List<Expense> _expenseFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Expense(
          name: doc.data['name'] ?? '',
          amount: doc.data['amount'] ?? 0,
          category: doc.data['category'] ?? '',
          profit: doc.data['profit'] ?? false);
    }).toList();
  }

  Stream<List<Expense>> get expenses {
    return expenseCollection
        .where('user_id', isEqualTo: uid)
        .snapshots()
        .map(_expenseFromSnapshot);
  }
}
