import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:promise/Library/SharedPref.dart';
import 'package:promise/Services/apiNetwork.dart';
import 'package:promise/UI/BottomNavigationBarVip.dart';
import 'package:promise/UI/HomeUIComponent/home.dart';
import 'package:promise/UI/LoginOrSignup/LoginAnimation.dart';
import 'package:promise/UI/Component/Button.dart';
import 'package:promise/UI/Component/Input.dart';
import 'package:promise/UI/Component/Validation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:promise/Library/model/model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:promise/UI/BottomNavigationBar.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}
/// Component Widget this layout UI
class _loginScreenState extends State<loginScreen>
    with TickerProviderStateMixin {
  //Animation Declaration
  AnimationController sanimationController;

  var tap = 0;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formLupa = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autovalidate = false, _loadingInProgress = false,_autovalidatelupa = false;
  final LocalStorage storage = new LocalStorage('promise_app');
  UserLogin login = UserLogin();
  UserData user = new UserData();
  NetworkUtil net = NetworkUtil();
  ValidationsLogin _validationsLogin = ValidationsLogin();
  String device_id ;
  SharedPref pref = SharedPref();
  String email;
  @override
  /// set state animation controller
  void initState() {
    sanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((statuss) {
            if (statuss == AnimationStatus.dismissed) {
              setState(() {
                tap = 0;
              });
            }
          });
          checkLogin();
    // TODO: implement initState
    super.initState();
  }

  /// Dispose animation controller
  @override
  void dispose() {
    super.dispose();
    sanimationController.dispose();
  }

  /// Playanimation set forward reverse
  Future<Null> _PlayAnimation() async {
    try {
      await sanimationController.forward();
      await sanimationController.reverse();
    } on TickerCanceled {}
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  checkLogin() async{
    login.username = await pref.read('username');
    login.password = await pref.read('password');
    if(login.username != null){
      setState(() {
         _loadingInProgress = true;
      });
      net.getAuth('login', user: login).then((result) async{
        if (result['sukses'] == 'true'){
           setState(() {
            _loadingInProgress = false;
          });
           await storage.setItem('AUTH', result['data']);
           user = UserData.map(result['data']);
          if(result['menu'].length > 0){
             await storage.setItem('MENU', result['menu']);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new bottomNavigationBar()));
          }else{
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => new bottomNavigationVip())); 
          }          
         }else{
            setState(() {
            _loadingInProgress = false;
          });
          showInSnackBar(result['keterangan']);
         }
      });
    }
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
      net.getAuth('login', user: login).then((result) async{
        
        pref.save('username', login.username);
        pref.save('password', login.password);
        if (result['sukses'] == 'true'){
            setState(() {
            _loadingInProgress = false;
          });
           await storage.setItem('AUTH', result['data']);
          if(result['menu'].length > 0){
             await storage.setItem('MENU', result['menu']);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => new bottomNavigationBar()));
          }else{
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => new bottomNavigationVip())); 
          } 
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

  sendEmail(){
    final FormState form = _formLupa.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Silahkan perbaiki pada error berwarna merah..');
    } else {
      setState(() {
        _loadingInProgress = true;
      });
      form.save();
      net.kirimEmail('lupa_password', email: email).then((result) async{
        if(result['sukses']==false){
            setState(() {
                _loadingInProgress = false;
              });
          showInSnackBar(result['keterangan']);
        }else{
          Navigator.of(context).pop();
          showInSnackBar(result['keterangan']);
        }
          setState(() {
                _loadingInProgress = false;
              });
          
      });

    }
  }
  
emailForm() {
   showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
        builder: (context, passwordchange) {
        return AlertDialog(
          title: new Text("Lupa Password",
          style: TextStyle(fontFamily: 'sans',fontSize: 16.0,fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
        child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Builder(
                builder: (context) => Form(
                  key: _formLupa,
                  autovalidate: _autovalidatelupa,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      /// TextFromField Email
                      textFromInput(
                        password: false,
                        text: "Masukan email terdaftar",
                        validateFunction:_validationsLogin.validateEmail,
                        onSaved: (val) {
                         setState(() {
                           email = val;
                         });
                        },
                        inputType:
                            TextInputType.emailAddress,
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
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Kirim"),
              onPressed: () {
               sendEmail();
              },
            ),
            
          ],
        );
        });
      },
    );
}
  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.width;
    mediaQueryData.size.height;
    return SafeArea(
      child:  ModalProgressHUD( 
      child:Scaffold(
        key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in layout (Click to open code)
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(29, 122, 140, 0.2),
                Color.fromRGBO(15, 100, 116, 1)
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
            ),
          ),
        child: SingleChildScrollView(
           child:Container(
          // /// Set gradient color in image (Click to open code)
          // width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          
          /// Set component layout
          child: Column(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          children: <Widget>[
                            /// padding logo
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         top: mediaQueryData.padding.top + 40.0)),
                            
                            Container(
                              margin: EdgeInsets.only(top:50),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/3.2,
                              child: Image.asset('assets/logo.png', fit: BoxFit.fitHeight,),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:10),
                              child: Text('PROMISE', style: TextStyle(fontSize: 24,color: Colors.yellow,fontWeight: FontWeight.w600, letterSpacing: 0.5),),

                            ),
                            Padding(
                              padding: EdgeInsets.only(top:10),
                              child: Text('Performance Early Warning System', style: TextStyle(fontSize: 16,color: Colors.yellow),),

                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                              Text('Silahkan Login untuk Mulai',style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'sans',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                shadows: [
                                  BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10.0,
                                  spreadRadius: 15.0,
                                  offset: Offset(10, 10)
                                ),
                                ]
                              ),),
                             Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Builder(
                                  builder: (context) => Form(
                                        key: _formKey,
                                        autovalidate: _autovalidate,
                                        child: Column(
                                          children: <Widget>[
                                          textFromField(
                                            onSaved: (val){
                                                login.username = val;
                                            },
                                           validateFunction: _validationsLogin.validateUsername,
                                            icon: Icons.person_outline,
                                            password: false,
                                            text: "username",
                                            inputType: TextInputType.text,
                                          ),

                                          /// TextFromField Password
                                          Padding(
                                              padding: EdgeInsets.symmetric(vertical: 5.0)),
                                          textFromField(
                                            onSaved: (val){
                                              login.password = val;
                                            },
                                            validateFunction: _validationsLogin.validatePassword,
                                            icon: Icons.vpn_key,
                                            password: true,
                                            text: "Password",
                                            inputType: TextInputType.text,
                                          ),
                                          ],
                                        ),
                                  )
                                ),
                                ),
                           
                             Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0)),
                      tap == 0
                      ? InkWell(
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
                          child:tombol(text: 'Login',height: 55.0, width: mediaQueryData.size.width - 55,colorsfrom: Color.fromRGBO(14, 83, 96, 1),colorsto: Color.fromRGBO(14, 83, 96, 1),),
                        )
                      : new LoginAnimation(
                          animationController: sanimationController.view,
                        ),
                       
                          
                           FlatButton(
                                padding: EdgeInsets.only(top: 20.0),
                                onPressed: () {
                                  emailForm();
                                },
                                child: Text(
                                  "Lupa Password ?",
                                  style: TextStyle(
                                      // shadows:[
                                      //   BoxShadow(
                                      //     blurRadius: 5,
                                      //     spreadRadius: 10,
                                      //     color: Colors.white,
                                      //   )
                                      // ],
                                      color: Colors.yellow,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                      fontFamily: "Sans"),
                                )),
                           
                          ],
                        ),
                      ),
                    ],
                  ),
                  /// Set Animaion after user click buttonLogin
                  
        )
        )
      ),
    ),inAsyncCall: _loadingInProgress,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.black12,
        ),
      )
    );
  }
}
