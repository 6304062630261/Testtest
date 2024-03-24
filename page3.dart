import 'package:flutter/material.dart';
import 'package:appapp/database/db_table.dart'; // Import the SqliteManager class

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<Map<String, dynamic>> _financialData = [];
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double netIncome = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchFinancialData(); // Call this function to fetch financial data when the page is loaded
  }

  Future<void> _fetchFinancialData() async {
    try {
      List<Map<String, dynamic>> financialData = await SqliteManager.instance.queryDatabase('SELECT * FROM Financial');
      double income = 0.0;
      double expense = 0.0;
      for (var financial in financialData) {
        if (financial['type_expense'] == 0) {
          income += financial['amount_financial'];
        } else {
          expense += financial['amount_financial'];
        }
      }
      double netIncome = income - expense; // Calculate net income
      setState(() {
        _financialData = financialData;
        totalIncome = income;
        totalExpense = expense;
        this.netIncome = netIncome; // Update net income here
      });
    } catch (error) {
      print("Error fetching financial data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('บันทึกรายรับ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  _dateController.text = date.toString();
                }
              },
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'จำนวนเงิน'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Prepare data to be inserted into the Financial table
                final data = {
                  'date_user': _dateController.text,
                  'amount_financial': double.parse(_amountController.text),
                  'type_expense': 0,
                  'ID_type_financial': 0 // Set type_expense to false for income
                };

                try {
                  // Insert data into the Financial table using SqliteManager
                  await SqliteManager.instance.insertData('Financial', data);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('บันทึกรายรับสำเร็จ')),
                  );
                  // Fetch financial data again after successful insertion
                  _fetchFinancialData();
                } catch (error) {
                  print("Error inserting financial data: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกรายรับ')),
                  );
                }
              },
              child: Text('บันทึกรายรับ'),
            ),
            SizedBox(height: 16),
            Text(
              'รายรับทั้งหมด: $totalIncome บาท',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'รายจ่ายทั้งหมด: $totalExpense บาท',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'รายรับสุทธิ: $netIncome บาท',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _financialData.length,
                itemBuilder: (context, index) {
                  final financial = _financialData[index];
                  return ListTile(
                    title: Text('วันที่: ${financial['date_user']}'),
                    subtitle: Text('จำนวนเงิน: ${financial['amount_financial']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to the edit page and pass the financial data
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditFinancialPage(financialData: financial)),
                            ).then((_) {
                              // Fetch financial data again after editing
                              _fetchFinancialData();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Delete the financial record
                            await SqliteManager.instance.deleteData('Financial', financial['ID_financial']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('ลบรายการสำเร็จ')),
                            );
                            // Fetch financial data again after deletion
                            _fetchFinancialData();
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

// EditFinancialPage for editing financial data

class EditFinancialPage extends StatefulWidget {
  final Map<String, dynamic> financialData;

  EditFinancialPage({required this.financialData});

  @override
  _EditFinancialPageState createState() => _EditFinancialPageState();
}

class _EditFinancialPageState extends State<EditFinancialPage> {
  late TextEditingController _dateController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.financialData['date_user']);
    _amountController = TextEditingController(text: widget.financialData['amount_financial'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แก้ไขรายการ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  _dateController.text = date.toString();
                }
              },
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'จำนวนเงิน'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Prepare data to be updated in the Financial table
                final data = {
                  'ID_financial': widget.financialData['ID_financial'], // Add ID_financial here
                  'date_user': _dateController.text,
                  'amount_financial': double.parse(_amountController.text),
                  'type_expense': 0,
                  'ID_type_financial': "รายรับ" // Set type_expense to false for income
                };

                try {
                  // Update data in the Financial table using SqliteManager
                  await SqliteManager.instance.updateData('Financial', data, data['ID_financial']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขรายการสำเร็จ')),
                  );
                  // Fetch financial data again after successful insertion
                  Navigator.pop(context); // Close the edit page after updating
                } catch (error) {
                  print("Error updating financial data: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาดในการแก้ไขรายการ')),
                  );
                }
              },
              child: Text('บันทึกรายการ'),
            ),
          ],
        ),
      ),
    );
  }
}
