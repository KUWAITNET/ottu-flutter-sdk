import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ottu_flutter_sdk/ottu_flutter_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('ottu_flutter_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OttuFlutterSdk.platformVersion, '42');
  });
}
