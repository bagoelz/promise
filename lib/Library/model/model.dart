
import 'package:flutter/material.dart';

class UserData {
  String displayName,email,uid,password,kodeKantor,gambar, namaRole, kodeKanwil, namaKantor,role, bidang;
  int npk;

  UserData({this.displayName, this.email, this.uid, this.password});
  UserData.map(dynamic data){
    this.displayName = data['nama'];
    this.email =data['email'];
    this.uid = data['user_id'];
    this.role = data['id_role'];
    this.kodeKantor = data['kode_kantor'];
    this.gambar = data['gambar'];
    this.namaRole = data['nama_role'];
    this.kodeKanwil = data['kode_kanwil'];
    this.namaKantor = data['nama_kantor'];  
    this.bidang = data['nama_bidang'];  
    }
}

class UserLogin{
  String username, password;
  UserLogin({
    this.username,
    this.password,
  });
}

class Menu{
  String judul,menu;
  List<IconLogo> icon=[];
  List<IconLogo> get _iconlog => icon;
  List<JudulBaris> baris=[];
  List<JudulBaris> get _baris => baris; 
  Menu({
    this.judul,
    this.menu,
    this.baris,
  });
  Menu.map(dynamic data){
    this.menu= data['judul'];
    this.judul= data['judul_sub_menu'];
    data['judul_baris'].forEach((item){
      baris.add(JudulBaris.map(item));
    });
   if(data['icon']!= null){
    data['icon'].forEach((item){
      _iconlog.add(IconLogo.map(item));
    });
  }
  }
}

// class JudulKolom{
//   String judul;
//   JudulKolom({
//     this.judul
//   });
//   JudulKolom.map(dynamic data){
//     this.judul = data['judul'];
//   }
// }

class JudulBaris{
  String judul;
  TargetData target;
  RealisasiData realisasi;
  List<InputData> input=<InputData>[];

  JudulBaris({
    this.judul,
    this.input,
    this.realisasi,
  });
  JudulBaris.map(dynamic data){
    this.judul = data['judul'];
  data['input'].forEach((item){
    this.input.add(InputData.map(item));
  });
    
    this.target = TargetData.map(data['target']);
    this.realisasi = RealisasiData.map(data['realisasi']);
  }
}

class TargetData{
  String judul;
  int nilai;
  TargetData({
    this.judul,
    this.nilai,
  });
  TargetData.map(dynamic data){
    this.judul = data['judul'] == '' ? null : data['judul'];
    this.nilai = data['nilai']== '' ? null : data['nilai'];
  }
}

class RealisasiData{
  String judul;
  int nilai;
  RealisasiData({
    this.judul,
    this.nilai,
  });
  RealisasiData.map(dynamic data){
    this.judul = data['judul'];
    this.nilai = data['nilai'];
  }
}

class InputData{
  String judul,nilai;
  InputData({
    this.judul,
    this.nilai,
  });
  InputData.map(dynamic data){
    this.judul = data['judul'];
    this.nilai = data['nilai'];
  }
}


class IconLogo{
  String path; int size;
  IconLogo({
    this.path,
    this.size
  });
  IconLogo.map(dynamic data){
    this.path = data['path'];
    this.size = data['size'];
  }
}
class CustomPopupMenu {
  String title;
  IconData icon;
  int id;
  CustomPopupMenu({this.title, this.icon, this.id});
  
}
class ReportSegmen{
  String segmen;
  Color color;
  List<ReportJudul> ojudul=[];
  //List<ReportNilai> onilai=[];
  //List<ReportNilai> get nilai => onilai;
  List<ReportJudul> get judul => ojudul;
  ReportSegmen({
    this.segmen,
    this.ojudul,
    this.color,
    //this.onilai,
  });

  ReportSegmen.map(dynamic data){
    this.segmen=data['segmen'].toString();
     data['judul_baris'].forEach((item){
    this.ojudul.add(ReportJudul.map(item));
     });
    // data['nilai_baris'].forEach((item){
    //   this.onilai.add(ReportNilai.map(item));
    // });
    this.color = Colors.white;
  }
}

class ReportJudul{
  String judul;

  ReportJudul({
    this.judul,
  });

  ReportJudul.map(dynamic data){
    this.judul= data['judul'];
  }
}

class ReportNilai{
  String tanggal, tkPU, iuranPU;
  int data;

  ReportNilai({
    this.tanggal,
    this.data,
  });
 

  ReportNilai.map(dynamic data){
    this.tanggal = data['tanggal'];
    this.data=data['korekasi_data'];
  }
}

class ChangePassword {
  String password,newpassword,repeatpassword;
  ChangePassword({this.password,this.newpassword,this.repeatpassword});
}

class Saring{
  int id;
  String judul, value, teks;
  List<FilterPilihan> pilihanSaring=[];
  List<FilterPilihan> get dataSaring => pilihanSaring;
  Saring({
    this.judul,
    this.value,
    this.id,
    this.teks,
  });
  Saring.map(dynamic data){
    this.judul = data['judul'];
    this.value=data['value'];
    this.id=data['id'];
    this.teks="Tap untuk memilih";
    data['pilihan'].forEach((item){
      this.pilihanSaring.add(FilterPilihan.map(item));
    });
   
  }
}

class FilterPilihan{
  String value,id;
  bool selected;
  FilterPilihan({
    this.value,
    this.id,
    this.selected,
  });
  FilterPilihan.map(dynamic data){
    this.value =data['value'];
    this.id=data['id'];
    this.selected=data['selected'];
  }

}