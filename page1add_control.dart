import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'package:appapp/database/db_table.dart';

class AddFinancialPage extends StatefulWidget {
  @override
  _AddFinancialPageState createState() => _AddFinancialPageState();
}

class _AddFinancialPageState extends State<AddFinancialPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  bool _isExpense = true;
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  int? _selectedFinancialTypeId;

  Future<List<Map<String, dynamic>>> _fetchFinancialTypes() async {
    try {
      return await SqliteManager.instance.getTypeFinancialData();
    } catch (error) {
      print("Error fetching financial types: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('บันทึกข้อมูลการเงิน')),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'วันที่'),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dateController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'จำนวนเงิน'),
                keyboardType: TextInputType.number,
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchFinancialTypes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final financialTypes = snapshot.data!;
                    return DropdownButtonFormField<int>(
                      value: _selectedFinancialTypeId,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFinancialTypeId = newValue;
                        });
                      },
                      items: financialTypes.map((financialType) {
                        return DropdownMenuItem<int>(
                          value: financialType['ID_type_financial'],
                          child: Text(financialType['type_financial']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'ประเภทการเงิน'),
                    );
                  }
                },
              ),
              TextFormField(
                controller: _memoController,
                decoration: InputDecoration(labelText: 'หมายเหตุ'),
                maxLines: 5,
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedFinancialTypeId != null) {
                      final data = {
                        'date_user': _dateController.text,
                        'amount_financial': double.parse(_amountController.text),
                        'type_expense': _isExpense ? 1 : 0,
                        'ID_type_financial': _selectedFinancialTypeId,
                        'memo_financial': _memoController.text,
                      };
                      await SqliteManager.instance.insertData('Financial', data);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('กรุณาเลือกประเภทการเงิน'))
                      );
                    }
                  }
                },
                child: Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
