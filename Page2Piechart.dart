// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'database/db_table.dart';
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
//                   value: (items[index].amount / totalAmount) * 100,
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
// class FinancialPieChartItem {
//   final int id;
//   final double amount;
//   final Color color;
//
//   FinancialPieChartItem({required this.id, required this.amount, required this.color});
// }
//
// Color getRandomColor() {
//   final Random random = Random();
//   return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
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
