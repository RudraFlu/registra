import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:registra/expensePage.dart';
import 'package:registra/services/expense_service.dart';
import 'package:registra/login.dart';

Future<void> main() async {
  WidgetsBinding wb = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: wb);
  await Supabase.initialize(
  url: 'URL',

 anonKey: 'KEY',
  );
  runApp(const MyApp());
}

bool show = true;
Future<dynamic> getSum() async {
  final result = await supabase.rpc('get_monthly_total');
  return result;
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
      debugShowCheckedModeBanner: false,
      title: 'registra',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: LoginScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future? _expensesFuture;
  Future? sum;
  Offset tapPosition = Offset.zero;
  @override
  void initState() {
    super.initState();
    _loadExpenses();
    getSum();
  }

  Future<void> deleteExpense(int id) async {
    await supabase.from('expense_history').delete().eq('id', id);
    setState(() {
      _loadExpenses();
      toastification.show(
        context: context,
        title: Text('Expense Deleted!'),
        description: Text('Expense is deleted successfully'),
        type: ToastificationType.success,
        backgroundColor: Color(0xFFF7F8F0),
        foregroundColor: Color(0xFF355782),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
    });
  }

  Future<dynamic> getSum() async {
    sum = supabase.rpc('get_monthly_total');
    return sum;
  }

  void _loadExpenses() {
    _expensesFuture = supabase
        .from('expense_history')
        .select()
        .order('time', ascending: false);
  }

  Widget build(context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F0),
      appBar: AppBar(
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
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
          SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => expensePage()),
          );
          if (result == true) {
            setState(() {
              _loadExpenses();
              getSum();
            });
            toastification.show(
              context: context,
              title: Text('Expense Added!'),
              description: Text('Expense is added successfully'),
              type: ToastificationType.success,
              backgroundColor: Color(0xFFF7F8F0),
              foregroundColor: Color(0xFF355782),
              alignment: Alignment.bottomCenter,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
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
        selectedItemColor: Color(0xFFF7F8F0),
        unselectedItemColor: Color(0xFF9CD5FF),
        backgroundColor: Color(0xFF355872),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Friends'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Insight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Account',
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            FutureBuilder(
              future: getSum(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    "Total spent this month: 0",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Color(0xFF355782),
                        fontSize: 16,
                      ),
                      fontWeight: FontWeight(600),
                    ),
                  );
                }
                return RichText(
                  text: TextSpan(
                    style: stly,
                    children: [
                      TextSpan(
                        text: "Total spent this month : ",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Color(0xFF355782),
                            fontSize: 16,
                          ),
                          fontWeight: FontWeight(600),
                        ),
                      ),
                      TextSpan(
                        text: '₹ ${snapshot.data}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Color.fromARGB(253, 144, 0, 210),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            FutureBuilder(
              future: _expensesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return CircularProgressIndicator(color: Color(0xFFF7F8F0));
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading data"));
                }

                final data = snapshot.data as List;
                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      "Add expence and get started",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF355782),
                        fontWeight: FontWeight(600),
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      Color col;
                      if (item['source'] == "spent") {
                        col = Color.fromARGB(255, 190, 0, 0);
                      } else {
                        col = Color.fromARGB(255, 17, 146, 0);
                      }
                      IconData icon = getIcon(item['category']);

                      DateTime date = DateTime.parse(item['created_at']);
                      String formatted =
                          "${date.day}/${date.month}/${date.year}";
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 100 + (index * 10)),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },

                        child: GestureDetector(
                          onTapDown: (details) {
                            tapPosition = details.globalPosition;
                          },
                          child: ListTile(
                            onLongPress: () async {
                              final selected = await showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  tapPosition.dx,
                                  tapPosition.dy,
                                  tapPosition.dx,
                                  tapPosition.dy,
                                ),
                                items: [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete', style: stly),
                                  ),
                                ],
                              );
                              if (selected == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Delete Expense',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Color(0xFF355872),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    content: Text('Are you sure?', style: stly),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel', style: stly),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteExpense(item['id']);
                                        },
                                        child: Text('Delete', style: stly),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            tileColor: Color(0xFFF7F8F0),
                            leading: Icon(
                              icon,
                              size: 30,
                              color: Color(0xFF355872),
                            ),
                            title: Text(
                              item['note'],
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Color(0xFF355872),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                                textStyle: TextStyle(color: col, fontSize: 16),
                              ),
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
