import 'package:flutter/material.dart';

class tombol extends StatelessWidget {
  String text;
  double width,height,top,bottom,left,right;
  Color colorsfrom,colorsto;
  GestureTapCallback onTap;
  tombol({this.text, this.colorsfrom,this.colorsto, this.onTap, this.width,this.height, this.bottom,this.top,this.left,this.right});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
      padding: EdgeInsets.only(top: top != null ? top : 0.0, bottom: bottom != null ? bottom : 0.0,left: left != null ? left : 0.0,right: right != null ? right : 0.0),
      child: Container(
        height: height,
        width: width,
        child: Text(
          text.toString(),
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.2,
              fontFamily: "Sans",
              fontSize: 18.0,
              fontWeight: FontWeight.w800),
        ),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
           // boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
                colors: <Color>[ colorsfrom != null ? colorsfrom :  Color.fromARGB(200, 217,7,32),
                colorsto != null ? colorsto : Color.fromARGB(200, 150,1,10),],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.1, 1.0],
                tileMode: TileMode.clamp)),
      ),
    ),
    );
  }
}


class buttonCustomFacebook extends StatelessWidget {
  GestureTapCallback onTap;
  buttonCustomFacebook({this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: 
      Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        alignment: Alignment.center,
        height: 49.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(107, 112, 248, 1.0),
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15.0)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/img/icon_facebook.png",
              height: 25.0,
            ),
          ],
        ),
      ),
    ),
    );
  }
}

///buttonCustomGoogle class
class buttonCustomGoogle extends StatelessWidget {
  GestureTapCallback onTap;
  buttonCustomGoogle({this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        alignment: Alignment.center,
        height: 49.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.0)],
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/img/google.png",
              height: 25.0,
            ),
           
            // Text(
            //   "Login With Google",
            //   style: TextStyle(
            //       color: Colors.black26,
            //       fontSize: 15.0,
            //       fontWeight: FontWeight.w500,
            //       fontFamily: 'Sans'),
            // )
          ],
        ),
      ),
    ),
    );
  }
}