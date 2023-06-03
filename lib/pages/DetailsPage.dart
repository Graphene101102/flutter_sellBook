import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'SearchPage.dart';
import 'login_page.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<Invoice> _invoices = [];
int _selectedIndex = 0;

    void navi(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage()));
    }
    if (index == 1) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SearchPage()));
    }
    if (index == 2) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DetailsPage()));
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

  @override
  Widget build(BuildContext context) {
    int paidInvoicesCount = _invoices.where((invoice) => invoice.isPaid).length;
    double totalRevenue = _invoices
        .where((invoice) => invoice.isPaid)
        .fold(0, (sum, invoice) => sum + invoice.totalAmount);
    return Scaffold(
      
      body: Container(
         decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/images.jpeg"),
                  fit: BoxFit.cover)),
          height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
               const SizedBox(
                height: 20,
              ),
              Row(
                      children: [
                        SizedBox(width: 10,),
                        Text('  '),
                        Spacer(),
                         Text(
                'Danh sách hoá đơn',
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
            ListView.builder(
              itemCount: _invoices.length,
              itemBuilder: (context, index) {
                Invoice invoice = _invoices[index];
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: invoice.customerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
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
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tổng số hoá đơn đã thanh toán: $paidInvoicesCount',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Tổng doanh thu: $totalRevenue',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      
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
