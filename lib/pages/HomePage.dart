import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sell_book/pages/DetailsPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import 'SearchPage.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  bool _isVIP = false;
  double _totalAmount = 0.0;
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

  void _calculateTotalAmount() {
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0.0;

    double discount = _isVIP ? 0.1 : 0.0; // 10% discount if VIP customer
    double total = quantity * price;
    double discountedTotal = total - (total * discount);

    setState(() {
      _totalAmount = discountedTotal;
    });
  }

  void _saveInformation() async {
    String customerName = _customerNameController.text;
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0.0;

    if (customerName.isEmpty || quantity == 0 || price == 0.0) {
      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Vui lòng điền đầy đủ thông tin.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
      return; // Dừng lại nếu có lỗi
    }

    bool isPaid = false;
    // Tiếp tục lưu thông tin hoá đơn
    Invoice newInvoice = Invoice(
      customerName: customerName,
      quantity: quantity,
      price: price,
      totalAmount: _totalAmount,
      isPaid: isPaid,
      isVip: _isVIP,
    );

    setState(() {
      _invoices.add(newInvoice);
    });

    // Reset form fields
    _customerNameController.clear();
    _quantityController.clear();
    _priceController.clear();
    _isVIP = false;
    _totalAmount = 0.0;

    //Luư thông tin hoá đơn vào Shared Preferences

    await _saveInvoices();
  }

  void _deleteInvoice(int index) async {
    setState(() {
      _invoices.removeAt(index);
    });

    // Lưu thông tin hoá đơn đã xoá vào Shared Preferences
    await _saveInvoices();
  }

  Future<void> _saveInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> invoiceStrings =
        _invoices.map((invoice) => invoice.toJson()).toList();
    await prefs.setStringList('invoices', invoiceStrings);
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

  Future<void> _showConfirmationDialog(
      String title, String message, Function() onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _Dialog(
      String title, String message, Function() onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
        );
      },
    );
  }

  void _markAsUnpaid(int index) {
    _Dialog('Trạng thái hoá đơn', 'Hoá đơn chưa thanh toán!', () {
      setState(() {
        _invoices[index].isPaid = false;
        _saveInvoices();
      });
    });
  }

  void _markAsPaid(int index) {
    _showConfirmationDialog('Xác nhận', 'Đánh dấu hoá đơn đã thanh toán?', () {
      setState(() {
        _invoices[index].isPaid = true;
        _saveInvoices();
      });
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
         
          //padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Positioned.fill(
                child: Column(children: [
                  SizedBox(height: 20,),

                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Text('  '),
                      Spacer(),
                      Text(
                        'Thông tin hoá đơn.',
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
                  )
                ]),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomTextField(
                  obscureText: false,
                  controller: _customerNameController,
                  hintText: "Tên khách hàng",
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                      child: CustomTextField(
                        obscureText: false,
                        controller: _quantityController,
                        hintText: "Số lượng sách",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0, left: 10.0),
                      child: CustomTextField(
                        obscureText: false,
                        controller: _priceController,
                        hintText: "Price / 1 đơn vị",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Checkbox(
                      value: _isVIP,
                      onChanged: (value) {
                        setState(() {
                          _isVIP = value ?? false;
                          _calculateTotalAmount(); // Recalculate total amount when VIP status changes
                        });
                      },
                    ),
                  ),
                  Text(
                    'Khách hàng VIP',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () {
                        _calculateTotalAmount();
                      },
                      child: Text('Thành tiền', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)),
                  SizedBox(width: 16.0),
                  Container(
                    padding:
                        EdgeInsets.all(8), // Khoảng cách giữa khung và nội dung
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow, // Màu viền của khung
                        width: 1, // Độ dày của viền
                      ),
                      borderRadius: BorderRadius.circular(8), // Bo góc của khung
                    ),
                    child: Text(
                      '$_totalAmount',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Center(
                  child: CustomButton(
                onPressed: () {
                  _saveInformation(); // Lưu thông tin
                },
                text: 'Lưu thông tin',
              )),
              SizedBox(height: 8.0),
              Divider(
                color: Colors.red,
              ),
              const Center(
                  child: Text(
                'Xác nhận hoá đơn:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: Colors.red,
                    decoration: TextDecoration.underline),
              )),
              Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _invoices.length,
                  itemBuilder: (context, index) {
                    Invoice invoice = _invoices[index];
                    return ListTile(
                      title: ListTile(
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
                                      style: TextStyle(color: Colors.yellowAccent))
                              ]),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Số lượng sách: ${invoice.quantity}',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black),
                            ),
                            Text(
                              'Đơn giá: ${invoice.price}',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Thành tiền: ${invoice.totalAmount}',
                                style: TextStyle(
                                
                                    fontSize: 16.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!invoice.isPaid) ...[
                            Checkbox(
                              value: invoice.isPaid,
                              onChanged: (value) {
                                _markAsPaid(index);
                              },
                            ),
                           
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showConfirmationDialog(
                                    'Xác nhận', 'Xóa hoá đơn?', () {
                                  _deleteInvoice(index);
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
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

  class Invoice {
    final String customerName;
    final int quantity;
    final double price;
    final double totalAmount;
    bool isPaid;
    bool isVip;

    Invoice({
      required this.customerName,
      required this.quantity,
      required this.price,
      required this.totalAmount,
      this.isPaid = false,
      this.isVip = false,
    });

    String toJson() {
      return '{"customerName":"$customerName","quantity":$quantity,"price":$price,"totalAmount":$totalAmount,"isPaid":$isPaid,"isVip":$isVip}';
    }

    factory Invoice.fromJson(String json) {
      Map<String, dynamic> data = jsonDecode(json);
      return Invoice(
        customerName: data['customerName'],
        quantity: data['quantity'],
        price: data['price'],
        totalAmount: data['totalAmount'],
        isPaid: data['isPaid'],
        isVip: data['isVip'],
      );
    }
    }
  