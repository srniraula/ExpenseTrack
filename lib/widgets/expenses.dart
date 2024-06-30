import 'dart:ffi';

import 'package:exp_track/widgets/chart/chart.dart';
import 'package:exp_track/widgets/expenses_list/expenses_list.dart';
import 'package:exp_track/models/expense.dart';
import 'package:exp_track/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'trip',
        amount: 200,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        title: 'luggage',
        amount: 100,
        date: DateTime.now(),
        category: Category.leisure),
    
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final indexExpense = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: const Text("Expense Deleted"),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
              setState(() {
                _registeredExpenses.insert(indexExpense, expense);
              });
        },
      ),
    ));
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        // isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  @override
  Widget build(context) {
      final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text("No expenses, start adding now."),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
     // backgroundColor: const Color.fromARGB(255, 123, 101, 101),
      body: width < 600 ? Column(
        children: [
           Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ) : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(
            child: mainContent,
          ) 
        ],
      )
    );
  }
}
