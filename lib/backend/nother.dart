  import 'package:dio/dio.dart';
  import 'package:flutter/material.dart';
  import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
  import 'package:html/dom.dart';
  import 'package:html/parser.dart' as parser;
  import 'package:path_provider/path_provider.dart';
  import 'dart:io';

  final dio = Dio();
  final headers = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'Cookie': 'ASP.NET_SessionId=qksj31yhq0yms0ashyi0favq',
  'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
  'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9, image/avif,image/webp,image/apng,*/*;q=0.8',
  'Accept-Language': 'en-US,en;q=0.5',
  'Accept-Encoding': 'gzip, deflate, br, zstd',
  'Origin': 'https://online.sxccal.edu',
  'Referer': 'https://online.sxccal.edu/WebAttn_BABSC/Attendance.aspx',
  'Cache-Control': 'max-age=0',
  'Upgrade-Insecure-Requests': '1',
  'Sec-Fetch-Dest': 'document',
  'Sec-Fetch-Mode': 'navigate',
  'Sec-Fetch-Site': 'same-origin',
  'Sec-Fetch-User': '?1',
};


  Future<Document> fetchDoc() async {

    var response = await dio.get('https://online.sxccal.edu/WebAttn_BABSC/Attendance.aspx',);
      return parser.parse(response.data);
  }

  Future<File> _saveImg() async {
    final response = await dio.get(
      "https://online.sxccal.edu/WebAttn_BABSC/Captcha.aspx",
      options: Options(responseType: ResponseType.bytes,
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      final temp = await getTemporaryDirectory();
      final file = File('${temp.path}/captcha.png');
      await file.writeAsBytes(response.data);
      return file;
    } else {
      throw Exception('Failed to load captcha image');
    }
  }

  Future<String> _getCaptcha() async {
    final inputimg = InputImage.fromFile(await _saveImg());
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      String txt = (await textRecognizer.processImage(inputimg)).text;
      await textRecognizer.close();
      return txt.trim().replaceAll(' ', '');
    } catch (e) {
      debugPrint("Error: Coudn't process the captcha image");
      await textRecognizer.close();
      return '';
    }
  }

  Future<Response> beforeStream() async {

    Document doc = await fetchDoc();
    final form = doc.querySelector('form') ?? (throw Exception('Form not found'));
    
     Map<String, String> formData = {
    '__EVENTTARGET': 'ddlStream',
    '__EVENTARGUMENT': '',
    '__LASTFOCUS': '',
    '__VIEWSTATE':
        form.querySelector('input[name="__VIEWSTATE"]')?.attributes['value'] ?? '',
    '__VIEWSTATEGENERATOR': // it's always '9A18B828'
        form.querySelector('input[name="__VIEWSTATEGENERATOR"]')?.attributes['value'] ?? '',
    '__EVENTVALIDATION':
        form.querySelector('input[name="__EVENTVALIDATION"]')?.attributes['value'] ??'',
    'ddlSession': '',
    'ddlStream': '2',
    'ddlSemester': '',
    'ddlDept': '',
    'txtRoll': '',
    'txtCode': '',
  };

  try {
    var newResponse = await dio.post(
      'https://online.sxccal.edu/WebAttn_BABSC/Attendance.aspx',
      data: formData,
  options: Options(headers: headers)
    );
    print("doc change successful pallab");
    doc = parser.parse(newResponse.data);

  } catch (e) {

    debugPrint("Error: sending form data failed");
    Response(
      requestOptions: RequestOptions(path: ''),
      statusCode: 500,
      statusMessage: 'Failed to send form data',
    );
  }

    try {
      return await dio.post(
        'https://online.sxccal.edu/WebAttn_BABSC/Attendance.aspx',
        data: formData,
    options: Options(headers: headers,
));
      
    } catch (e) {
      debugPrint("Error: sending form data failed");
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: 'Failed to send form data',
      );
    }
  }

  Future<Response> afterStream(Response r) async {

    debugPrint("enterd afterStream");
    Document doc = parser.parse(r.data);
    var form = doc.querySelector('form') ?? (throw Exception('Form not found'));
    Map<String, String> formData = {
      '__EVENTTARGET': '',
      '__EVENTARGUMENT': '',
      '__LASTFOCUS': '',
      '__VIEWSTATE':
          form.querySelector('input[name="__VIEWSTATE"]')?.attributes['value'] ?? '',
      '__VIEWSTATEGENERATOR': // it's always '9A18B828'
          form.querySelector('input[name="__VIEWSTATEGENERATOR"]')?.attributes['value'] ?? '',
      '__EVENTVALIDATION':
          form.querySelector('input[name="__EVENTVALIDATION"]')?.attributes['value'] ??'',
      'ddlSession': '2025-2026',
      'ddlStream': '2',
      'ddlSemester': 'Sem - III',
      'ddlDept': '6',
      'txtRoll': '507',
      'txtCode': await _getCaptcha(),
      'btnViewAttendance':'VIEW ATTENDANCE',

    };
    try {
      print("Success Sending form 2nd data");
      return await dio.post(
        'https://online.sxccal.edu/WebAttn_BABSC/Attendance.aspx',
        data: formData,
          options: Options(headers: headers,
          followRedirects: true,
          validateStatus: (_) => true, // Allow all status codes
          )
  );
    } catch (e) {
      debugPrint("Error: sedning 2nd form data failed");
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: 'Failed to send form data',
      );
    }
  }
  Future<Response> getResult() async{
    return await dio.get(
        'https://online.sxccal.edu/WebAttn_BABSC/AttendanceView.aspx',
        options: Options(headers: headers)
      );
  }