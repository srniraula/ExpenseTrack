import 'package:exp_track/models/expense.dart';
import 'package:flutter/material.dart';


class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _validateSubmitForm() {
        final selectedAmount = double.tryParse(_amountController.text);
        final invalidAmount = selectedAmount == null || selectedAmount < 0;
        if(_titleController == null || invalidAmount || _selectedDate == null) {
          showDialog(
            context: context, 
            builder: (ctx) => AlertDialog(
              title: const Text("Invalid input"),
              content: const Text("please enter valid title, amount or date"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(ctx);
          }, 
          child: const Text("okay")),
              ],

            ),
            
          );
          
        return;
        }
        widget.onAddExpense(
          Expense(amount: selectedAmount, title: _titleController.text, category: _selectedCategory, date: _selectedDate!)
        );
        Navigator.pop(context);

  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final keyboardOverlap = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      
      return SizedBox(
      height: constraints.maxHeight,
      
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16,16,16,keyboardOverlap+16),
          child: Column(
            children: [
              if(width>=600)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                                ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Amount"),
                        prefixText: '\$ ',
                      ),
                    ),
                  ),
                ],
              )
              else
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
                            ),
              if(width>=600) 
                Row(
                  children: [
                    DropdownButton(
                    value: _selectedCategory, // determines which value is selected initially.
                    items: Category.values
                        .map((category) => DropdownMenuItem( // maps every value of category to a dropdownmenuitem
                              value: category,
                              child: Text(
                                category.name.toUpperCase(), // when we click the dropdownlist, items are appeared due to this code
                              ),
                            ),
                            ).toList(), // converts dropdownmenuitems to a list
                    onChanged: (value) {
                      if(value == null){
                         return;
                         }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                    Expanded(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _selectedDate == null
                                  ? "No date selected"
                                  : formatter.format(_selectedDate!),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _datePicker,
                          icon: const Icon(Icons.calendar_month_rounded),
                        ),
                      ],
                    ),
                  )
                  ],
                )
              else
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Amount"),
                        prefixText: '\$ ',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _selectedDate == null
                                  ? "No date selected"
                                  : formatter.format(_selectedDate!),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _datePicker,
                          icon: const Icon(Icons.calendar_month_rounded),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16,),
              if(width >= 600)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                      onPressed: _validateSubmitForm,
                      child: const Text('Save Expense')),
              ],
              )
              else
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory, // determines which value is selected initially.
                    items: Category.values
                        .map((category) => DropdownMenuItem( // maps every value of category to a dropdownmenuitem
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                            ).toList(), // converts dropdownmenuitems to a list
                    onChanged: (value) {
                      if(value == null){
                         return;
                         }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                      onPressed: _validateSubmitForm,
                      child: const Text('Save Expense')),
                ],
              )
            ],
          ),
        ),
      ),
    );
    });
    
  }
}
