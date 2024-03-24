import 'package:flutter/material.dart';
import 'package:appapp/add_budget.dart';
import 'package:appapp/database/db_table.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  List<Map<String, dynamic>> _savedDataList = [];

  Future<void> fetchAllBudgets() async {
    try {
      List<Map<String, dynamic>> budgets = await SqliteManager.instance.getAllBudgets();
      setState(() {
        _savedDataList = budgets;
      });
    } catch (error) {
      print("Error fetching all budgets: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllBudgets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBudgetPage(),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _savedDataList.add(value);
                    });
                  }
                });
              },
              child: Text('Create a Budget'),
            ),
            SizedBox(height: 20),
            Text(
              'Budget:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: _savedDataList.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final data = _savedDataList[index];
                  return ListTile(
                    title: Text('Capital Budget: ${data['capital_budget']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Financial Type ID: ${data['ID_type_financial']}'),
                        Text('Start Date: ${data['date_start']}'),
                        Text('End Date: ${data['date_end']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditBudgetPage(budgetData: data)),
                            ).then((value) {
                              fetchAllBudgets();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await SqliteManager.instance.deleteDataBudget(
                                'Budget', data['ID_budget']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Deleted successfully')),
                            );
                            fetchAllBudgets();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditBudgetPage extends StatefulWidget {
  final Map<String, dynamic> budgetData;

  EditBudgetPage({required this.budgetData});

  @override
  _EditBudgetPageState createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  late TextEditingController _capitalBudgetController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _capitalBudgetController = TextEditingController(text: widget.budgetData['capital_budget'].toString());
    _startDateController = TextEditingController(text: widget.budgetData['date_start']);
    _endDateController = TextEditingController(text: widget.budgetData['date_end']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _capitalBudgetController,
              decoration: InputDecoration(labelText: 'กำหนดจำนวนงบประมาณ'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date'),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _startDateController.text = date.toString();
                }
              },
            ),
            TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date'),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _endDateController.text = date.toString();
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'ID_budget': widget.budgetData['ID_budget'], // ใช้คอลัมน์ที่ถูกต้องเป็นเงื่อนไข
                  'capital_budget': double.parse(_capitalBudgetController.text),
                  'date_start': _startDateController.text,
                  'date_end': _endDateController.text,
                };

                try {
                  await SqliteManager.instance.updateDataBudget('Budget', data, data['ID_budget']); // ใช้คอลัมน์ที่ถูกต้องเป็นเงื่อนไข
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data updated successfully')),
                  );
                } catch (error) {
                  print("Error updating budget data: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating data')),
                  );
                }

              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
