import 'package:flutter/material.dart';

class textFromField extends StatelessWidget {
  bool password;
  String text;
  IconData icon;
  TextInputType inputType;
  var validateFunction;
  var onSaved;

  textFromField({this.text, this.icon, this.inputType, this.password, this.onSaved, this.validateFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 50.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextFormField(
            obscureText: password,
            validator: validateFunction,
            onSaved: onSaved,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: text,
                icon: Icon(
                  icon,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}


class textPayment extends StatelessWidget {
  bool password;
  String text;
  TextInputType inputType;
  TextEditingController textController;
  var onSaved;
  var validation;
  textPayment({this.text,this.inputType, this.password, this.textController, this.validation, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        height: 50.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.black38,
          ),
          child: TextFormField(
            controller: textController,
            obscureText: password,
            onSaved: onSaved,
            validator: validation,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: text,
                // icon: Icon(
                //   icon,
                //   color: Colors.black38,
                // ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}
 
class textFromInput extends StatelessWidget {
  bool password;
  String text;
  TextInputType inputType;
  var validateFunction;
  var onSaved;
  textFromInput({this.text,this.inputType, this.password, this.onSaved, this.validateFunction,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 40.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5.0,spreadRadius: 1, color: Colors.black12, offset: Offset(3,3)),
            ]),
            margin: EdgeInsets.only(right: 5),
        padding:
            EdgeInsets.only(left: 5.0, right: 10.0, top: 0.0, bottom: 2.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextFormField(
            obscureText: password,
            validator: validateFunction,
            onSaved: onSaved,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top:0.2),
                labelText: text,
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}
