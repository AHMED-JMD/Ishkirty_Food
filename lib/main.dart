import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/widgets/Cart.dart';
import 'package:ashkerty_food/widgets/DeletedBills.dart';
import 'package:ashkerty_food/widgets/Home.dart';
import 'package:ashkerty_food/widgets/Login.dart';
import 'package:ashkerty_food/widgets/Profile.dart';
import 'package:ashkerty_food/widgets/Safe.dart';
import 'package:ashkerty_food/widgets/Store.dart';
import 'package:ashkerty_food/widgets/clients.dart';
import 'package:ashkerty_food/widgets/Employee.dart';
import 'package:ashkerty_food/widgets/Sales.dart';
import 'package:ashkerty_food/widgets/Bills.dart';
import 'package:ashkerty_food/widgets/daily.dart';
import 'package:ashkerty_food/widgets/newDaily.dart';
import 'package:ashkerty_food/widgets/speices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:ashkerty_food/API/Auth.dart';
import 'package:ashkerty_food/utils/local_storage.dart' as storage;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
        ),
        home: const AuthGate(),
        routes: {
          '/safe': (context) => const SafePage(),
          '/home': (context) => const MyHomePage(),
          '/daily': (context) => const DailyPage(),
          '/newDaily': (context) => const NewDailyPage(),
          '/profile': (context) => const UserProfile(),
          '/cart': (context) => const MyCart(),
          '/sales': (context) => const Sales(),
          '/store': (context) => const StorePage(),
          '/bills': (context) => const Bills(),
          '/del_bills': (context) => const DeletedBills(),
          '/speices': (context) => const Speices(),
          '/clients': (context) => const Clients(),
          '/employees': (context) => const EmployeePage(),
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _checking = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    try {
      final token = storage.getLocal('token');

      if (token != null) {
        final response = await APIAuth.getByToken(token);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final auth = Provider.of<AuthProvider>(context, listen: false);
          auth.Login(data['user'], token);
          setState(() {
            _loggedIn = true;
          });
        }
      }
    } catch (e) {
      // ignore
    }
    setState(() {
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _loggedIn ? const MyHomePage() : const Login();
  }
}
