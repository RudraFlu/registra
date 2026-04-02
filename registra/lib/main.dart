import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    initialization();
  }
  void initialization() async{
    print('Pausing..');
    await Future.delayed(const Duration(seconds: 3));
    print('Unpausing..');
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'registra',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Image.asset('assets/images/logo.png', height: 70),
        backgroundColor: Color(0xFFF7F8F0),
        surfaceTintColor: Colors.transparent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: BorderSide(style: BorderStyle.solid),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.group_add_outlined)),
          SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Color(0xFF355872),
        icon: Icon(Icons.add, color: Color(0xFFF7F8F0)),
        label: Text(
          "Add expence",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Color(0xFFF7F8F0), fontSize: 16),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF355872),
        unselectedItemColor: Color(0xFF7AAACE) ,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group),label: 'Groups'),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Friends'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined),label: 'Activity'),
        BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Account'),
      ],),
      body: Center(child: Column(children: [])),
    );
  }
}
