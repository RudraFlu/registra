import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:registra/services/expense_service.dart';
final _formKey = GlobalKey<FormState>();

class expensePage extends StatefulWidget {
  expensePage({super.key});

  @override
  State<expensePage> createState() => _expensePageState();
}

class _expensePageState extends State<expensePage> {
  Set<String> _selection = {"Personal"};
  void updateSelected(Set<String> newSelect) {
    setState(() {
      _selection = newSelect;
    });
  }

  Future<void> _selectDate() async {
   DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked !=null){
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toString().split(" ")[0];
      });
    }else{
      dateController.text = DateTime.now().toString().split(" ")[0];
    }
  }
  DateTime? selectedDate=DateTime.now();
  Object err = "";
  Future<bool> insert() async {
    final note = noteController.text.trim();
    final amount = double.tryParse(amountController.text);
    try {
      await supabase.from('expense_history').insert({
        'note': note,
        'amount': amount,
        'category': selectedCategory.toLowerCase(),
        'type': _selection.elementAt(0).toLowerCase(),
        'created_at':selectedDate?.toIso8601String(),
      });
      noteController.clear();
      amountController.clear();

      return true;
    } catch (e) {
      err = e;
      return false;
    }
  }
  TextEditingController dateController = TextEditingController(
    text:  "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
  );
  final noteController = TextEditingController();
  final amountController = TextEditingController();
  String selectedCategory = 'other';
  TextStyle stly0 = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(0xFF355872),
      fontWeight: FontWeight(600),
      fontSize: 16,
    ),
  );
  Widget build(context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F0),
      appBar: AppBar(
        toolbarHeight: 70,
        shape: LinearBorder.bottom(
          side: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Color(0xFF355782),
          ),
        ),
        backgroundColor: Color(0xFFF7F8F0),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Add expense",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final success = await insert();
                if (!mounted) return;
                if (success) {
                  Navigator.pop(context, true);
                } else {
                  toastification.show(
                    context: context,
                    title: Text('Failed!'),
                    description: Text('error: ${err}'),
                    type: ToastificationType.error,
                    backgroundColor: Color(0xFFF7F8F0),
                    foregroundColor: Color(0xFF355782),
                    alignment: Alignment.bottomCenter,
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                }
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          SegmentedButton(
            showSelectedIcon: false,
            segments: [
              ButtonSegment<String>(value: "Personal", label: Text("Personal")),
              ButtonSegment<String>(value: "Group", label: Text("Group")),
              ButtonSegment<String>(value: "Friend", label: Text("Friend")),
            ],
            style: SegmentedButton.styleFrom(
              textStyle: GoogleFonts.poppins(
                textStyle: TextStyle(color: Color(0xFF355872), fontSize: 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              backgroundColor: Color(0xFFF7F8F0),
              selectedForegroundColor: Colors.white,
              selectedBackgroundColor: Color(0xFF355782),
            ),
            selected: _selection,
            onSelectionChanged: updateSelected,
          ),

          SizedBox(height: 10),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(getIcon(selectedCategory), color: Color(0xFF355782)),
              SizedBox(width: 15),
              DropdownButton(
                items: [
                  DropdownMenuItem(
                    value: 'food',
                    child: Text('Food', style: stly0),
                  ),
                  DropdownMenuItem(
                    value: 'transport',
                    child: Text('Transport', style: stly0),
                  ),
                  DropdownMenuItem(
                    value: 'shopping',
                    child: Text('Shopping', style: stly0),
                  ),
                  DropdownMenuItem(
                    value: 'entertainment',
                    child: Text('Entertainment', style: stly0),
                  ),
                  DropdownMenuItem(
                    value: 'bills',
                    child: Text('Bills', style: stly0),
                  ),
                  DropdownMenuItem(
                    value: 'health',
                    child: Text('Health', style: stly0),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text('Others', style: stly0),
                  ),
                ],
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                underline: SizedBox(),
                dropdownColor: Color(0xFFF7F8F0),
              ),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            width: 200,
            child: TextField(
              onTap: () {
                _selectDate();
              },
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFF355782),
                ),
                hint: Text("Date", style: stly),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF355782),
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      constraints: BoxConstraints(maxWidth: 250),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: Color(0xFF355782),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      hintStyle: stly,
                      hintText: 'Note',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    controller: noteController,
                    style: stly0,
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'Add a note.'
                          : null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      constraints: BoxConstraints(maxWidth: 250),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: Color(0xFF355782),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      hintStyle: stly,
                      hintText: 'Amount',
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: amountController,
                    style: stly0,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter amount.';
                      }

                      final number = double.tryParse(value);
                      if (number == null) {
                        return 'Enter a valid number';
                      }

                      if (number <= 0) {
                        return 'Amount must be greater than 0';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
