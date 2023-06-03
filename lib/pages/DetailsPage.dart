// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../local/shared_prefs.dart';
// import 'HomePage.dart';

// class DetailsPage extends StatefulWidget {


//   const DetailsPage({
//     super.key,

//   });

//   @override
//   State<DetailsPage> createState() => _DetailsPage();
// }

// class _DetailsPage extends State<DetailsPage> {
//   final _searchController = TextEditingController();
//   final _addController = TextEditingController();
//   final _addFocus = FocusNode();
//   bool _showAddBox = false;

//   int _selectedIndex = 0;

//   void navi(int index) {
//     if (index == 0) {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => HomePage(
//               )));
//     }
//     if (index == 1) {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => DetailsPage()));
//     }
//     // if (index == 2) {
//     //   Navigator.of(context).pushReplacement(MaterialPageRoute(
//     //       builder: (context) => trashPage(
//     //             title: 'Trash',
//     //           )));
//     // }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       navi(index);
//     });
//   }

//   final SharePrefs _prefs = SharePrefs();
//   List<TodoModel> _todos = [];
//   List<TodoModel> _searches = [];

//   @override
//   void initState() {
//     super.initState();
//     _getTodos();
//   }

//   _searchTodos(String searchText) {
//     searchText = searchText.toLowerCase();
//     _searches = _todos
//         .where((element) =>
//             (element.text ?? '').toLowerCase().contains(searchText) &&
//             element.status == 1)
//         .toList();
//   }

//   _getTodos() {
//     _prefs.getTodos().then((value) {
//       setState(() {
//         if (value != null) {
//           _todos = value.toList();
//           _searches =
//               [..._todos].where((element) => element.status == 1).toList();
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.bgColor,
//       appBar: TdAppBar(
//           rightPressed: () async {
//             bool? status = await showDialog<bool>(
//               context: context,
//               builder: (BuildContext context) => AlertDialog(
//                 title: const Text('😍'),
//                 content: const Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'Do you want to logout?',
//                         style: TextStyle(fontSize: 22.0),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, false),
//                     child: const Text('Cancel'),
//                   ),
//                   TextButton(
//                     onPressed: () => {
//                       // Navigator.push(context,
//                       //     MaterialPageRoute(builder: (context) => LoginPage()))

//                       Navigator.pushAndRemoveUntil(context, 
//                       MaterialPageRoute(builder: (BuildContext context) => const LoginPage()), 
//                       ModalRoute.withName('/')
//                       )
//                     },
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//             );
//             if (status ?? false) {
//               SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//             }
//           },
//           title: widget.title),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0)
//                     .copyWith(top: 12.0, bottom: 92.0),
//                 child: Column(
//                   children: [
//                     SearchBox(
//                         onChanged: (value) =>
//                             setState(() => _searchTodos(value)),
//                         controller: _searchController),
//                     const Divider(
//                         height: 32.6, thickness: 1.36, color: AppColor.grey),
//                     ListView.separated(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       padding: EdgeInsets.zero,
//                       itemCount: _searches.length,
//                       itemBuilder: (context, index) {
//                         TodoModel todo = _searches.reversed.toList()[index];
//                         return Dismissible(
//                           key: Key('${todo.hashCode}'),
//                           direction: DismissDirection.startToEnd,
//                           onDismissed: (direction) => {
//                             showDialog(
//                               context: context, 
//                               builder: (BuildContext context) => AlertDialog(
//                                   title: const Text('😍'),
//                                   content: const Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'Do you want to remove the todo?',
//                                           style: TextStyle(fontSize: 22.0),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, false),
//                                       child: const Text('Cancel'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         setState(
//                                           () {
//                                              todo.status = 3;
//                                   _searches.remove(todo);
//                                   _prefs.addTodos(_todos);

//                                   _getTodos();
//                                             Navigator.pop(context, true);
//                                           },
//                                         );
//                                       },
//                                       child: const Text('OK'),
//                                     ),
//                                   ],
                                
//                               ), 
                              

//                             )
                           
//                           },
//                           child: TodoItem(
//                             onTap: () {
//                               setState(() {
//                                 todo.status = 2;
//                                 _prefs.addTodos(_todos);

//                                 _getTodos();
//                               });
//                             },
                           
//                             text: todo.text ?? '-:-',
//                             status: todo.status ?? 0,
//                           ),
//                         );
//                       },
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 16.8),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 20.0,
//             right: 20.0,
//             bottom: 14.6,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Visibility(
//                     visible: _showAddBox,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 5.6),
//                       decoration: BoxDecoration(
//                         color: AppColor.white,
//                         border: Border.all(color: AppColor.blue),
//                         borderRadius: BorderRadius.circular(10.0),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: AppColor.shadow,
//                             offset: Offset(0.0, 3.0),
//                             blurRadius: 10.0,
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: _addController,
//                         focusNode: _addFocus,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Add a new todo item',
//                           hintStyle: TextStyle(color: AppColor.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 18.0),
//                 GestureDetector(
//                   onTap: () {
//                     _showAddBox = !_showAddBox;

//                     if (_showAddBox) {
//                       setState(() {});
//                       _addFocus.requestFocus();
//                       return;
//                     }

//                     String text = _addController.text.trim();
//                     if (text.isEmpty) {
//                       setState(() {});
//                       FocusScope.of(context).unfocus();
//                       return;
//                     }

//                     int id = 1;
//                     if (_todos.isNotEmpty) {
//                       id = (_todos.last.id ?? 0) + 1;
//                     }
//                     TodoModel todo = TodoModel()
//                       ..id = id
//                       ..text = text
//                       ..status = 1;
//                     _todos.add(todo);
//                     _prefs.addTodos(_todos);
//                     _addController.clear();
//                     _searchController.clear();
//                     _searchTodos('');
//                     setState(() {});
//                     FocusScope.of(context).unfocus();
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(14.6),
//                     decoration: BoxDecoration(
//                       color: AppColor.blue,
//                       borderRadius: BorderRadius.circular(10.0),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: AppColor.shadow,
//                           offset: Offset(0.0, 3.0),
//                           blurRadius: 6.0,
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.add,
//                         size: 32.0, color: AppColor.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar:
//           BottomNavigationBar(items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home, color: Colors.blue),
//           label: 'Home',
//           backgroundColor: Colors.blue,
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.check,
//             color: Colors.blue,
//           ),
//           label: 'Complete',
//           backgroundColor: Colors.green,
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.delete, color: Colors.blue),
//           label: 'Trash',
//           backgroundColor: Colors.pink,
//         ),
//       ], currentIndex: _selectedIndex, onTap: _onItemTapped),
//     );
//   }
// }
