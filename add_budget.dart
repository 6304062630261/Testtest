import 'package:flutter/material.dart';
import 'package:appapp/database/db_table.dart';

class AddBudgetPage extends StatefulWidget {


  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  // Define controllers for text fields
  final _capitalController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
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
      appBar: AppBar(title: Text('Create a Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _capitalController,
              decoration: InputDecoration(labelText: 'Capital Budget'),
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
                    decoration: InputDecoration(labelText: 'ประเภทงบประมาณ'),
                  );
                }
              },
            ),
            TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date'),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _startDateController.text = date.toString();
                }
              },
            ),
            TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date'),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _endDateController.text = date.toString();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Prepare data to be inserted into the Budget table
                final data = {
                  'capital_budget': double.parse(_capitalController.text),
                  'ID_type_financial': _selectedFinancialTypeId,
                  'date_start': _startDateController.text,
                  'date_end': _endDateController.text,
                };

                try {
                  // Insert data into the Budget table using SqliteManager
                  await SqliteManager.instance.insertData('Budget', data);
                  Navigator.pop(context, data);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('บันทึกงบประมาณสำเร็จ')),

                  );
                } catch (error) {
                  print("Error inserting budget data: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกงบประมาณ')),
                  );
                }
              },
              child: Text('Save Budget'),

            ),
          ],
        ),
      ),
    );
  }
}
