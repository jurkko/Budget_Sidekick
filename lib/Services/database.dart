import 'package:budget_sidekick/Models/account.dart';
import 'package:budget_sidekick/Models/expense.dart';
import 'package:budget_sidekick/Models/category.dart';
import 'package:budget_sidekick/Models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz_unsafe.dart';

class DatabaseService {
  //User ID
  final String uid;

  DatabaseService({this.uid});
  //User Services
  final CollectionReference accountCollection =
      Firestore.instance.collection('Accounts');
  final CollectionReference expenseCollection =
      Firestore.instance.collection('Expenses');
  final CollectionReference categoryCollection =
      Firestore.instance.collection('Categories');
  final CollectionReference eventCollection =
      Firestore.instance.collection('Event');            

  //Handle Account
  Future updateAccount(int balance) async {
    return await accountCollection.document(uid).setData({'balance': balance});
  }

  //Handle Balance
  Future handleBalance(int amount, bool profit) async {
    DocumentSnapshot documentSnapshot =
        await Firestore.instance.collection('Accounts').document(uid).get();
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
  //Categories Services

  List<Category> _categoriesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Category(
          id: doc.documentID,
          name: doc.data['name'],
          iconCode: doc.data['iconCode'],
          user_id: doc.data['user_id']);
    }).toList();
  }

  Stream<List<Category>> get categories {
    return categoryCollection.snapshots().map(_categoriesFromSnapshot);
  }

  //Add Category
  Future addCategory(String name, int iconCode) {
    Firestore.instance
        .collection('Categories')
        .add({'name': name, 'iconCode': iconCode, 'user_id': uid});
  }

  //Removes all expenses under a specific Category
  Future removeCategoryExpenses(String id) async {
    int amount = 0;
    await Firestore.instance
        .collection('Expenses')
        .where('category', isEqualTo: id)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        if (!ds.data['profit']) {
          amount = amount + ds.data['amount'];
        } else {
          amount = amount - ds.data['amount'];
        }
        ds.reference.delete();
      }
    });
    amount < 0 ? handleBalance(amount, true) : handleBalance(amount, false);
  }

  Future updateCategory(String id, String name, int iconCode) {
    Firestore.instance
        .collection('Categories')
        .document(id)
        .updateData({'name': name, 'iconCode': iconCode});
  }

  Future removeCategory(Category category) {
    Firestore.instance.collection('Categories').document(category.id).delete();
    removeCategoryExpenses(category.id);
  }

  //Expenses Services

  Future addExpense(Expense expense) {
    Firestore.instance.collection('Expenses').add({
      'name': expense.name,
      'amount': expense.amount,
      'category': expense.category,
      'profit': expense.profit,
      'user_id': uid,
      'date': expense.date,
      'iconCode': expense.iconCode
    }).whenComplete(() {
      if (expense.profit) {
        handleBalance(expense.amount, true);
      } else {
        handleBalance(expense.amount, false);
      }
    });
  }

  Future updateExpense(Expense expense, bool preProfit, int preAmount) {
    bool changingBalance;
    if (expense.amount == preAmount && expense.profit == preProfit) {
      changingBalance = false;
    } else {
      handleBalance(preAmount, !preProfit);
      changingBalance = true;
    }

    Firestore.instance.collection('Expenses').document(expense.id).updateData({
      'name': expense.name,
      'amount': expense.amount,
      'category': expense.category,
      'profit': expense.profit,
      'date': expense.date,
      'iconCode': expense.iconCode
    }).whenComplete(() {
      if (changingBalance) {
        if (expense.profit) {
          handleBalance(expense.amount, true);
        } else {
          handleBalance(expense.amount, false);
        }
      }
    });
  }

  Future removeExpense(Expense expense) {
    Firestore.instance.collection('Expenses').document(expense.id).delete();
  }

  List<Expense> _expenseFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      Timestamp t = doc.data['date'];
      DateTime d = t.toDate();
      return Expense(
          id: doc.documentID.toString(),
          name: doc.data['name'] ?? '',
          amount: doc.data['amount'] ?? 0,
          category: doc.data['category'] ?? '',
          profit: doc.data['profit'] ?? false,
          user_id: doc.data['user_id'],
          iconCode: doc.data['iconCode'],
          date: d);
    }).toList();
  }

  Stream<List<Expense>> get expenses {
    return expenseCollection
        .where('user_id', isEqualTo: uid)
        .snapshots()
        .map(_expenseFromSnapshot);
  }

  List<Event> _eventFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Event(
          name: doc.data['Name'] ?? "",
          dueDate: doc.data['Duedate'] ?? "",
          target: doc.data['Target'] ?? 0,
          current: doc.data['Current'] ?? 0);
    }).toList();
  }

  Stream<List<Event>> get event {
    return expenseCollection
        .where('user_id', isEqualTo: uid)
        .snapshots()
        .map(_eventFromSnapshot);
  }  
}
