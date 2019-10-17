import 'package:flutter/material.dart';

Widget text15(String v) {
  return Text(v, style: TextStyle(fontSize: 15.0));
}

Widget text16(String v) {
  return Text(v, style: TextStyle(fontSize: 16.0));
}

Widget bold(String v) {
  return Text(v, style: TextStyle(fontWeight: FontWeight.bold));
}

Widget bold15(String t) {
  return Text(t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0));
}

Widget white(String t) {
  return Text(t, style: TextStyle(color: Colors.white));
}

Widget txtTitle(BuildContext context, String t, Color clr) {
  TextStyle ts = Theme.of(context).textTheme.title;
  if (clr != null) {
    ts = ts.copyWith(color: clr);
  }
  return Text(t, style: ts);
}

Widget txtSubhead(BuildContext context, String t, Color clr) {
  TextStyle ts = Theme.of(context).textTheme.subhead;
  if (clr != null) {
    ts = ts.copyWith(color: clr);
  }
  return Text(t, style: ts);
}
