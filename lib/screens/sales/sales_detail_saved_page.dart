import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/api/api_endpoint.dart';
import 'package:mozaic_app/screens/main/main_bottom_navigation.dart';
import 'package:mozaic_app/screens/sales/sales_order_saved_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/no_data_card.dart';
import '../../helper/debug_print.dart';
import '../../style/app_properties.dart';
import '../../utility/currency_format.dart';
import '../../widget/custom_list_tile.dart';
import '../../widget/custom_loading.dart';
import '../../widget/custom_snackbar.dart';

class SalesDetailSavedPage extends StatefulWidget {
  const SalesDetailSavedPage({super.key});

  @override
  State<SalesDetailSavedPage> createState() => _SalesDetailSavedPageState();
}

class _SalesDetailSavedPageState extends State<SalesDetailSavedPage> {
  String userId = '';
  String userName = '';
  String userGroupName = '';
  String token = '';
  String? cartItems;
  String? descriptionItems;
  String? salesInvoiceId = '';
  String savedItem = '';
  String itemCategory = '';
  late FocusNode myFocusNode;
  late FocusNode myFocusNodeTwo;
  late FocusNode myFocusNodeThree;
  late FocusNode myFocusNodeFour;
  late FocusNode myFocusNodeFive;
  late FocusNode myFocusNodeSix;
  late FocusNode myFocusNodeSeven;
  /*var item_id;*/
  var cartItemsJson = [];
  var descriptionItemsJson = [];
  /*var cartItemsJsonForLoops;
  var descriptionItemsJsonForLoops;*/
  var preferenceCompany = '';
  var preferenceCompanyJson = [];
  final Map amountMap = {};
  final Map descriptionMap = {};
  var tableNo = '';
  num discountPercentageTotal = 0;
  num discountAmountTotal = 0;
  String ppnPercentageTotalString = '';
  double ppnPercentageTotal = 0;
  num ppnAmountTotal = 0;
  num subtotal = 0;
  num subtotalItem = 0;
  num total = 0;
  num paidAmount = 0;
  num indexButton = 0;

  final TextEditingController _discountPercentageController = TextEditingController(text: 0.toString());
  final TextEditingController _discountAmountController = TextEditingController(text: 0.toString());
  final TextEditingController _ppnPercentageController = TextEditingController(text: 0.toString());
  final TextEditingController _ppnAmountController = TextEditingController(text: 0.toString());

  String? _initialValue1;
  String? _initialValue2;
  String? _initialValue3;
  String? _initialValue4;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    getPreferenceCompany(context);
    myFocusNode = FocusNode();
    myFocusNodeTwo = FocusNode();
    myFocusNodeThree = FocusNode();
    myFocusNodeFour = FocusNode();
    myFocusNodeFive = FocusNode();
    myFocusNodeSix = FocusNode();
    myFocusNodeSeven = FocusNode();

    _focusNode1.addListener(_onFocusChange1);
    _focusNode2.addListener(_onFocusChange2);
    _focusNode3.addListener(_onFocusChange3);
    _focusNode4.addListener(_onFocusChange4);
  }

  @override
  void dispose() {
    _focusNode1.removeListener(_onFocusChange1);
    _focusNode2.removeListener(_onFocusChange2);
    _focusNode3.removeListener(_onFocusChange3);
    _focusNode4.removeListener(_onFocusChange4);
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      userGroupName = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;
      cartItems = prefs.getString('saveditems');
      descriptionItems = prefs.getString('descriptionitems');
      tableNo = prefs.getString('table_no')!;
      salesInvoiceId = prefs.getString('sales_invoice_id')!;
      discountPercentageTotal = int.parse(prefs.getString('discount_percentage_total')!);
      discountAmountTotal = int.parse(prefs.getString('discount_amount_total')!);
      /*ppnPercentageTotal = double.parse(prefs.getString('ppn_percentage_total')!);
      ppnAmountTotal = double.parse(prefs.getString('ppn_amount_total')!);*/
      _discountPercentageController.text = discountPercentageTotal.toString();
      _discountAmountController.text = discountAmountTotal.toString();
      _ppnPercentageController.text = ppnPercentageTotal.toString();
      _ppnAmountController.text = ppnAmountTotal.toString();

      cartItemsJson = json.decode(cartItems!);
      descriptionItemsJson = json.decode(descriptionItems!);
      for (var value in cartItemsJson) {
        int quantity = int.parse(value['quantity']);
        var subtotalPeritem = int.parse(value['item_unit_price']) * quantity;
        subtotal += subtotalPeritem;
        subtotalItem += quantity;
      }
      total = subtotal - discountAmountTotal;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _onFocusChange1() {
    if (_focusNode1.hasFocus) {
      _initialValue1 = _discountPercentageController.text;
      _discountPercentageController.clear();
    } else if (_initialValue1 != null) {
      _discountPercentageController.text = _initialValue1!;
      _initialValue1 = null;
    }
  }

  void _onFocusChange2() {
    if (_focusNode2.hasFocus) {
      _initialValue2 = _discountAmountController.text;
      _discountAmountController.clear();
    } else if (_initialValue2 != null) {
      _discountAmountController.text = _initialValue2!;
      _initialValue2 = null;
    }
  }

  void _onFocusChange3() {
    if (_focusNode3.hasFocus) {
      _initialValue3 = _ppnPercentageController.text;
      _ppnPercentageController.clear();
    } else if (_initialValue3 != null) {
      _ppnPercentageController.text = _initialValue3!;
      _initialValue3 = null;
    }
  }

  void _onFocusChange4() {
    if (_focusNode4.hasFocus) {
      _initialValue4 = _ppnAmountController.text;
      _ppnAmountController.clear();
    } else if (_initialValue4 != null) {
      _ppnAmountController.text = _initialValue4!;
      _initialValue4 = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    // Mobile View
    Widget bayarButton = ElevatedButton.icon(
      onPressed: () {
        paymentWindow(context);
      },
      icon: const Icon(
        Icons.monetization_on,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Bayar',
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shadowColor: Colors.orangeAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Landscape View
    Widget bayarButtonLandscape = ElevatedButton.icon(
      onPressed: () {
        paymentWindow(context);
      },
      icon: const Icon(
        Icons.monetization_on,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        'Bayar',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shadowColor: Colors.orangeAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double columnWidth = screenWidth / 2;
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order',
                            style: TextStyle(
                              color: darkGrey,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CloseButton()
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: columnWidth,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      // No meja
                                      Card(
                                        elevation: 2,
                                        shadowColor: Colors.grey,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Nomor Meja',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(8),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.15),
                                                              blurRadius: 6,
                                                            )
                                                          ],
                                                        ),
                                                        child: TextFormField(
                                                          cursorColor: Colors.orange,
                                                          keyboardType: TextInputType.number,
                                                          textInputAction: TextInputAction.next,
                                                          key: Key(tableNo),
                                                          initialValue: tableNo,
                                                          onChanged: (text) {
                                                            tableNo = text;
                                                          },
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal
                                                          ),
                                                          decoration: const InputDecoration(
                                                            border: InputBorder.none,
                                                            contentPadding: EdgeInsets.symmetric(
                                                                vertical: 15, horizontal: 15),
                                                            hintText: 'Masukkan nomor meja',
                                                            hintStyle: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.normal
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Sub total
                                          Card(
                                            elevation: 2,
                                            shadowColor: Colors.grey,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Sub Total',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(8),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.black.withOpacity(0.15),
                                                                  blurRadius: 6,
                                                                )
                                                              ],
                                                            ),
                                                            child: TextFormField(
                                                              readOnly: true,
                                                              key: Key(CurrencyFormat.convertToIdr(subtotal, 0).toString()),
                                                              initialValue: CurrencyFormat.convertToIdr(subtotal, 0).toString(),
                                                              onChanged: (text) {
                                                                subtotal = int.parse(text);
                                                              },
                                                              cursorColor: Colors.orange,
                                                              keyboardType: TextInputType.number,
                                                              textInputAction: TextInputAction.next,
                                                              style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.normal
                                                              ),
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(
                                                                    vertical: 15,
                                                                    horizontal: 15
                                                                ),
                                                                hintStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.normal
                                                                ),
                                                              ),
                                                              validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return 'Subtotal tidak boleh kosong';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Card(
                                                  elevation: 2,
                                                  shadowColor: Colors.grey,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          'Diskon (%)',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.black.withOpacity(0.15),
                                                                        blurRadius: 6,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child: TextFormField(
                                                                    controller: _discountPercentageController,
                                                                    focusNode: _focusNode1,
                                                                    onChanged: (value) {
                                                                      changeDiscountPercentage(value);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.normal
                                                                    ),
                                                                    decoration: const InputDecoration(
                                                                      border: InputBorder.none,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical: 15,
                                                                          horizontal: 15
                                                                      ),
                                                                      hintStyle: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.normal
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // Diskon
                                              Expanded(
                                                child: Card(
                                                  elevation: 2,
                                                  shadowColor: Colors.grey,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          'Diskon',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.black.withOpacity(0.15),
                                                                        blurRadius: 6,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child: TextFormField(
                                                                    controller: _discountAmountController,
                                                                    focusNode: _focusNode2,
                                                                    onChanged: (value) {
                                                                      changeDiscountAmount(value);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.normal
                                                                    ),
                                                                    decoration: const InputDecoration(
                                                                      border: InputBorder.none,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical: 15,
                                                                          horizontal: 15
                                                                      ),
                                                                      hintStyle: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.normal
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Card(
                                                  elevation: 2,
                                                  shadowColor: Colors.grey,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          'PPN (%)',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.black.withOpacity(0.15),
                                                                        blurRadius: 6,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child: TextFormField(
                                                                    controller: _ppnPercentageController,
                                                                    focusNode: _focusNode3,
                                                                    onChanged: (value) {
                                                                      changePPNPercentage(value);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.normal
                                                                    ),
                                                                    decoration: const InputDecoration(
                                                                      border: InputBorder.none,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical: 15,
                                                                          horizontal: 15
                                                                      ),
                                                                      hintStyle: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.normal
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // Diskon
                                              Expanded(
                                                child: Card(
                                                  elevation: 2,
                                                  shadowColor: Colors.grey,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          'PPN',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.black.withOpacity(0.15),
                                                                        blurRadius: 6,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child: TextFormField(
                                                                    readOnly: true,
                                                                    // key: Key(ppn_amount_total.toString()),
                                                                    // initialValue: ppn_amount_total.toString(),
                                                                    controller: _ppnAmountController,
                                                                    focusNode: _focusNode4,
                                                                    onChanged: (text) {
                                                                      ppnAmountTotal = double.parse(text);
                                                                    },
                                                                    cursorColor: Colors.orange,
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.normal
                                                                    ),
                                                                    decoration: const InputDecoration(
                                                                      border: InputBorder.none,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical: 15,
                                                                          horizontal: 15
                                                                      ),
                                                                      hintStyle: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.normal
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // Total
                                          Card(
                                            elevation: 2,
                                            shadowColor: Colors.grey,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(8),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.black.withOpacity(0.15),
                                                                  blurRadius: 6,
                                                                )
                                                              ],
                                                            ),
                                                            child: TextFormField(
                                                              readOnly: true,
                                                              key: Key(CurrencyFormat.convertToIdr(total, 0).toString()),
                                                              initialValue: CurrencyFormat.convertToIdr(total, 0).toString(),
                                                              onChanged: (text) {
                                                                total = int.parse(text);
                                                              },
                                                              cursorColor: Colors.orange,
                                                              keyboardType: TextInputType.number,
                                                              textInputAction: TextInputAction.next,
                                                              style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.normal
                                                              ),
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(
                                                                    vertical: 15,
                                                                    horizontal: 15
                                                                ),
                                                                hintStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.normal
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(padding: EdgeInsets.only(bottom: 100)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: VerticalDivider(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              ),
                              SizedBox(
                                width: columnWidth,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: cartItemsJson.length,
                                  itemBuilder: (context, int index) {
                                    return makeCardLandscape(context, index);
                                  },
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.only(top: 8, bottom: bottomPadding != 20 ? 20 : bottomPadding),
                              width: width,
                              height: 80,
                              child: Center(child: bayarButtonLandscape),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ) : WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (BuildContext context) {
                  return const MainBottomNavigation();
                },
              ), (_) => false,
            );
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: Container(
                      margin: const EdgeInsets.only(top: kToolbarHeight),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Tersimpan',
                                style: TextStyle(
                                  color: darkGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CloseButton(
                                onPressed: () async {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return const MainBottomNavigation();
                                      },
                                    ), (_) => false,
                                  );
                                  return Future.value();
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 2,
                            shadowColor: Colors.grey,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nomor Meja',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: TextFormField(
                                              cursorColor: Colors.orange,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.next,
                                              key: Key(tableNo),
                                              initialValue: tableNo,
                                              onChanged: (text) {
                                                tableNo = text;
                                              },
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 15, horizontal: 15),
                                                hintText: 'Masukkan nomor meja',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 1,
                                )
                            ),
                            elevation: 2,
                            child: ExpansionTile(
                              backgroundColor: Colors.white,
                              initiallyExpanded: true,
                              expansionAnimationStyle: AnimationStyle(
                                  curve: Curves.easeIn,
                                  reverseCurve: Curves.easeOut
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.4),
                                    width: 1,
                                  )
                              ),
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.4),
                                    width: 1,
                                  )
                              ),
                              leading: const Icon(Icons.fastfood),
                              title: const Text(
                                "Pesanan",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              trailing: ElevatedButton.icon(
                                onPressed: () {
                                  addSalesItem(context);
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Tambah Menu',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  elevation: 3,
                                  backgroundColor: Colors.deepOrange,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.orangeAccent,
                                ),
                              ),
                              children: [
                                cartItemsJson.isNotEmpty ? ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cartItemsJson.length,
                                  itemBuilder: (context, int index) {
                                    return makeCard(context, index);
                                    // return const Text("tes");
                                  },
                                  separatorBuilder: (context, int index) {
                                    return const Divider();
                                  },
                                ) : const NoDataCard(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Sub total
                              Card(
                                elevation: 2,
                                shadowColor: Colors.grey,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sub Total',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.15),
                                                      blurRadius: 6,
                                                    )
                                                  ],
                                                ),
                                                child: TextFormField(
                                                  readOnly: true,
                                                  key: Key(CurrencyFormat.convertToIdr(subtotal, 0).toString()),
                                                  initialValue: CurrencyFormat.convertToIdr(subtotal, 0).toString(),
                                                  onChanged: (text) {
                                                    subtotal = int.parse(text);
                                                  },
                                                  cursorColor: Colors.orange,
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.next,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                  decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 15
                                                    ),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Subtotal tidak boleh kosong';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      elevation: 2,
                                      shadowColor: Colors.grey,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Diskon (%)',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.15),
                                                            blurRadius: 6,
                                                          )
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                        controller: _discountPercentageController,
                                                        /*focusNode: _focusNode1,*/
                                                        onChanged: (value) {
                                                          changeDiscountPercentage(value);
                                                        },
                                                        cursorColor: Colors.orange,
                                                        keyboardType: TextInputType.number,
                                                        textInputAction: TextInputAction.next,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.normal
                                                        ),
                                                        decoration: const InputDecoration(
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              vertical: 15,
                                                              horizontal: 15
                                                          ),
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Diskon
                                  Expanded(
                                    child: Card(
                                      elevation: 2,
                                      shadowColor: Colors.grey,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Diskon',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.15),
                                                            blurRadius: 6,
                                                          )
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                        controller: _discountAmountController,
                                                        /*focusNode: _focusNode2,*/
                                                        onChanged: (value) {
                                                          changeDiscountAmount(value);
                                                        },
                                                        cursorColor: Colors.orange,
                                                        keyboardType: TextInputType.number,
                                                        textInputAction: TextInputAction.next,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.normal
                                                        ),
                                                        decoration: const InputDecoration(
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              vertical: 15,
                                                              horizontal: 15
                                                          ),
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      elevation: 2,
                                      shadowColor: Colors.grey,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'PPN (%)',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.15),
                                                            blurRadius: 6,
                                                          )
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                        controller: _ppnPercentageController,
                                                        /*focusNode: _focusNode3,*/
                                                        onChanged: (value) {
                                                          changePPNPercentage(value);
                                                        },
                                                        cursorColor: Colors.orange,
                                                        keyboardType: TextInputType.number,
                                                        textInputAction: TextInputAction.next,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.normal
                                                        ),
                                                        decoration: const InputDecoration(
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              vertical: 15,
                                                              horizontal: 15
                                                          ),
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Diskon
                                  Expanded(
                                    child: Card(
                                      elevation: 2,
                                      shadowColor: Colors.grey,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'PPN',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.15),
                                                            blurRadius: 6,
                                                          )
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                        readOnly: true,
                                                        // key: Key(ppn_amount_total.toString()),
                                                        // initialValue: ppn_amount_total.toString(),
                                                        controller: _ppnAmountController,
                                                        /*focusNode: _focusNode4,*/
                                                        onChanged: (text) {
                                                          ppnAmountTotal = double.parse(text);
                                                        },
                                                        cursorColor: Colors.orange,
                                                        keyboardType: TextInputType.number,
                                                        textInputAction: TextInputAction.next,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.normal
                                                        ),
                                                        decoration: const InputDecoration(
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              vertical: 15,
                                                              horizontal: 15
                                                          ),
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.normal
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Total
                              Card(
                                elevation: 2,
                                shadowColor: Colors.grey,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.15),
                                                      blurRadius: 6,
                                                    )
                                                  ],
                                                ),
                                                child: TextFormField(
                                                  readOnly: true,
                                                  key: Key(CurrencyFormat.convertToIdr(total, 0).toString()),
                                                  initialValue: CurrencyFormat.convertToIdr(total, 0).toString(),
                                                  onChanged: (text) {
                                                    total = int.parse(text);
                                                  },
                                                  cursorColor: Colors.orange,
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.done,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                  decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 15
                                                    ),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.normal
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 130)),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 8, bottom: bottomPadding != 20 ? 20 : bottomPadding),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xffd7d7d7).withOpacity(0.0),
                              const Color(0xffd7d7d7).withOpacity(0.5),
                              const Color(0xffd7d7d7),
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter)),
                    width: width,
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(child: bayarButton),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Mobile View
  Widget makeCard(context, int index) {
    return CustomListTile(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Hapus Pesanan',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                content: const Text(
                  'Apakah anda yakin ingin menghapus pesanan ini?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteItemSalesSave(
                        context,
                        index,
                        cartItemsJson[index]['sales_invoice_id'],
                        cartItemsJson[index]['sales_invoice_item_id'],
                      );
                      /*setState(() {
                        cartItemsJson.removeAt(index);
                      });*/
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                          color: Colors.red
                      ),
                    ),
                  ),
                ],
              );
            }
        );
      },
      topLeadingText: cartItemsJson[index]['quantity'].toString(),
      topTitleText: cartItemsJson[index]['item_name'],
      topSubtitleText: CurrencyFormat.convertToIdr(int.parse(cartItemsJson[index]['subtotal_amount']), 0),
      bottomTitleText: cartItemsJson[index]['item_remark'] != null ? "Catatan :\n${cartItemsJson[index]['item_remark']}" : "Catatan :\n" " ",
    );
  }

  // Landscape View
  Widget makeCardLandscape(context, int index) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xffF68D7F),
                    Color(0xffFCE183),
                  ],
                ),
                boxShadow: shadow
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    leading: Container(
                        padding: const EdgeInsets.only(right: 24),
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 2, color: Colors.white24
                                )
                            )
                        ),
                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                                child: Text(
                                  cartItemsJson[index]['item_name'][0].toUpperCase() +
                                      cartItemsJson[index]['item_name'][0]
                                          .toLowerCase(),
                                  style: const TextStyle(
                                      color: Color(0xffF68D7F),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            )
                        )
                    ),
                    title: Text(
                      cartItemsJson[index]['item_name'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                    ),
                    subtitle: Text(
                        CurrencyFormat.convertToIdr(
                            int.parse(cartItemsJson[index]['subtotal_amount']),
                            0),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal
                        )
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 2,
                                      color: Colors.white24
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              // ignore: unnecessary_null_comparison
                              cartItemsJson[index]['quantity'],
                              style: const TextStyle(
                                  color: Color(0xffF68D7F),
                                  fontSize: 22
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 221, 221, 221),
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
                boxShadow: shadow
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                cartItemsJson[index]['item_remark'] != null
                    ? "Catatan :\n${cartItemsJson[index]['item_remark']}"
                    : "Catatan :\n" " ",
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  changePPNPercentage(var value) {
    setState(() {
      /*print(value);*/
      if (value == '' || value == null) {
        value = "0";
      }
      ppnPercentageTotal = double.parse(value);
      String calculateAmount =
      (subtotal * ppnPercentageTotal / 100).round().toString();
      ppnAmountTotal = int.parse(calculateAmount);
      _ppnAmountController.text = ppnAmountTotal.toString();
      // total = subtotal - ppn_amount_total;
      total = subtotal +
          (subtotal * ppnPercentageTotal / 100) -
          ppnAmountTotal;
    });
  }

  changeDiscountPercentage(var value) {
    setState(() {
      /*print(value);*/
      if (value == '' || value == null) {
        value = "0";
      }
      discountPercentageTotal = int.parse(value);
      String calculateAmount =
      (subtotal * discountPercentageTotal / 100).round().toString();
      discountAmountTotal = int.parse(calculateAmount);
      _discountAmountController.text = discountAmountTotal.toString();
      // total = subtotal - discount_amount_total;
      total = subtotal +
          (subtotal * 0 / 100) -
          discountAmountTotal;
    });
  }

  changeDiscountAmount(var value) {
    setState(() {
      /*print(value);*/
      if (value == '' || value == null) {
        value = "0";
      }
      discountAmountTotal = int.parse(value);
      String calculatePercentage =
      (discountAmountTotal * 100 / subtotal).round().toString();
      discountPercentageTotal = int.parse(calculatePercentage);
      _discountPercentageController.text = discountPercentageTotal.toString();
      // total = subtotal - discount_amount_total;
      total = subtotal +
          (subtotal * 0 / 100) -
          discountAmountTotal;
    });
  }

  void insertSalesItems(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.salesSavedPay,
        data: {
          'user_id': userId,
          'sales_invoice_id': salesInvoiceId,
          'discount_percentage_total': discountPercentageTotal,
          'discount_amount_total': discountAmountTotal,
          'ppn_percentage_total': ppnPercentageTotal,
          'ppn_amount_total': ppnAmountTotal,
          'paid_amount': paidAmount,
          'index_button': indexButton,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        // hideLoaderDialog(context);
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) {
              return const MainBottomNavigation();
            },
          ), (_) => false,
        );
        // Message
        CustomSnackbar.show(context, 'Order Berhasil Dibayar');
      }
    } on DioException catch (e) {
      /*print(e);*/
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
      }
    }
  }

  void getPreferenceCompany(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.preferenceCompany,
        data: {
          'user_id': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          preferenceCompany = json.encode(response.data['data']);
          preferenceCompanyJson = json.decode(preferenceCompany);
          ppnPercentageTotalString = preferenceCompanyJson[0]['ppn_percentage'];
          ppnPercentageTotal = double.parse(ppnPercentageTotalString);
          ppnAmountTotal = subtotal * ppnPercentageTotal / 100;
          total = subtotal + (subtotal * ppnPercentageTotal / 100) - discountAmountTotal;
        });
      }
    } on DioException catch (e) {
      /*print(e);
      print('gagal');*/
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        objectPrint(e.message);
      }
    }
  }

  paymentWindow(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        TextEditingController paidAmountController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                height: 400,
                width: 450,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                              offset: Offset(0, 5),
                              blurRadius: 7,
                            )
                          ],
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey[200],
                        ),
                        child: TextFormField(
                          controller: paidAmountController,
                          onChanged: (value) {
                            paidAmount = int.parse(value);
                            // _paidAmountController.text = paid_amount.toString();
                          },
                          decoration: const InputDecoration(
                            labelText: "Bayar",
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Tunai"),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 1;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 1
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Bayar Pas",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 100000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 2;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 2
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "100.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 50000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 3;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 3
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "50.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 20000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 4;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 4
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "20.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 10000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 5;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 5
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "10.000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 5000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 6;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 6
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "5000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount += 2000;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 7;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 7
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "2000",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = 0;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 8;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 8
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("Non Tunai"),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 9;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: paidAmount == 9
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "GoPay",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 10;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 10
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "OVO",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 11;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 11
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "ShopeePay",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paidAmount = total;
                                  paidAmountController.text = paidAmount.toString();
                                  indexButton = 12;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, left: 5),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: indexButton == 12
                                        ? [
                                      const Color.fromARGB(255, 253, 0, 0),
                                      const Color.fromARGB(255, 255, 81, 81),
                                    ]
                                        : [
                                      const Color.fromARGB(255, 255, 89, 0),
                                      const Color.fromARGB(255, 255, 171, 79),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "QRis",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              insertSalesItems(context);
                            },
                            icon: const Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                              size: 12,
                            ),
                            label: const Text(
                              'Bayar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.orangeAccent,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              indexButton = 0;
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12,
                            ),
                            label: const Text(
                              'Kembali',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.orangeAccent,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteItemSalesSave(context, int index, var salesInvoiceId, var salesInvoiceItemId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    /*showLoaderDialog(context);*/
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.deleteItemSalesSaved,
        data: {
          'sales_invoice_id': salesInvoiceId,
          'sales_invoice_item_id': salesInvoiceItemId,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        /*hideLoaderDialog(context);*/
        setState(() {
          cartItemsJson.removeAt(index);
          double totalPrice = 0;
          for (var item in cartItemsJson) {
            totalPrice += int.parse(item['item_unit_price']);
          }
          subtotal = totalPrice;
          /// Kalkulasi Diskon %
          String calculateDiscount = (subtotal * discountPercentageTotal / 100).round().toString();
          discountAmountTotal = int.parse(calculateDiscount);
          /*_discountAmountController.text = discountAmountTotal.toString();*/
          total = subtotal + (subtotal * ppnPercentageTotal / 100) - discountAmountTotal;

          /// Kalkulasi Diskon Rupiah
          String calculateDiscountPercentage = (discountAmountTotal * 100 / subtotal).round().toString();
          discountPercentageTotal = int.parse(calculateDiscountPercentage);
          /*_discountPercentageController.text = discountPercentageTotal.toString();*/
          total = subtotal + (subtotal * ppnPercentageTotal / 100) - discountAmountTotal;

          /// Kalkulasi PPN %
          String calculatePPN = (subtotal * ppnPercentageTotal / 100).round().toString();
          ppnAmountTotal = int.parse(calculatePPN);
          /*_ppnAmountController.text = ppnAmountTotal.toString();*/
          total = subtotal + (subtotal * ppnPercentageTotal / 100) - discountAmountTotal;
        });
        CustomSnackbar.show(context, 'Item berhasil dihapus');
      }
    } on DioException catch (e) {
      /*hideLoaderDialog(context);*/
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        objectPrint(e.message);
      }
    }
  }

  void addSalesItem(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemCategory,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        // hideLoaderDialog(context);
        itemCategory = json.encode(response.data['data']);
        await prefs.setString('itemcategory', itemCategory);
        await prefs.setString('cartitems', json.encode(cartItemsJson));
        await prefs.setString('descriptionitems', json.encode(descriptionItemsJson));
        jsonPrint(descriptionItemsJson);

        await prefs.setString('salesInvoiceId', json.encode(salesInvoiceId));
        await prefs.setString('subtotal', json.encode(subtotal));
        await prefs.setString('subtotalItem', json.encode(subtotalItem));
        await prefs.setString('totalAmount', json.encode(total));
        // print(itemCategory);
        // SalesPage
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SalesOrderSavedPage()));
      }
    } on DioException catch (e) {
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        objectPrint(e.message);
      }
    }
  }

  Future<void> deleteSalesSave(context, var salesInvoiceId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.deleteSalesSaved,
        data: {
          'sales_invoice_id': salesInvoiceId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        hideLoaderDialog(context);
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) {
              return const MainBottomNavigation();
            },
          ), (_) => false,
        );
        CustomSnackbar.show(context, 'Pesanan Berhasil Dihapus');
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        objectPrint(e.message);
      }
    }
  }

  void fetchCategories(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    // showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.itemCategory,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        // hideLoaderDialog(context);
        itemCategory = json.encode(response.data['data']);
        // await prefs.setString('itemcategory', itemCategory);
        // print(itemCategory[0]);
      }
    } on DioException catch (e) {
      // hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        // gagal
        String errorMessage = e.response?.data['message'];
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        objectPrint(e.message);
      }
    }
  }
}
