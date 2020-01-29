import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:promise/Library/SharedPref.dart';
import 'package:promise/Services/apiNetwork.dart';
import 'package:promise/UI/BottomNavigationBar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:promise/Library/model/model.dart';
import 'package:promise/UI/Component/Validation.dart';
import 'package:promise/UI/Component/input.dart';
import 'package:promise/UI/Component/Button.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:promise/UI/LoginOrSignup/Login.dart';


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

class HomeScreen extends StatefulWidget {
   UserData user;
   Menu menu;
   double number;
   int urutan;
  HomeScreen({Key key, this.user, this.menu, this.number, this.urutan}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "Sans",
);
 List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Ganti Password', id:0),
  CustomPopupMenu(title: 'Log Out', id:1),
];
/// Get _txt and custom value of Variable for Name User
var _txtName = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 17.0);
var txtJabatan = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 12.0);
var txtKantor = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0);
class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formGanti = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool  _loadingInProgress = false, _autovalidate =false, _autovalidateGanti =false;
  String uid;
  NetworkUtil net = NetworkUtil();
  List body = [];
  double jlhKolom;
  ValidationsLogin validate =ValidationsLogin();
  final LocalStorage storage = new LocalStorage('promise_app');
  List<Menu> dataMenu = <Menu>[];
  ChangePassword _changePassword = ChangePassword();

  var _select;
  SharedPref pref = SharedPref();
  CustomPopupMenu _selectedChoices = choices[0];

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser(){
    setState(() {
       _loadingInProgress = true;
     });
   if(widget.user != null){
     setState(() {
       _loadingInProgress = false;
     });
   }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  
  signOut() async{
   await storage.clear();
   await pref.clear();
   Navigator.of(context).pushReplacement(MaterialPageRoute(
     fullscreenDialog: false,
            builder: (BuildContext context) => new loginScreen()));
  }
   void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Silahkan perbaiki pada error berwarna merah..');
    } else {
      setState(() {
        _loadingInProgress = true;
      });
      form.save();
      net.sendData('input', body, user_id: widget.user.uid,id_role: widget.user.role, nama_bidang: widget.user.bidang).then((result) async{
        if (result['sukses'] == true){
              body=[];
              await storage.setItem('MENU', result['menu']);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => bottomNavigationBar()));
                     //  });
         }else{
             setState(() {
        _loadingInProgress = false;
      });
          showInSnackBar(result['keterangan']);
         }
      }).catchError((PlatformException onError) {
        setState(() {
        _loadingInProgress = false;
      });
        showInSnackBar(onError.details);
      });
     }
  }

  
passwordForm() {
   showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
        builder: (context, passwordchange) {
        return AlertDialog(
          title: new Text("Ganti Password",
          style: TextStyle(fontFamily: 'sans',fontSize: 16.0,fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
        child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Builder(
                builder: (context) => Form(
                  key: _formGanti,
                  autovalidate: _autovalidateGanti,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      /// TextFromField Email
                      textFromInput(
                        password: true,
                        text: "Password lama",
                        validateFunction:
                            validate.validatePassword,
                        onSaved: (val) {
                          _changePassword.password =val;
                        },
                        inputType:
                            TextInputType.text,
                      ),

                      /// TextFromField Password
                      textFromInput(
                        password: true,
                        validateFunction:
                            validate.validatePassword,
                        onSaved: (val) {
                          _changePassword.newpassword = val;
                        },
                        text: "Password Baru",
                        inputType: TextInputType.text,
                      ),
                       textFromInput(
                        password: true,
                        validateFunction:
                            validate.validatePassword,
                        onSaved: (val) {
                         _changePassword.repeatpassword = val;
                        },
                        text: "Ulangi Password",
                        inputType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ),
              )
            ),
      ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Batal", style: TextStyle(color: Colors.grey),),
              onPressed: () {
                _changePassword.newpassword='';
                _changePassword.password ='';
                _changePassword.repeatpassword='';
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Ganti"),
              onPressed: () {
                gantiPassword();
              },
            ),
            
          ],
        );
        });
      },
    );
}

  void gantiPassword() async {
    final FormState form = _formGanti.currentState;
    setState(() {
      _loadingInProgress = true;
    });

    if (!form.validate()) {
      _autovalidateGanti = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      net.tukarPassword('ubah_password',userid:widget.user.uid, password: _changePassword).then((onValue) {
        if(onValue['sukses']==false){
            setState(() {
                _loadingInProgress = false;
              });
          showInSnackBar(onValue['keterangan']);
        }else{
           setState(() {
                _loadingInProgress = false;
              });
         signOut();
        }
          setState(() {
                _loadingInProgress = false;
              });
      }).catchError((PlatformException onError) {
        setState(() {
                _loadingInProgress = false;
              });
        showInSnackBar(onError.message);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var _profile = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         widget.user.gambar!= null ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.5),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage( widget.user.gambar.toString()), fit: BoxFit.contain)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                widget.user?.displayName != null ?  widget.user.displayName :'',
                style: _txtName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child:Text( widget.user.namaRole.toString()+' - '+ widget.user.bidang.toString(),
                style: txtJabatan,
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child:Text( widget.user.kodeKantor +' - ' +  widget.user.namaKantor,
                style:txtKantor,
              ),
            ),

            // InkWell(
            //   onTap: null,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 0.0),
            //     child: Text(
            //       "Edit Profile",
            //       style: _txtEdit,
            //     ),
            //   ),
            // ),
          ],
        ):Container(
               height: 100.0,
              width: 100.0,
              child: Icon(Icons.person,size: 50,),
               decoration: BoxDecoration(
                 color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 2.5),
                  shape: BoxShape.circle,)
            ),
        Container(

        ),
      ],
      );
    
    return ModalProgressHUD(
        child:Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          body: !_loadingInProgress ? Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom:20),
              height: MediaQuery.of(context).size.height -40,
              child: SingleChildScrollView(
                child: Column(
                      children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                          height: 180.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/header.jpg"),
                                  fit: BoxFit.cover)),
                        // make sure we apply clip it properly
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left:10, right:5, top:30),
                                    child: PopupMenuButton<CustomPopupMenu>(
                                      icon: Icon(Icons.more_vert,color: Colors.white,size: 30,),
                                      elevation: 3.2,
                                      initialValue: choices[1],
                                      onCanceled: () {
                                        print('You have not chossed anything');
                                      },
                                      tooltip: 'This is tooltip',
                                      onSelected: (val){
                                       if(val.id==1){
                                         signOut();
                                       }else{
                                         passwordForm();
                                       }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return choices.map((CustomPopupMenu choice) {
                                          return PopupMenuItem<CustomPopupMenu>(
                                            value: choice,
                                            child: Text(choice.title),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  )
                            
                                ],
                        ),
                        ),
                              Padding(
                                padding: EdgeInsets.only(top:100),
                                child: _profile,
                              ),
                              
                            ],
                          ),
                          
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                           Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(widget.menu.judul.toUpperCase(),style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                                      ),
                           
                          Divider(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width -20,
                              child: 
                                  Builder(
                                    builder:(context) => Form(
                                        key: _formKey,
                                        autovalidate: _autovalidate,
                                        child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(widget.menu.baris.length, (index){
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            boxShadow: [BoxShadow(
                                              blurRadius: 5,
                                              spreadRadius: 5,
                                              offset: Offset(2, 5),
                                              color: Colors.grey[300]
                                            )],
                                            //border: Border.all(color: Colors.grey[400])
                                          ),
                                          child:Column(
                                            children: <Widget>[
                                                Container(
                                            height: 20,
                                            width: MediaQuery.of(context).size.width,
                                           child: Text(widget.menu.baris[index].judul,softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14, color: Colors.black),),
                                            ),
                                          Container(
                                            height: widget.menu.baris[index].input.length.toDouble() * 50,
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                        Container(
                                           height: 40,
                                              width: MediaQuery.of(context).size.width / 2,
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                  child: Text(widget.menu.baris[index].realisasi.judul.toString(),softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontSize: 10,color: Colors.black),),
                                              ),
                                              
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                  child: Text(formatuang(double.parse(widget.menu.baris[index].realisasi.nilai.toString())),softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontSize: 12),),
                                              )
                                            ],
                                            
                                          )
                                        ),
                                      Container(
                                        height: widget.menu.baris[index].input.length.toDouble() * 45,
                                         width: MediaQuery.of(context).size.width / 3,
                                        child:Column(
                                          children:  List.generate(widget.menu.baris[index].input.length, (urutan){
                                            return Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 5),
                                                  child: textFromInput(
                                                  password: false,
                                                  onSaved: (val){
                                                    body.add({'key':widget.menu.baris[index].input[urutan].nilai.toString(),'value':val == '' ? '0' :val});
                                                  },
                                                  //validateFunction: validate.validateCharacter,
                                                  text:widget.menu.baris[index].input[urutan].judul,
                                                  inputType: TextInputType.number,
                                                ),
                                                ),
                                              );
                                        }),
                                        )
                                      ) , 
                                        
                                              ],
                                            ),
                                         
                                            ),
                                      
                                            ],
                                          ));
                                      }),
                                    ),
                                  ),
                                  )
                            ),
                            InkWell(
                          splashColor: Colors.yellow,
                          onTap: () {
                            _handleSubmitted();
                            // setState(() {
                            //   tap = 1;
                            // });
                            // new LoginAnimation(
                            //   animationController: sanimationController.view,
                            // );
                            // _PlayAnimation();
                            // return tap;
                          },
                          child:tombol(text: 'Kirim',height: 50.0, width: MediaQuery.of(context).size.width - 50,colorsfrom: Color.fromRGBO(81, 175, 51, 1),colorsto: Color.fromRGBO(65, 151, 38, 1),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                          padding: EdgeInsets.only(left:10,top:10),
                          child: Text('* TARGET',softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16, color: Colors.black),),
                        ),
                        ),
                       Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(widget.menu.baris.length, (index){
                            return   widget.menu.baris[index].target?.judul != null ?  Container(
                              padding: EdgeInsets.only(left:10,top:10),
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.all(Radius.circular(10)),
                              //   boxShadow: [BoxShadow(
                              //     blurRadius: 5,
                              //     spreadRadius: 5,
                              //     offset: Offset(2, 5),
                              //     color: Colors.grey[300]
                              //   )],
                              //   //border: Border.all(color: Colors.grey[400])
                              // ),
                              child:Column(
                                children: <Widget>[
                                    Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                child: Text(widget.menu.baris[index].judul.toUpperCase(),softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14, color: Colors.black),),
                                ),
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                          Container(
                                height: 20,
                              child: index == widget.menu.baris.length -1 ? Row(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text(widget.menu.baris[index].target.judul.toString(),softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w500,)),
                                  ),
                                  
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text(' - Rp ' + formatuang(double.parse(widget.menu.baris[index].target.nilai.toString())),softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontSize: 12),),
                                  )
                                  
                                ],
                              ):Row(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text(widget.menu.baris[index].target.judul.toString(),softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w500,)),
                                  ),
                                  
                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Text(' - ' + formatuang(double.parse(widget.menu.baris[index].target.nilai.toString())),softWrap: true,textAlign: TextAlign.left,style: TextStyle(fontSize: 12),),
                                  )
                                  
                                ],
                              )
                            ),
                                  ],
                                ),
                              
                                ),
                          
                                ],
                              )):Container();
                          }),
                        ),
                              ],
                            
                            )
                          ),
                           
                      ],
                    ),
              )
                    
            ),
          
          ],
        ):Container(
          child: Center(child:Text('Please Wait')),
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
