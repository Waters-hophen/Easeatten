import 'package:flutter/material.dart';
import 'package:sxc_attendance/widgets/pages/resultpage.dart';
import 'package:sxc_attendance/widgets/pages/welcomepage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// final res0 = await beforeStream();
// final doc0 = parser.parse(res0.data);  
// print('stscode : ${res0.statusCode} ${doc0.querySelector('body')?.text}');

// final res1 = await afterStream(res0);
// final doc1 = parser.parse(res1.data);
// print('stscode : ${res1.statusCode} ${doc1.querySelector('body')?.text}');

// final res2 = await getResult();
// final doc2 = parser.parse(res2.data);
// print('stscode : ${res2.statusCode} ${doc2.querySelector('body')?.text}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
     home:WelcomePage(),
     
     theme:ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),);
  }
}
