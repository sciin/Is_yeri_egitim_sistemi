import 'test.dart';
import 'package:flutterprojeapp/functions.dart';
void main()
{


  var functions = new Functions();
  test('empty username and password', ()
  {
    var result = functions.verifyEmail('');
    expect(result,'Kullanıcı adı boş bırakılamaz');

  });

  test('empty username and password', ()
  {
    var result = functions.verifyEmail('hasan');
    expect(result,null);
  });

  test('Check notification content',()
  {
    var result = functions.verifyNotification('Duyuru-Icerik');
    expect(result,null);
  });

  test('Check empty notification content',()
  {
    var result = functions.verifyNotification('');
    expect(result,'Duyuru içerik alanı boş bırakılamaz');
  });

  test('Check title',()
  {
    var result = functions.verifyNotificationTitle('Duyuru-Baslik');
    expect(result,null);
  });
  test('Check empty title',()
  {
    var result = functions.verifyNotificationTitle('');
    expect(result,'Duyuru başlık alanı boş bırakılamaz');
  });

  test('Check Post title',()
  {
    var result = functions.verifyPostTitle('');
    expect(result,'Duyuru başlık alanı boş bırakılamaz');
  });

  test('Check Post title',()
  {
    var result = functions.verifyPostTitle('Post title');
    expect(result,null);
  });

  test('Verify name',()
  {
    var result = functions.verifyName('Jeff');
    expect(result,null);
  });

  test('Verify empty name',()
  {
    var result = functions.verifyName('');
    expect(result,'Ad alanı Boş Bırakılamaz');
  });

  test('Verify lastname',()
  {
    var result = functions.verifyLastName('Boss');
    expect(result,null);
  });

  test('Verify empty lastname',()
  {
    var result = functions.verifyLastName('');
    expect(result,'Soyad alanı Boş Bırakılamaz');
  });


  test('Verify PhoneNumber',()
  {
    var result = functions.verifyPhoneNumber('5551112233');
    expect(result,null);
  });

  test('Verify empty PhoneNumber',()
  {
    var result = functions.verifyPhoneNumber('');
    expect(result,'Telefon Numarası Boş Bırakılamaz');
  });


  test('Check Email',()
  {
    var result = functions.verifyRegisterEmail('info@test.com');
    expect(result,null);
  });

  test('Check empty Email',()
  {
    var result = functions.verifyRegisterEmail('');
    expect(result,'Email alanı boş bırakılamaz');
  });

  test('Check Department',()
  {
    var result = functions.verifyDepartment('info@test.com');
    expect(result,null);
  });

  test('Check empty Department',()
  {
    var result = functions.verifyDepartment('');
    expect(result,'Bölüm alanı boş bırakılamaz');
  });

  test('Check Consultant',()
  {
    var result = functions.verifyConsultant('Eyup');
    expect(result,null);
  });

  test('Check empty Consultant',()
  {
    var result = functions.verifyConsultant('');
    expect(result,'Danışman alanı boş bırakılamaz');
  });



}

