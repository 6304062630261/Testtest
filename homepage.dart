// // TODO Implement this library.
// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
//
// class Homepage extends StatefulWidget{
//   const Homepage({Key? key}) : super(key:key);
//
//   @override
//   State<Homepage> createState()=>_HomepageState();
// }
// class _HomepageState extends State<Homepage>{
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     Center(child: Text("Home", style: TextStyle(fontSize: 50))),
//     Center(child: Text("Chart", style: TextStyle(fontSize: 50))),
//     Center(child: Text("Wallet", style: TextStyle(fontSize: 50))),
//     Center(child: Text("Budget", style: TextStyle(fontSize: 50))),
//     // chartpage(),
//     // wallet(),
//     // Budget(),
//   ];
//
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: GNav(
//       backgroundColor: Colors.blue,
//         selectedIndex: _selectedIndex,
//         onTabChange: (index) => setState(() => _selectedIndex = index),
//
//         tabs: [
//           GButton(
//             icon: Icons.home,
//             text: 'Home',
//           ),
//           GButton(
//             icon:Icons.pie_chart,
//             text:'Chart',),
//           GButton(
//             icon:Icons.wallet,
//             text: 'wallet',),
//           GButton(
//               icon:Icons.list,
//             text:'Budget'),
//         ],
//       ),
//     );
//   }
// }