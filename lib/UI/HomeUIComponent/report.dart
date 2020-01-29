import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:promise/Services/apiNetwork.dart';
import 'package:promise/UI/BottomNavigationBar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:localstorage/localstorage.dart';
import 'package:promise/Library/model/model.dart';
import 'package:promise/UI/HomeUIComponent/detailReport.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

formatuang (double amount){
return FlutterMoneyFormatter(
    amount: amount,
    settings: MoneyFormatterSettings(
        symbol: '',
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 0,
    )
).output.symbolOnLeft;
  }

class ReportScreen extends StatefulWidget {
  ReportScreen({Key key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}
var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "Sans",
);
var _txtName = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 17.0);
var txtJabatan = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 12.0);
var txtKantor = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0);

class _ReportScreenState extends State<ReportScreen> {
  bool  _loadingInProgress = false, judul = false, list=false;
  String uid;
  int selected=0;
  final LocalStorage storage = new LocalStorage('promise_app');
  UserData user = UserData();
  List<ReportSegmen> reportdata = <ReportSegmen>[];
  List<DataColumn> judulBaris=<DataColumn>[];
  List<DataRow> isiBaris=<DataRow>[];
  List<DataCell> isiCell=<DataCell>[];
  List barisData =[];
  NetworkUtil net = NetworkUtil();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   @override
  void initState() {
    // TODO: implement initState
   
    getReport();
    super.initState();
  }

  listReport() async{
    setState(() {
      int a = 1;
    for(var x in barisData[selected]){
        List<DataCell> isiCell=<DataCell>[];
          for( int i = 0 ; i < reportdata[selected].judul.length; i++ ){
             var kol;
            if(i==0){
             kol = x['data${i}'];
            }else{
              kol = formatuang(double.parse(x['data${i}'].toString()));
            }
            
             isiCell.add(DataCell(
                Align(
                  alignment: Alignment.center,
                  child: Text(kol,style: TextStyle(color:Colors.black,fontSize: 14,),textAlign: TextAlign.center,),
                )
                ));
            }
           isiBaris.add(DataRow(
              selected: true,
              cells: isiCell,
                  )
             );
     if(a == barisData[selected].length){
       setState(() {
         list = true;
       });
      }  
      a++;  
    }
    
    });
  }
  getJudul() async{
    int a = 1;
    for(var x in reportdata[selected].judul){
                  judulBaris.add(DataColumn(label: Text(x.judul, style: TextStyle(color:Colors.black,fontSize: 14, fontWeight: FontWeight.w700),)) ,);
              if(a == reportdata[selected].judul.length)
              {
               setState(() {
                  judul = true;
                });
              }
             
              a++;
              }
  }
  getReport() async{
    await getUser();
    net.getReport('laporan',role:user.role, bidang: user.bidang, user: user.uid).then((onValue)async{
        if(onValue != null){
             onValue['laporan'].forEach((item)async{
              setState(() {
               reportdata.add(ReportSegmen.map(item));
               barisData.add(item['nilai_baris']);
              });
              
                });
            
          await getJudul();
          await listReport();
            if(judul == true && list == true){
            setState(() {
               reportdata[selected].color = Colors.blue;
               judul =false; list = false;
              _loadingInProgress = false;
            });
            }
          
        
         
        }else{
          showInSnackBar('Data report gagal di tampilkan');
        }
    });
  }
   getUser()async{
     setState(() {
       _loadingInProgress = true;
     });
    var hasil = await storage.getItem('AUTH');
    setState(() {
        user = UserData.map(hasil);
       
    });
    
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  getData(selec,val) async{
      judulBaris=[];
      isiBaris=[];
      isiCell=[];
    setState(() {
      _loadingInProgress = true;
      reportdata[selected].color = Colors.white;
      selected = val;
      reportdata[val].color = Colors.blue;
    });

      await getJudul();
      await listReport();

    if(judul == true && list == true){
    setState(() {
      judul = false; list = false;
       _loadingInProgress = false;
    });
    }
  }

  Widget callPage(){
     return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 207,
        child: SingleChildScrollView(
       scrollDirection: Axis.vertical,
       child: DetailReport(report: isiBaris, kolomJudul: judulBaris,)
        ),
     );
   }
    
 
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child:SafeArea(
          child: !_loadingInProgress ? Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10,top:5, bottom:10),
                        child: Text('LAPORAN', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600, letterSpacing: 0.5),),
                      )
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10,top:5, bottom:10),
                        child: Text('Pilih Laporan - Anda melihat data '+ reportdata[selected].segmen.toString(), style: TextStyle(fontSize: 12,letterSpacing: 0.5),),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:10, right:10),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:List.generate(reportdata.length, (index){
                    return InkWell(
                      onTap: (){
                        getData(selected,index);
                      },
                      child:Container(
                      margin: EdgeInsets.only(right: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: reportdata[index].color,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow:[BoxShadow(
                          color: Colors.grey[300],
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(5,5),
                        ),]
                      ),
                      child: Text(reportdata[index].segmen.toUpperCase(), style: TextStyle(fontSize: 12, letterSpacing: 1), textAlign: TextAlign.center,softWrap: true,overflow: TextOverflow.ellipsis,),
                    ),
                    );
                  }),
                ),
                ),
                callPage(),
              ],
                
            )
        ):Container(
          child: Center(child: Text('Silahkan Tunggu'),),
        ),
        ),
      inAsyncCall: _loadingInProgress,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.black12,
        ),
    );
  }
}
