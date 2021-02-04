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
bool dof = true;
int select = -1;

class Df extends HookWidget {
  final n = number;
  final colorSP = StateProvider<Color>((_) => null);
  final icon = dof
      ? Icon(Icons.folder, color: Colors.yellowAccent)
      : Icon(Icons.description_outlined, color: Colors.white);
  final enableSP = StateProvider((_) => false);
  final _ = new FocusNode();
  Widget build(BuildContext context) {
    bool b = false;
    _.addListener(() {
      if (_.hasFocus) {
        b = true;
      } else {
        if (b) {
          context.read(enableSP).state = false;
          b = false;
        }
      }
    });
    final cp = useProvider(colorSP).state;
    final ep = useProvider(enableSP).state;
    return InkWell(
      onTap: () {
        if (select != -1) {
          context.read(context.read(dirfSNP.state)[select].colorSP).state =
              null;
        }
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
              child: icon,
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
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / /*3*/ 3.5;

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
            return;
          }
          if (select != -1) {
            context.read(context.read(dirfSNP.state)[select].colorSP).state =
                null;
            select = -1;
          }
        },
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
                      //
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
                color: Color(0xffe0e0e0),
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 3),
                          ),
                        ),
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
                      dof = true;
                      context.read(dirfSNP).add();
                    },
                    child: Icon(Icons.folder),
                  ),
                  RaisedButton(
                    onPressed: () {
                      dof = false;
                      context.read(dirfSNP).add();
                    },
                    child: Icon(Icons.description_outlined),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (select != -1) {
                        final sdf = context.read(dirfSNP.state)[select];
                        context.read(sdf.enableSP).state = true;
                        //rebuildを待つ処理が必要
                        //待っても意味ないっぽい
                        FocusScope.of(context).requestFocus(sdf._);
                      }
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
