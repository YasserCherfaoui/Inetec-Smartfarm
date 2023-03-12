import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Doughnut extends StatefulWidget {
  Doughnut({Key? key, required this.title, this.color = Colors.blue, required this.max})
      : super(key: key);
  String title;
  double max;
  Color? color;

  @override
  State<Doughnut> createState() => _DoughnutState();
}

class _DoughnutState extends State<Doughnut> {
  List<dynamic> _responseData = [
    {"ldr": "100", "wind": "100", "water": "100","elevation":"100","stat":"1023"}
  ];
  late Timer _timer;
 

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _sendApiRequest);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _sendApiRequest(Timer timer) async {
    try {
      var response =
          await http.get(Uri.parse('http://172.20.7.13:5000/grades'));
      if (response.statusCode == 200) {
        setState(() {
          _responseData = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _responseData = [
            {"ldr": "0", "wind": "0", "water": "0","elevation":"0","stat":"1023"}
          ];
        });
          print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      setState(() {
        _responseData = [
          {"ldr": "100", "wind": "100", "water": "100","elevation":"0","stat":"1023"}
        ];
      });
      print('Error occurred while fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [
      PieChartSectionData(
        value: double.parse(_responseData.last[widget.title]) * 100 / widget.max,
        title: '${_responseData.last[widget.title]}',
        color: widget.color,
      ),
      PieChartSectionData(
        value: 100 - double.parse(_responseData.last[widget.title]) * 100 / widget.max,
        title: '',
        color: Colors.transparent,
      ),
    ];
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.grey.shade300),
      child: Column(
        children: [
          Text(
            widget.title.toUpperCase(),
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 200,
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
