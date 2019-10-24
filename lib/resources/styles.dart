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

Widget txtHeadline(BuildContext context, String t, Color clr) {
  TextStyle ts = Theme.of(context).textTheme.headline;
  if (clr != null) {
    ts = ts.copyWith(color: clr);
  }
  return Text(t, style: ts);
}

Color clr(BuildContext context, String sel) {
  Color col;
  if (sel == 'accent') {
    col = Theme.of(context).accentColor;
  } else if (sel == 'primary') {
    col = Theme.of(context).primaryColor;
  }
  return col;
}

SizedBox sbox(double h, double w) {
  return SizedBox(height: h, width: w);
}

Widget grey18(String t) {
  return Text(t, style: TextStyle(fontSize: 18.0, color: Colors.grey));
}
