import 'package:shared_preferences/shared_preferences.dart';
import 'package:ansicolor/ansicolor.dart';
export 'strings.dart';
export 'styles.dart';

SharedPreferences session;

cprint(String msg) {
  AnsiPen pen = new AnsiPen()
    ..white()
    ..rgb(r: 1.0, g: 0.8, b: 0.2);

  print(pen(msg));
}
