import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:promise/Library/model/model.dart';



class DetailReport extends StatefulWidget {
  List<DataRow> report;
  List<DataColumn> kolomJudul;
  DetailReport({Key key, this.report, this.kolomJudul}) : super(key: key);

  @override
  _DetailReportState createState() => _DetailReportState();
}

class _DetailReportState extends State<DetailReport> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: widget.kolomJudul != null ? DataTable(
              columnSpacing: 2,
              columns: widget.kolomJudul,
              rows: widget.report,
            
          ):Container(
            child: Center(child: Text('Silahkan Tunggu'),),
          )
             )
            );
        
  }
}