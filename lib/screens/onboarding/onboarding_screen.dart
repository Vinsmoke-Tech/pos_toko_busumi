import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaic_app/constant/image_constant.dart';
import 'package:mozaic_app/screens/printer/printer_address_page.dart';
import 'package:mozaic_app/screens/printer/printer_kitchen_address_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_endpoint.dart';
import '../../style/app_properties.dart';
import '../../widget/custom_loading.dart';
import '../../widget/custom_snackbar.dart';
import '../main/main_bottom_navigation.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController controller = PageController();
  int pageIndex = 0;

  String userId = '';
  String userName = '';
  String fullName = '';
  String userGroupName = '';
  String token = '';

  @override
  void initState() {
    _checkOnboardingStatus(context);
    loadSharedPreference();
    super.initState();
  }

  void rebuild() {
    _checkOnboardingStatus(context);
    loadSharedPreference();
  }

  Future<void> loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id')!;
      userName = prefs.getString('username')!;
      fullName = prefs.getString('full_name')!;
      userGroupName = prefs.getString('user_group_name')!;
      token = prefs.getString('token')!;
    });
  }

  Future<void> _checkOnboardingStatus(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    if (hasSeenOnboarding) {
      // Navigate to the main app
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            return const MainBottomNavigation();
          },
        ), (_) => false,
      );
    }
  }

  void _markOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? Material(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                image: const DecorationImage(image: AssetImage(hero))
            ),
            child: Stack(
              children: [
                PageView(
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value;
                    });
                  },
                  controller: controller,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            printerIcon,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32
                          ),
                          child: Text(
                            'Setting Printer',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32
                          ),
                          child: Text(
                            'Anda dapat mengatur printer manual dengan memasukkan nama printer kedalam aplikasi Mozaic agar dapat tampil sewaktu dipindai.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            moneyBagIcon,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32
                          ),
                          child: Text(
                            'Uang Modal ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32
                          ),
                          child: Text(
                            'Masukkan uang modal sebagai modal usaha',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            newMenuIcon,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32
                          ),
                          child: Text(
                            'Menu Baru',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32
                          ),
                          child: Text(
                            'Anda dapat mengatur Kategori, Item, Barang sesuai kebutuhan anda didalam aplikasi Mozaic Point of Sale.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 18
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 0 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 1 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 2 ? yellow : Colors.white),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Opacity(
                              opacity: pageIndex != 2 ? 1.0 : 0.0,
                              child: TextButton(
                                child: const Text(
                                  'SKIP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                onPressed: () {
                                  _markOnboardingSeen();
                                  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const MainBottomNavigation()));
                                },
                              ),
                            ), pageIndex != 2 ? TextButton(
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                if (!(controller.page == 2)) {
                                  controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
                                }
                              },
                            ) : TextButton(
                              child: const Text(
                                'FINISH',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                _markOnboardingSeen();
                                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const MainBottomNavigation()));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ) : Material(
          child: Container(
            //      width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                image: const DecorationImage(image: AssetImage(hero))
            ),
            child: Stack(
              children: [
                PageView(
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value;
                    });
                  },
                  controller: controller,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset(
                            printerIcon,
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Setting Printer',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: Text(
                            'Anda dapat mengatur printer manual dengan memasukkan nama printer kedalam aplikasi Mozaic agar dapat tampil sewaktu dipindai.',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset(
                            moneyBagIcon,
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Uang Modal ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: Text(
                            'Masukkan uang modal sebagai modal usaha',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset(
                            newMenuIcon,
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Menu Baru',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: Text(
                            'Anda dapat mengatur Kategori, Item, Barang sesuai kebutuhan anda didalam aplikasi Mozaic Point of Sale ini.',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 16,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 0 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 1 ? yellow : Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: pageIndex == 2 ? yellow : Colors.white),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Opacity(
                              opacity: pageIndex != 2 ? 1.0 : 0.0,
                              child: TextButton(
                                child: const Text(
                                  'SKIP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                onPressed: () {
                                  _markOnboardingSeen();
                                  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const MainBottomNavigation()));
                                },
                              ),
                            ), pageIndex != 2 ? TextButton(
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                if (!(controller.page == 2)) {
                                  controller.nextPage(
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.linear);
                                }
                              },
                            ) : TextButton(
                              child: const Text(
                                'FINISH',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                _markOnboardingSeen();
                                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const MainBottomNavigation()));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future <void> fetchPrinterAddress(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerAddress,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        String prefPrinterAddress = response.data['data'].toString();
        await prefs.setString('printer_address', prefPrinterAddress);
        //SettingsPage
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterAddressPage(),
        ).then((value) => rebuild());
        //Messsage
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterAddressPage(),
        ).then((value) => rebuild());
      }
    }
  }

  Future <void> fetchPrinterKitchenAddress(context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.post(
        Api.printerKitchenAddress,
        data: {
          'user_id': userId
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // berhasil
        hideLoaderDialog(context);
        String prefPrinterKitchenAddress = response.data['data'].toString();
        await prefs.setString('printer_kitchen_address', prefPrinterKitchenAddress);
        //SettingsPage
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterKitchenAddressPage(),
        ).then((value) => rebuild());
      }
    } on DioException catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        // Message
        CustomSnackbar.show(context, errorMessage, backgroundColor: Colors.red);
      } else {
        /*print(e.message);*/
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) => const PrinterKitchenAddressPage(),
        ).then((value) => rebuild());
      }
    }
  }
}
