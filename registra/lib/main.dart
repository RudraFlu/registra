import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:registra/Homepage/home.dart';
import 'package:registra/login%20and%20register/profile.dart';
import 'package:registra/login%20and%20register/login.dart';
import 'package:registra/services/deep_links.dart';
import 'package:registra/services/navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:registra/Homepage/account.dart';
import 'package:registra/Homepage/friends.dart';
import 'package:registra/Homepage/groups.dart';
import 'package:registra/Homepage/insights.dart';
    final deeplinks = DeepLinkService();
Future<void> main() async {
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);

  
  await dotenv.load(fileName: "keys.env");

  await Supabase.initialize(
  url: dotenv.env['Proj_url']!,
    anonKey: dotenv.env['Proj_anonKey']!,
  );
  await deeplinks.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'registra',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: LoginScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
 int currentIndex = 0;
List<Widget>? actions(){

  if(currentIndex==0){
    return [
       IconButton(onPressed: (){}, icon: Icon(Icons.search_outlined)),   
          SizedBox(width: 10),
        ];
  }else if(currentIndex==1){
    return [IconButton(onPressed: (){}, icon: Icon(Icons.group_add_outlined)),
      SizedBox(width: 10,)
    ];
  }else if(currentIndex==2){
    return [IconButton(onPressed: (){}, icon: Icon(Icons.person_add_alt_1_outlined)),SizedBox(width: 10,)];
  }else if(currentIndex==3){
    return [IconButton(onPressed: (){}, icon: Icon(Icons.download_for_offline_outlined)),SizedBox(width: 10,)];
  }else if(currentIndex==4){
    return [IconButton(onPressed: (){}, icon: Icon(Icons.color_lens_outlined)),SizedBox(width: 10,),IconButton(onPressed: (){}, icon: Icon(Icons.settings)),SizedBox(width: 10,)];
  }
  throw{Exception("Wrong index")};
}
  List<Widget> pages = const [
    HomePage(),
    GroupsPage(),
    FriendsPage(),
    InsightPage(),
    AccountsPage(),
  ];
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFF7F8F0),
        unselectedItemColor: Color(0xFF9CD5FF),
        backgroundColor: Color(0xFF355872),
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Friends",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Insight",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Account",
          ),
        ],
      ),appBar: AppBar(
        toolbarHeight: 80,
        title: Image.asset('assets/images/logo.png', height: 70),
        backgroundColor: Color(0xFFF7F8F0),
        surfaceTintColor: Colors.transparent,
        elevation: 5,
        shape: LinearBorder.bottom(
          side: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: Color(0xFF355782),
          ),
        ),
        actions: actions()
      ),
    );
  }
}