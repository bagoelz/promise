class ValidationsLogin{
   String validateUsername(String value) {
    if (value.isEmpty) return 'Nama user harus di isi';
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9_./]+$');
    if (!nameExp.hasMatch(value))
      return 'hanya . / _  dan alphabet yang di izinkan';
    return null;
  }

    String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!nameExp.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Password harus di isi';
    return null;
  }

  String validatePhone(String value) {
    if (value.isEmpty) return 'Nomor telepon harus diisi';
    // final RegExp nameExp = new RegExp(r'^[0-9]{13}$');
    // if (!nameExp.hasMatch(value))
    //   return 'Please enter only number';
    return null;
  }

   String validateAccount(String value) {
    if (value.isEmpty) return 'Account number is required';
    final RegExp nameExp = new RegExp(r'^[0-9]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateAccountHolder(String value) {
    if (value.isEmpty) return 'Please choose a password.';
     final RegExp nameExp = new RegExp(r'^[A-Za]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateCharacter(String value) {
    if (value.isEmpty) return '# # #';
    //  final RegExp nameExp = new RegExp(r'^[A-Za]+$');
    // if (!nameExp.hasMatch(value))
    //   return 'Please enter only alphabetical characters.';
    // return null;
  }

}