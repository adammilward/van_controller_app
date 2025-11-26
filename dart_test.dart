
    String data =
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
void main() {

  data = data.replaceAll(RegExp(r"\'"), "\"");
  print(data);


  var regExp = RegExp(r'\<\{(.*?)\}\>', multiLine: true, dotAll: true);



  var matches = regExp.allMatches(data);
  print(matches.length);
  for (final m in matches) {
    print(m);
    String match = m[0]!;
    print(match);
  }

}
