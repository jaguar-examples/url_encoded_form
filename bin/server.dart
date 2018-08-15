library upload_files.server;

import 'package:jaguar/jaguar.dart';

main(List<String> args) async {
  final server = Jaguar(port: 10000);

  server.post('/api/addition', (ctx) async {
    final Map<String, String> formData = await ctx.bodyAsUrlEncodedForm();
    int a = int.tryParse(formData['a']);
    int b = int.tryParse(formData['b']);
    if (a == null || b == null) return Redirect(Uri.parse("/error"));
    return Redirect(Uri.parse("/result/$a/$b"));
  });

  server.html(
      '/',
      (ctx) => '''
<html>
  <head>
    <title>Form example</title>
  </head>
  
  <body>
    <h1>Form example</h1>
    
    <form action="/api/addition" method="post" id="adder">
      A: <input type="number" name="a">
      B: <input type="number" name="b">
      <button type="submit" form="adder" value="Submit">Submit</button>
    </form>
  </body>
</html>  
  ''',
      responseProcessor: htmlResponseProcessor);

  server.html(
      '/result/:a/:b',
      (ctx) => '''
<html>
  <head>
    <title>Result</title>
  </head>
  
  <body>
    Result is <strong>${ctx.pathParams.getInt('a', 0) + ctx.pathParams.getInt('b', 0)}</strong>
  </body>
</html> 
  ''');

  server.html(
      '/error',
      (ctx) => '''
<html>
  <head>
    <title>Error</title>
  </head>
  
  <body>
    There was an error!
  </body>
</html> 
  ''');

  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}
