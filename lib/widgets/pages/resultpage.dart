import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
        icon:Icon(Icons.school,
        color: Colors.white,
        size: 30,
        ),
        onPressed:() {
          _launchURL('https://sxccal.edu/students-section/students-attendance');             
        }
        ),
        actions: [PopupMenuButton<int>(
          onSelected: (value) {
          
        }, 
        icon: Icon(Icons.more_vert),
        itemBuilder: (context) {
          return [
          PopupMenuItem(value: 1,child: Text('Logout')),
          PopupMenuItem(value: 2,child: Text('About')),
          ];
        },
      )
    ],

        title: Text('SXC Attendance'),
        backgroundColor: Colors.blueAccent,
        titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        ),
      ),
      
      body:Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         
        ),
      ),
    );
  }
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

