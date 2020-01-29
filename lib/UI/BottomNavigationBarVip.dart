import 'package:flutter/material.dart';
import 'package:promise/Services/apiNetwork.dart';
import 'package:promise/UI/HomeUIComponent/home.dart';
import 'package:localstorage/localstorage.dart';
import 'package:promise/Library/model/model.dart';
import 'package:promise/UI/HomeUIComponent/report.dart';
import 'package:promise/UI/HomeUIComponent/reportvip.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
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
final kunci = new GlobalKey<_MyDialogState>();

class bottomNavigationVip extends StatefulWidget {
 bottomNavigationVip({Key key}) : super(key: key);

  @override
   bottomNavigationVipState createState() =>  bottomNavigationVipState();
}

class  bottomNavigationVipState extends State <bottomNavigationVip> {
  bool _loadingInProgress=false,judul = false, list=false;
  final LocalStorage storage = new LocalStorage('promise_app');

  UserData user = UserData();
  List<Menu> menu = <Menu>[];
  List<BottomNavigationBarItem> bottomMenu = <BottomNavigationBarItem>[];
  NetworkUtil net = NetworkUtil();
  List<Saring> dataPilihan = <Saring>[];
  int currentIndex=0,_selectedData=0;
  List laporan = [];
  List<ReportSegmen> reportdata = <ReportSegmen>[];
  List<DataColumn> judulBaris=<DataColumn>[];
  List<DataRow> isiBaris=<DataRow>[];
  List<DataCell> isiCell=<DataCell>[];
  List barisData =[];
  List hasilCari=[];
  String parameter="";
  List<BottomNavigationBarItem> report =[BottomNavigationBarItem(
             icon:Icon(
            Icons.assessment,
              size: 25.0,
             ),title: Text(
             'Report',
              style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
             )),
             BottomNavigationBarItem(
             icon:Icon(
            Icons.assessment,
              size: 25.0,
             ),title: Text(
             'Report',
              style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
             )),
             ];
  @override
  void initState() {
    // TODO: implement initState
    getDataReport();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  getDataReport()async{
     var hasil = await storage.getItem('AUTH');
     user = UserData.map(hasil);
    setState(() {
      _loadingInProgress = true;
    });
    net.getReportVip('laporan',user:user).then((result) async{
      result['filter'].forEach((item){
        dataPilihan.add(Saring.map(item));
      });
      laporan = result['laporan'];
    getUser();   
    });
  }
  

listReport() async{
    setState(() {
      int a = 1;
    for(var x in barisData[currentIndex]){
        List<DataCell> isiCell=<DataCell>[];
        if(a <  barisData[currentIndex].length){
          for( int i = 0 ; i < reportdata[currentIndex].judul.length; i++ ){
             var kol;
            if(i==0){
             kol = x['data${i}'];
             isiCell.add(DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(kol,style: TextStyle(color:Colors.black,fontSize: 14,),textAlign: TextAlign.center,),
                )
                ));
            }else{
              kol = formatuang(double.parse(x['data${i}'].toString()));
               isiCell.add(DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(kol,style: TextStyle(color:Colors.black,fontSize: 14,),textAlign: TextAlign.center,),
                  ),
                )
                ));
            }
           
            }
             isiBaris.add(DataRow(
              selected: true,
              cells: isiCell,
                  )
             );
        }else{
           for( int i = 0 ; i < reportdata[currentIndex].judul.length; i++ ){
             var kol;
            if(i==0){
             kol = x['data${i}'].toUpperCase();
             isiCell.add(DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(kol,style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                )
                ));
            }else{
              kol = formatuang(double.parse(x['data${i}'].toString()));
               isiCell.add(DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(kol,style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                  ),
                )
                ));
            }
           
            }
             isiBaris.add(DataRow(
              selected: true,
              cells: isiCell,
                  )
             );
        }
       
          //  isiBaris.add(DataRow(
          //     selected: true,
          //     cells: isiCell,
          //         )
          //    );

     if(a == barisData.length){
       setState(() {
         list = true;
         
       });
      }  
      a++;  
    }
    
    });
  }
  getJudul() async
  {
      int a = 1;
      for(var x in reportdata[currentIndex].judul){
        judulBaris.add(DataColumn(label: Text(x.judul, style: TextStyle(color:Colors.black,fontSize: 14, fontWeight: FontWeight.w700),)) ,);
        if(a == reportdata[currentIndex].judul.length)
        {
          setState(() {
            judul = true;
          });
        }
                
      a++;
      }
  }
  getReport() async{
    judulBaris=[];
    isiCell=[];
    isiBaris=[];
    await getJudul();
    if(barisData[currentIndex].length>1){
        await listReport();
    }else
    {
      for( int i = 0 ; i < reportdata[currentIndex].judul.length; i++ ){
             var kol;
            if(i==0){
             isiCell.add(DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('',style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                )
                ));
            }else{
             
               isiCell.add(DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('',style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                  ),
                )
                ));
            }
           
            }
             isiBaris.add(DataRow(
              selected: true,
              cells: isiCell,
                  )
             );
             setState(() {
            list = true;
          });
    }
   
          
    if(judul == true && list == true){
    setState(() {
        judul =false; list = false;
      _loadingInProgress = false;
    });
    }
  }

  getUser()async{
     setState(() {
       _loadingInProgress = true;
        int i = 0;
        if(laporan.length > 1){
         laporan.forEach((item){  
           reportdata.add(ReportSegmen.map(item));
           barisData.add(item['nilai_baris']);
          
           bottomMenu.add(BottomNavigationBarItem(
             icon:Icon(
             i == 0 ? Icons.radio_button_unchecked : i == 1 ? Icons.crop_square : i == 2 ? Icons.arrow_right : Icons.list,
              size: 25.0,
             ),
             title: Text(
             item['segmen'].toUpperCase(),
              style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
             ))
             );
          i++;
       
         });
          getReport();
        }else{
          laporan.forEach((item){  
           reportdata.add(ReportSegmen.map(item));
           barisData.add(item['nilai_baris']);
          });
           getReport();
        }
         _loadingInProgress = false;
      });  
  }
  showfilterData() async{
     var segmen = laporan[currentIndex]['segmen'].replaceAll(' ', '_');
              hasilCari.add({'key':'filter_segmen','value':segmen.toLowerCase()});
              setState(() {
                _loadingInProgress =true;
               });
                laporan=[];
                reportdata=[];
                barisData=[];
                bottomMenu=[];
                net.getReportVip('laporan',user:user,dataform: hasilCari).then((res){
                  setState(() {
                    laporan = res['laporan'];
                  // res['laporan'].forEach((item){  
                  //   reportdata.add(ReportSegmen.map(item));
                  //   barisData.add(item['nilai_baris']);
                  // });
                  Future.delayed(Duration(milliseconds: 700),(){
                    getUser();  
                  });
                   
                });
                  });
            
  }
  showFilter() {
    // Navigator.of(context).push(MaterialPageRoute(
    //         builder: (BuildContext context) => new MyDialog(data: dataPilihan)));
    showCupertinoModalPopup(
      context: context,
             builder: (BuildContext builder) {
              return StatefulBuilder(
        builder: (context, passwordchange) {
        return AlertDialog(
      content: MyDialog(data: dataPilihan,key: kunci,),
       actions: <Widget>[
        FlatButton(
            child: Text('BATAL'),
            onPressed: (){
              Navigator.pop(context);
            }),
        FlatButton(
            child: Text('CARI'),
            onPressed: () async{
              setState(() {
                    hasilCari = kunci.currentState.cari;
                    kunci.currentState.dataFilter=dataPilihan;
              });
             showfilterData(); 
               Navigator.pop(context);
            }
            )
      ],
    );
                 
               
        });
             });  
  }


  Widget callPage(int current){
     return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
       child:ReportScreenVip(report: isiBaris, kolomJudul: judulBaris, onTap: ()=>showFilter(),user: user,),
     
     );      
 }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        child: laporan.length > 1 ? Scaffold(
        body:!_loadingInProgress ? callPage(currentIndex):Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
      ),
        bottomNavigationBar:Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
          child:bottomMenu.length > 0 ? BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            fixedColor: Color(0xFF6991C7),
            onTap: (value) async{
              setState(() {
                currentIndex = value;
            });
              await getReport();
            },
            items:bottomMenu
          ):BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            fixedColor: Color(0xFF6991C7),
            onTap: (value) async{
              
            },
            items:report,
      ),
      ),
      ):Scaffold(
        // body: Container(
        //   child: Center(
        //     child: Text('tes'),
        //   ),
        // ),
        body:!_loadingInProgress ? callPage(currentIndex):Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
      )
      ),inAsyncCall: _loadingInProgress,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.black12,
        ),
      ),
    );
  }
}


class MyDialog extends StatefulWidget {
    List<Saring> data = <Saring>[];
    GestureDetector onTap;
    MyDialog({Key key, this.data,this.onTap}): super(key: key);
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
List cari=[];
List<FilterPilihan> dataSaring=[];
int _selectedData=0, urut;
DateTime selectedDate = DateTime.now();
List<Saring> dataFilter=<Saring>[];
var dari = "DARI TANGGAL", sampai="SAMPAI TANGGAL";
  @override
  void initState() {
    // TODO: implement initState
    cari=[];
   dataFilter=[];
  }
_selectTime(BuildContext context,val) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate=picked;
       if(val=="dari"){
         dari = DateFormat('d MMMM yy').format(picked).toString().toUpperCase();
         cari.add({'key':"tanggal_awal",'value':DateFormat('yyyy-MM-dd').format(picked)});
       }else{
         sampai = DateFormat('d MMMM yy').format(picked).toString().toUpperCase();
          cari.add({'key':"tanggal_akhir",'value': DateFormat('yyyy-MM-dd').format(picked)});
       }
      });
  }

  
  @override
  Widget build(BuildContext context) {
     dataFilter =widget.data;
  openPick() {
           showModalBottomSheet(
             context: context,
             builder: (BuildContext builder) {
               return Container(
                   height: MediaQuery.of(context).copyWith().size.height / 3,
                   child:  Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         CupertinoButton(
                           child: Text("BATAL"),
                           onPressed: () {
                             Navigator.pop(context);
                           },
                         ),
                         Expanded(
                           child: CupertinoPicker(
                               scrollController:
                                   new FixedExtentScrollController(
                                 initialItem: _selectedData,
                               ),
                               itemExtent: 30.0,
                               magnification: 1,
                                 backgroundColor: Colors.white10,
                               onSelectedItemChanged: (int index) {
                                 setState(() {
                                   _selectedData = index;
                                 });
                               },
                               children: new List<Widget>.generate(dataSaring.length,
                                   (int index) {
                                 return new Center(
                                   child: new Text(dataSaring[index].value,style: TextStyle(
                                     color: Colors.black45,
                                     letterSpacing: 0.5,
                                     fontSize: 16,
                                   ),),
                                 );
                               })),
                         ),
                           CupertinoButton(
                           child: Text("PILIH"),
                           onPressed: (){
                              cari.add({'key':dataFilter[urut].value,'value':dataSaring[_selectedData].id});
                              setState(() {
                                dataFilter[urut].judul=dataSaring[_selectedData].value;
                                _selectedData=0;
                             });

                             Navigator.of(context).pop();
                           },
                         ),
                       ]
                   )
                     );
             });
  }
    return Container(
                 width: MediaQuery.of(context).size.width,
                 height:250,
                 child: Material(
                   type: MaterialType.transparency,
                   child:Column(
                   children: <Widget>[
                     Padding(
                       padding: EdgeInsets.all(10),
                       child: Text('PENCARIAN', style: TextStyle(color:Colors.black,fontSize: 16,letterSpacing: 0.5),),
                     ),
                     Container(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: List.generate(dataFilter.length, (index){
                           return  InkWell(
                                   onTap: (){
                                     setState(() {
                                        dataSaring=dataFilter[index].dataSaring;
                                        urut=index;
                                        openPick();
                                     });
                                    
                                   },
                                   child: Container(
                             padding: EdgeInsets.only(top:20,left:20),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: <Widget>[
                                 Container(
                                   width: MediaQuery.of(context).size.width /2,
                                   child: Text(dataFilter[index].judul.toUpperCase(), style: TextStyle(color: Colors.black,fontSize: 14),),
                                 ),
                                Icon(Icons.arrow_drop_down,color: Colors.blue,size: 25,)
                                 
                               ]
                                 )
                            )
                           );
                         }),
                       ),
                     ),
                     Container(
                       height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child:
                       InkWell(
                         onTap: (){
                           _selectTime(context,"dari");
                         },
                         child: Padding(
                        padding: EdgeInsets.only(top:20,left:20),
                         child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: <Widget>[
                                 Container(
                                   width: MediaQuery.of(context).size.width /2,
                                   child: Text(dari.toString(), style: TextStyle(color: Colors.black,fontSize: 14),),
                                 ),
                                Padding(
                                   padding: EdgeInsets.only(left: 5),
                                   child: Icon(Icons.calendar_today,color:Colors.blue,size: 15,)
                                 ),
                                 
                               ]
                                 )
                          
                       ),
                       )
                        ),
                        Expanded(
                          child:
                       InkWell(
                         onTap: (){
                           _selectTime(context,"sampai");
                         },
                         child: Padding(
                        padding: EdgeInsets.only(top:30,left:20),
                         child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: <Widget>[
                                 Container(
                                   width: MediaQuery.of(context).size.width /2,
                                   padding: EdgeInsets.only(right: 10),
                                   child: Text(sampai.toString(), style: TextStyle(color: Colors.black,fontSize: 14),),
                                 ),
                                Padding(
                                   padding: EdgeInsets.only(left: 5),
                                   child: Icon(Icons.calendar_today,color:Colors.blue,size: 15,)
                                 ),
                               ]
                                 ),
                       ),
                       )
                        )
                      ],
                    ),
                  ),
                   ],
                 )
                 )
               );
     
  }
}