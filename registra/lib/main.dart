import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);
  await Supabase.initialize(
    url: 'https://mlzcqwctqlrxmweajyeb.supabase.co',
    anonKey: 'sb_publishable_c6Sw_IAMCsdjIs380Y2ajA_xjZVVQX3',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

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
      title: 'registra',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F0),
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
          "Add expense",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Color(0xFFF7F8F0), fontSize: 16),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF355872),
        unselectedItemColor: Color(0xFF7AAACE),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Friends'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Insight',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Account'),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Divider(),
            FutureBuilder(
              future: supabase
                  .from('expense_history')
                  .select()
                  .order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return CircularProgressIndicator(color: Color(0xFF355872));
                final data = snapshot.data as List;
                return Expanded(
                  child: ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                       Color col;
                       if(item['source']=="spent"){
                          col = Color.fromARGB(255, 190, 0, 0);
                        }
                        else{
                          col = Color.fromARGB(255, 17, 146, 0);
                        }
                        DateTime date = DateTime.parse(item['created_at']);
                        String formatted = "${date.day}/${date.month}/${date.year}";
                      return ListTile(
                        tileColor: Color(0xFFF7F8F0),
                        leading: Icon(Icons.person),
                        title: Text(
                          item['note'],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Color(0xFF355872),
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        subtitle: Text(
                          formatted,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Color(0xFF355872),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        trailing: Text(
                          "₹${item['amount']}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: col,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(thickness: 1, height: 1);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
