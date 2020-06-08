void expect(dynamic result,dynamic expectingResult)
{
  (result == expectingResult)?print('Test Passed: 1 passed'):print('Test Failed: 1 failed');
}
void test(String title,Function callback)
{
  print('Test: '+title);
  callback();
}
void main() {

  test('deneme',() {
    var result = 'ahmet';
    expect(result,'ahmet');
  });

}