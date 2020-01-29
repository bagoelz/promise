import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:promise/Library/SharedPref.dart';
import 'package:localstorage/localstorage.dart';
import 'package:promise/Library/model/model.dart';
import 'package:promise/Services/apiNetwork.dart';
import 'package:promise/UI/LoginOrSignup/Login.dart';
import 'package:promise/UI/Component/input.dart';
import 'package:promise/UI/Component/Validation.dart';
import 'package:flutter/services.dart';
class ReportScreenVip extends StatefulWidget {
  UserData user;
 List<DataRow> report;
 List<DataColumn> kolomJudul;
 GestureTapCallback onTap;
  ReportScreenVip({Key key,this.report,this.kolomJudul, this.onTap,this.user}) : super(key: key);

  @override
  _ReportScreenVipState createState() => _ReportScreenVipState();
}
 List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Ganti Password', id:0),
  CustomPopupMenu(title: 'Log Out', id:1),
];

class _ReportScreenVipState extends State<ReportScreenVip> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formGanti = new GlobalKey<FormState>();
final LocalStorage storage = new LocalStorage('promise_app');
 SharedPref pref = SharedPref();
 CustomPopupMenu _selectedChoices = choices[0];
 ChangePassword _changePassword = ChangePassword();
 bool _autovalidateGanti=false,_loadingInProgress=false;
 ValidationsLogin validate =ValidationsLogin();
 NetworkUtil net = NetworkUtil();
  void initState() {
    // TODO: implement initState
    super.initState();
  }
 signOut() async{
   await storage.clear();
   await pref.clear();
   Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new loginScreen()));
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
 void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
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
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('LAPORAN'),
          actions: <Widget>[
           InkWell(
             onTap: (){
               widget.onTap();
             },
             child:  Icon(Icons.search),
           ),
            Padding(
                                    padding: EdgeInsets.only(left:5, right:5,),
                                    child: PopupMenuButton<CustomPopupMenu>(
                                      icon: Icon(Icons.more_vert,color: Colors.black,size: 30,),
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
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
        Container(
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
            )
      ),
      )
    );
  }
}
