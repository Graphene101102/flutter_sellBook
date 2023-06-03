import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailsPage.dart';
import 'HomePage.dart';
import 'login_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Invoice> _invoices = [];
  List<Invoice> _searchResults = [];
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  void navi(int index) {
    if (index == 0) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
    if (index == 1) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SearchPage()));
    }
    if (index == 2) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DetailsPage()));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      navi(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? invoiceStrings = prefs.getStringList('invoices');
    if (invoiceStrings != null) {
      List<Invoice> invoices =
          invoiceStrings.map((string) => Invoice.fromJson(string)).toList();
      setState(() {
        _invoices = invoices;
      });
    }
  }

  void _searchInvoices(String query) {
    List<Invoice> results = _invoices.where((invoice) {
      return invoice.customerName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
                    children: [
                      SizedBox(width: 10,),
                      Text('  '),
                      Spacer(),
                       Text(
              'Tìm kiếm hoá đơn',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.underline,
                fontSize: 31.0,
                color: Colors.yellow,
              ),
            ),
                      Spacer(),
                      IconButton(onPressed: ()=>{
                        Navigator.pushAndRemoveUntil(context, 
                      MaterialPageRoute(builder: (BuildContext context) => const LoginPage()), 
                      ModalRoute.withName('/')
                      )}, 
                      icon: Icon(Icons.logout)),
                      SizedBox(width: 10,),
                    ],
                  ),
           
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Tên khách hàng',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _searchInvoices(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 26.0),
            Divider(
              color: Colors.black,
            ),
            Text('Danh sách tìm kiếm hoá đơn',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
            SizedBox(height: 26.0),
            Expanded(
                child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Invoice invoice = _searchResults[index];
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: invoice.customerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                      children: <TextSpan>[
                        if (invoice.isVip)
                          TextSpan(
                            text: '  (VIP) ',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số lượng sách: ${invoice.quantity}',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Đơn giá: ${invoice.price}',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Thành tiền: ${invoice.totalAmount}',
                         style: TextStyle(
                                
                                    fontSize: 16.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400)
                      ),
                    ],
                  ),
                  trailing: Icon(
                    invoice.isPaid ? Icons.check : Icons.close,
                    color: invoice.isPaid ? Colors.green : Colors.red,
                  ),
                );
              },
            )),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.blue),
          label: 'Home',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: Colors.blue,
          ),
          label: 'Search',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart, color: Colors.blue),
          label: 'Chart',
          backgroundColor: Colors.pink,
        ),
      ], currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
