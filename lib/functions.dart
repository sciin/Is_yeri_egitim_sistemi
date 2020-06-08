class Functions
{
   String verifyEmail(String girilenDeger)
  {
    return girilenDeger.isEmpty? "Kullanıcı adı boş bırakılamaz" : null;
  }
   //KayitOl.dart line: 342 validator: functions.verifyPassword
   //KayitOl.dart line: 521 validator: functions.verifyPassword
   //KayitOl.dart line: 628 validator: functions.verifyPassword
   String verifyPassword(String girilenDeger)
  {
    return girilenDeger.isEmpty? "Şifre alanı boş bırakılamaz" : null;
  }

   // duyuruEkle.dart line:131  validator: functions.verifyNotification,
   // ilanduzenle.dart line:138  validator: functions.verifyNotification,
   // ilanEkle.dart line:116  validator: functions.verifyNotification,
   String verifyNotification(String input)
   {
     return input.isEmpty? "Duyuru içerik alanı boş bırakılamaz" : null;
   }
   //duyuruEkle.dart line: 102 validator: functions.verifyNotificationTitle
   String verifyNotificationTitle(String input)
   {
     return input.isEmpty? "Duyuru başlık alanı boş bırakılamaz" : null;
   }

   //ilanEkle.dart line: 79 validator: functions.verifyPostTitle
   String verifyPostTitle(String input)
   {
     return input.isEmpty? "İlan Başlığı alanı boş bırakılamaz" : null;
   }

   //KayitOl.dart line: 258 validator: functions.verifyName
   //KayitOl.dart line: 419 validator: functions.verifyName
   //KayitOl.dart line: 552 validator: functions.verifyName
   String verifyName(String input)
   {
     return input.isEmpty? "Ad alanı Boş Bırakılamaz" : null;
   }

   //KayitOl.dart line: 283 validator: functions.verifyLastName
   //KayitOl.dart line: 444 validator: functions.verifyLastName
   String verifyLastName(String input)
   {
     return input.isEmpty? "Soyad alanı Boş Bırakılamaz" : null;
   }

   //KayitOl.dart line: 308 validator: functions.verifyPhoneNumber
   //KayitOl.dart line: 469 validator: functions.verifyPhoneNumber
   //KayitOl.dart line: 577 validator: functions.verifyPhoneNumber
   String verifyPhoneNumber(String input)
   {
     return input.isEmpty? "Telefon Numarası Boş Bırakılamaz" : null;
   }

   //KayitOl.dart line: 342 validator: functions.verifyRegisterEmail
   //KayitOl.dart line: 503 validator: functions.verifyRegisterEmail
   //KayitOl.dart line: 610 validator: functions.verifyRegisterEmail
   //kisiselBilgiDuzenle.dart line: 112 validator: functions.verifyRegisterEmail
   //kisiselBilgiDuzenle.dart line: 212 validator: functions.verifyRegisterEmail
   //kisiselBilgiDuzenle.dart line: 301 validator: functions.verifyRegisterEmail
   String verifyRegisterEmail(String input)
   {
     return input.isEmpty? "Email alanı boş bırakılamaz" : null;
   }



   //kisiselBilgiDuzenle.dart line: 134 validator: functions.verifyDepartment
   String verifyDepartment(String input)
   {
     return input.isEmpty? "Bölüm alanı boş bırakılamaz" : null;
   }

   //kisiselBilgiDuzenle.dart line: 156 validator: functions.verifyConsultant
   String verifyConsultant(String input)
   {
     return input.isEmpty? "Danışman alanı boş bırakılamaz" : null;
   }
}