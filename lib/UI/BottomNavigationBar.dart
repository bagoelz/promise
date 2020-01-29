
import 'package:flutter/material.dart';
import 'package:promise/UI/HomeUIComponent/home.dart';
import 'package:localstorage/localstorage.dart';
import 'package:promise/Library/model/model.dart';
import 'package:promise/UI/HomeUIComponent/report.dart';
import 'package:promise/UI/HomeUIComponent/reportvip.dart';

class bottomNavigationBar extends StatefulWidget {
 @override
 _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  final LocalStorage storage = new LocalStorage('promise_app');
  UserData user = UserData();
  List<Menu> menu = <Menu>[];
  List<BottomNavigationBarItem> bottomMenu = <BottomNavigationBarItem>[];
  double jlhKolom;
  BottomNavigationBarItem report = BottomNavigationBarItem(
             icon:Icon(
            Icons.assessment,
              size: 25.0,
             ),title: Text(
             'Report',
              style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
             ));
             
  bool  _loadingInProgress = false;

   @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();

  }
   getMenu() async{
     menu=[];
     setState(() {
       _loadingInProgress = true;
     });
      var res = await storage.getItem('MENU');
      res.forEach((item){
         menu.add(Menu.map(item));
        });
        Future.delayed(Duration(microseconds:700 ),(){
           setState(() {
        jlhKolom = menu[currentIndex].baris.length <= 2 ? (menu[currentIndex].baris.length + (3 - menu[currentIndex].baris.length)).toDouble():(menu[currentIndex].baris.length -1).toDouble();
        _loadingInProgress = true;
           });
        });
     
   }

   getUser()async{
     setState(() {
       _loadingInProgress = true;
     });
    var hasil = await storage.getItem('AUTH');
    var res = await storage.getItem('MENU');
    setState(() {
        user = UserData.map(hasil);
        int i = 0;
        if(res.length > 0){
         res.forEach((item){
           menu.add(Menu.map(item));
            jlhKolom = menu[currentIndex].baris.length <= 2 ? (menu[currentIndex].baris.length + (3 - menu[currentIndex].baris.length)).toDouble():(menu[currentIndex].baris.length -1).toDouble();
             
           bottomMenu.add(BottomNavigationBarItem(
             icon: item['icon']?.length > 0 ? Icon(
             i == 0 ? Icons.radio_button_unchecked : i == 1 ? Icons.crop_square : i == 2 ? Icons.arrow_right : Icons.list,
              size: 25.0,
             ): Image.network(item['icon']['path'],width: item['icon']['size'].toDouble(),height: item['icon']['size'].toDouble(),),
             title: Text(
             item['judul'].toUpperCase(),
              style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
             ))
             );
        i++;
       
    });
        }
      });  
  Future.delayed(Duration(microseconds:700 ),(){
      bottomMenu.add(report);
        _loadingInProgress = false;
  });
  }
 int currentIndex = 0;
 /// Set a type current number a layout class
Widget callPage(int current){
   if(menu.length >= current + 1){
     return SingleChildScrollView(
         child: Container(
       height: MediaQuery.of(context).size.height +100,
       child:HomeScreen(user: user, menu: menu[currentIndex],number: jlhKolom,urutan: current,),
         )
     );  
   }else{
     return ReportScreen();
   }
    
 }

 /// Build BottomNavigationBar Widget
 @override
 Widget build(BuildContext context) {
  //return  menu.length > 0 ?
   return Scaffold(
   body:callPage(currentIndex),
  bottomNavigationBar:Theme(
       data: Theme.of(context).copyWith(
           canvasColor: Colors.white,
           textTheme: Theme.of(context).textTheme.copyWith(
               caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
       child:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        fixedColor: Color(0xFF6991C7),
        onTap: (value) async{
          setState(() {
            currentIndex = value;
         });
          await getMenu();
        },
         items:bottomMenu
       ),
  ));
  //):ReportScreenVip();
 }
}

