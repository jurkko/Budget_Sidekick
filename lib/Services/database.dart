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

  //Handle Account (Balance)
  Future updateAccount(int balance) async {
    return await accountCollection.document(uid).setData({'balance': balance});
  }

  Future handleBalance(int amount, bool profit) async {
    DocumentSnapshot documentSnapshot =
        await accountCollection.document(uid).get();
    int balance = documentSnapshot.data['balance'];
    profit ? balance = balance + amount : balance = balance - amount;
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

  Future addExpense(Expense expense) {
    Firestore.instance.collection('Expenses').add({
      'name': expense.name,
      'amount': expense.amount,
      'category': expense.category,
      'profit': expense.profit,
      'user_id': expense.user_id
    }).whenComplete(() {
      if (expense.profit) {
        handleBalance(expense.amount, true);
      } else {
        handleBalance(expense.amount, false);
      }
    });
  }

  Future updateExpense(Expense expense) {
    Firestore.instance.collection('Expenses').document(expense.id).updateData({
      'name': expense.name,
      'amount': expense.amount,
      'category': expense.category,
      'profit': expense.profit
    });
  }

  Future removeExpense(Expense expense) {
    Firestore.instance.collection('Expenses').document(expense.id).delete();
  }

  List<Expense> _expenseFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Expense(
          id: doc.documentID.toString(),
          name: doc.data['name'] ?? '',
          amount: doc.data['amount'] ?? 0,
          category: doc.data['category'] ?? '',
          profit: doc.data['profit'] ?? false,
          user_id: doc.data['user_id']);
    }).toList();
  }

  Stream<List<Expense>> get expenses {
    return expenseCollection
        .where('user_id', isEqualTo: uid)
        .snapshots()
        .map(_expenseFromSnapshot);
  }
}
