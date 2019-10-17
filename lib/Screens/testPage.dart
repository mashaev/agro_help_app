import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text('Overline', style: Theme.of(context).textTheme.overline),
          Text('Caption', style: Theme.of(context).textTheme.caption),
          Text('Button', style: Theme.of(context).textTheme.button),
          Text('body1 blear suka', style: Theme.of(context).textTheme.body1),
          Text('body2 blear suka', style: Theme.of(context).textTheme.body2),
          Text('subtitle blear suka',
              style: Theme.of(context).textTheme.subtitle),
          Text('subhead', style: Theme.of(context).textTheme.subhead),
          Text('Title blear suka', style: Theme.of(context).textTheme.title),
          Text('headline', style: Theme.of(context).textTheme.headline),
          Text('display1', style: Theme.of(context).textTheme.display1),
          Text('display2', style: Theme.of(context).textTheme.display2),
          Text('display3', style: Theme.of(context).textTheme.display3),
          Text('dsply4', style: Theme.of(context).textTheme.display4),
        ],
      ),
    );
  }
}
