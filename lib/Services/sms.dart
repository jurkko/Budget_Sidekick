import 'package:sms/sms.dart';

Future<void> main() async {
  SmsQuery query = new SmsQuery();
  List<SmsMessage> messages = await query.getAllSms;
  print(messages);
}
