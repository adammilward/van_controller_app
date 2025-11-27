part of 'api.dart';

class TestApi extends AbstractApi {

  @override
  String get name => 'test';

  @override
  bool send(String command) {
    debugPrint('TestSender sending command: $command');
    _listenToIncomingData(sample2);
    return true;
  }

  void _listenToIncomingData(String data) {
    _processIncomingData(data);
  }

  String sample0 =
    """sdkfk;lgs
      <{'type': 'lights', 'payload': {
      'r': -0.10
      ,'g': -0.10
      ,'b': -0.10
      ,'l': 1
      ,'u': 255.00
      ,'range': 254.00
      ,'lightMode': [0,2]
      ,'delay': 0
      ,'fadeDelay': 0
      ,'reportDelay': 0
      }}>
      asljdfa
      """;

  String sample1 = "<Arduino is ready to recieve>\r\n<{'type': 'lights', 'payload': {\r\n'r': 0.1\r\n,'g': 0.1\r\n,'b': 0.1\r\n,'delay': 1100\r\n,'fadeDelay': 2100\r\n,'reportDelay': 310\r\n}}>\r\n<{'type': 'request', 'payload': 'report'}>\r\n\r\n<{'type': 'lights', 'payload': 'command not recognised'}>\r\nCommand not recognised, options are:\r\nCommand not recognised, options are:\r\n- Single Word Commands \r\n";

  String sample2 = """
      <{'type': 'lights', 'payload': {
      'r': -0.10
      ,'g': -0.10
      ,'b': -0.10
      ,'l': 1
      ,'u': 255.00
      ,'range': 254.00
      ,'lightMode': [0,2]
      ,'delay': 0
      ,'fadeDelay': 0
      ,'repo
      rtDelay': 0
      }}>


      <{'type': 'time', 'payload': {'timeTs': 1726328164
      ,'temp': 9.25
      ,'reportDelay': 0}}>sdlfkjgs
      sdlfkgjs


      sdg






      <{'type': 'status', 'payload': {
      'timestamp': 1726328167
      ,'temp': 9.25
      ,'a0': 7.742,'a1': 10.145,'a2': 3.818,'a3': 4.189,'a4': 4.576,'delay': 0.000}}>

      """;
}
