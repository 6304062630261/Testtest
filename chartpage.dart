// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'database/db_table.dart';
//
// class Page2 extends StatelessWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     key: _scaffoldKey,
//     appBar: AppBar(title: Text('Static Chart')),
//     body: Center(
//       child: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.utc(2023, 1, 1),
//             lastDay: DateTime.utc(2024, 12, 31),
//             focusedDay: DateTime.now(),
//             // ... other properties
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.bar_chart),
//                   onPressed: () {
//                     _showFinancialPieChart(context);
//                   },
//                   iconSize: 60,
//                   color: Colors.blue,
//                 ),
//               ),
//               SizedBox(width: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('รายการ'),
//                       ),
//                     );
//                   },
//                   iconSize: 60,
//                   color: Colors.green,
//                 ),
//               ),
//               SizedBox(width: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.scale),
//                   onPressed: () {
//                     _showFinancialBarChart(context);
//                   },
//                   iconSize: 60,
//                   color: Colors.orange,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );









  // Function to fetch data from the database
//   Future<Map<String, double>> fetchDataFromDatabase() async {
//     double totalIncome = 0;
//     double totalExpense = 0;
//     try {
//       // Fetch total income from the database
//       List<Map<String, dynamic>> incomeResult = await SqliteManager.instance
//           .queryDatabase('SELECT ID_type_financial, SUM(amount_financial) AS total_amount FROM financial WHERE type_expense = 0 AND DATE(date_user) = DATE(\'now\') GROUP BY ID_type_financial');
//
//       totalIncome = (incomeResult[0]['total_income'] ?? 0).toDouble();
//
// // Fetch total expense from the database
//       List<Map<String, dynamic>> expenseResult = await SqliteManager.instance
//           .queryDatabase('SELECT ID_type_financial, SUM(amount_financial) AS total_amount FROM financial WHERE type_expense = 1 AND DATE(date_user) = DATE(\'now\') GROUP BY ID_type_financial');
//       totalExpense = (expenseResult[0]['total_expense'] ?? 0).toDouble();
//
//     } catch (error) {
//       print("Error fetching data from database: $error");
//     }
//     return {
//       'totalIncome': totalIncome,
//       'totalExpense': totalExpense,
//     };
//   }
  // รายรับรายจ่าย
//   void _showFinancialBarChart(BuildContext context) async {
//     Map<String, double> data = await fetchDataFromDatabase();
//     double totalIncome = data['totalIncome'] ?? 0;
//     double totalExpense = data['totalExpense'] ?? 0;
//     print('Total Income: $totalIncome');
//     print('Total Expense: $totalExpense');
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Financial Chart'),
//           content: FinancialBarChart(
//             totalIncome: totalIncome,
//             totalExpense: totalExpense,
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// Future<List<FinancialPieChartItem>> calculateFinancialData() async {
//   List<FinancialPieChartItem> financialData = [];
//   try {
//     List<Map<String, dynamic>> result = await SqliteManager.instance.queryDatabase(
//       'SELECT ID_type_financial, SUM(amount_financial) AS total_amount '
//           'FROM financial '
//           'WHERE type_expense = 1 '
//           'GROUP BY ID_type_financial',
//     );
//     print('Result from database query: $result');
//     financialData = result.map((row) {
//       int id = row['ID_type_financial'];
//       double totalAmount = double.tryParse(row['total_amount'].toString()) ?? 0.0;
//       return FinancialPieChartItem(
//         id: id,
//         amount: totalAmount,
//         color: getRandomColor(),
//       );
//     }).toList();
//     print('Financial data for pie chart: $financialData');
//   } catch (error) {
//     print('Error calculating financial data: $error');
//   }
//   return financialData;
// }
//
//
// Color getRandomColor() {
//   final Random random = Random();
//   return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
// }
// //donut
// void _showFinancialPieChart(BuildContext context) {
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return FutureBuilder(
//         future: calculateFinancialData(),
//         builder: (BuildContext context, AsyncSnapshot<List<FinancialPieChartItem>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             List<FinancialPieChartItem> pieChartItems = snapshot.data ?? [];
//             return AlertDialog(
//               title: Text('Financial Pie Chart'),
//               content: Container(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 child: Center(
//                   child: FinancialPieChart(items: pieChartItems),
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Close'),
//                 ),
//               ],
//             );
//           }
//         },
//       );
//     },
//   ); // เพิ่มตรงนี้
// }

//
//
//
// class FinancialPieChart extends StatelessWidget {
//   final List<FinancialPieChartItem> items;
//
//   FinancialPieChart({required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     double totalAmount = items.fold(0, (previous, current) => previous + current.amount);
//
//     return Row(
//       children: [
//         Expanded(
//           child: PieChart(
//             PieChartData(
//               sections: List.generate(
//                 items.length,
//                     (index) => PieChartSectionData(
//                   color: items[index].color,
//
//                   value: (items[index].amount / totalAmount) * 100,
//
//                   title: '${((items[index].amount / totalAmount) * 100).toStringAsFixed(2)}%',
//                   radius: 100,
//                   titleStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               sectionsSpace: 0,
//               centerSpaceRadius: 40,
//             ),
//           ),
//         ),
//         SizedBox(width: 10), // Distance between the chart and the legend
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: List.generate(
//             items.length,
//                 (index) => Row(
//               children: [
//                 Container(
//                   width: 20,
//                   height: 20,
//                   color: items[index].color,
//                 ),
//                 SizedBox(width: 5), // Distance between color box and text
//                 Text('Category ${items[index].id}'), // Expense category name
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
// // คลาสสำหรับเก็บข้อมูลของแต่ละรายการที่จะใช้ในแผนภูมิรูปpiechart
// class FinancialPieChartItem {
//   final int id;
//   final double amount;
//   final Color color;
//
//   FinancialPieChartItem({required this.id, required this.amount, required this.color});
// }
//

// Class to represent the financial chart
// class FinancialBarChart extends StatelessWidget {
//   final double totalIncome;
//   final double totalExpense;
//
//   FinancialBarChart({
//     required this.totalIncome,
//     required this.totalExpense,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         barGroups: [
//           BarChartGroupData(
//             x: 0,
//             barRods: [
//               BarChartRodData(
//                 y: totalIncome,
//                 colors: [Colors.green],
//                 width: 25,
//               ),
//             ],
//           ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 y: totalExpense,
//                 colors: [Colors.red],
//                 width: 25,
//               ),
//             ],
//           ),
//         ],
//         titlesData: FlTitlesData(
//           leftTitles: SideTitles(showTitles: false),
//           bottomTitles: SideTitles(
//             showTitles: true,
//             getTitles: (double value) {
//               if (value == 0) {
//                 return 'Income';
//               } else if (value == 1) {
//                 return 'Expense';
//               }
//               return '';
//             },
//           ),
//         ),
//         borderData: FlBorderData(show: false),
//         barTouchData: BarTouchData(enabled: false),
//       ),
//     );
//   }
//
//
//
// }