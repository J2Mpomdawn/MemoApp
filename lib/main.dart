import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

double width;
final flexSP = StateProvider((_) => 4);

final dirfSNP = StateNotifierProvider<DirfSN>((_) => DirfSN());

class DirfSN extends StateNotifier<List<Df>> {
  DirfSN() : super([]);
  void add() {
    state = [...state, Df()];
    number++;
  }
}

int number = 0;
int select = 0;

class Df extends HookWidget {
  final n = number;
  final colorSP = StateProvider<Color>((_) => Colors.cyan);
  final enableSP = StateProvider((_) => false);
  Widget build(BuildContext context) {
    final _ = useFocusNode();
    _.addListener(() {
      if (_.hasFocus) {
        print('true');
        //context.read(enableSP).state = false;
      } else {
        print('false');
      }
    });
    final cp = useProvider(colorSP).state;
    final ep = useProvider(enableSP).state;
    return InkWell(
      onTap: () {
        print('$n');
        //
        select = n;
        context.read(colorSP).state = Colors.indigoAccent;
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width),
        child: Container(
          color: cp,
          child: Row(children: [
            Container(
              margin: EdgeInsets.only(right: 4),
              child: Icon(Icons.folder, color: Colors.yellowAccent),
              color: Colors.deepPurpleAccent,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 48),
              child: IntrinsicWidth(
                child: TextField(
                  controller: TextEditingController()..text = 'value',
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                  ),
                  enabled: ep,
                  focusNode: _,
                ),
              ),
            ),
          ], mainAxisSize: MainAxisSize.min),
        ),
      ),
    );
  }
}

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo with Flutter',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Memo(),
    );
  }
}

/////////////////////////////////////

class Textfield extends HookWidget {
  Widget build(BuildContext context) {
    final _ = useFocusNode();
    _.addListener(() {
      context.read(flexSP).state = _.hasFocus ? 5 : 4;
    });
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 5),
      ),
      minLines: 26,
      maxLines: null,
      focusNode: _,
    );
  }
}

/////////////////////////////////////

class Dirf extends HookWidget {
  build(BuildContext context) {
    final df = useProvider(dirfSNP.state);
    return Column(children: df, crossAxisAlignment: CrossAxisAlignment.start);
  }
}

class Memo extends HookWidget {
  //
  @override
  Widget build(BuildContext context) {
    /*final */ width = MediaQuery.of(context).size.width / /*3*/ 3.5;

    //final dirf = useProvider(dirfSNP.state);

    return Scaffold(
      /*
      width: 360
      height: 592
      */
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
          //
        },
        //
        child: Column(children: [
          Expanded(
            flex: context.read(flexSP).state,
            child: Container(
              color: Colors.red,
              child: ButtonTheme(
                minWidth: 10,
                height: 10,
                padding: EdgeInsets.all(0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Row(children: [
                  RaisedButton(
                    onPressed: () {
                      //
                    },
                    child: Icon(Icons.lock_clock),
                  ),
                  RaisedButton(
                    onPressed: () {
                      context.read(dirfSNP).add();
                    },
                    child: Icon(Icons.airline_seat_flat),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.end),
              ),
            ),
          ),
          Expanded(
            flex: 30,
            child: Container(
                color: Colors.blue,
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(5),
                            child: Dirf(),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: Textfield(),
                  )
                ], crossAxisAlignment: CrossAxisAlignment.start)),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: ButtonTheme(
                minWidth: width / 2,
                height: 20,
                padding: EdgeInsets.all(0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Row(children: [
                  RaisedButton(
                    onPressed: () {
                      //context.read(teP).state++;
                    },
                    child: Icon(Icons.folder),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //
                    },
                    child: Icon(Icons.description_outlined),
                  ),
                  RaisedButton(
                    onPressed: () {
                      context
                          .read(context.read(dirfSNP.state)[select].enableSP)
                          .state = true;
                    },
                    child: Icon(Icons.border_color),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Icon(Icons.delete),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Icon(Icons.text_format),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Icon(Icons.lock),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Icon(Icons.contact_support),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
