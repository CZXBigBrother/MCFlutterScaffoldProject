import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'common/global.dart';
import 'i10n/localization_intl.dart';
import './state/profile_change_notifier.dart';
import 'index.dart';
import 'demo/index.dart';

// void main() => runApp(MyApp());
void main() {
  realRunApp();
}

void realRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.init().then((onValue) {});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder:
            (BuildContext context, themeModel, localeModel, Widget widget) {
          return MaterialApp(
            navigatorKey: navigationService.navigatorKey,
            // title: GmLocalizations.of(context).title,
            onGenerateTitle: (context) {
              return GmLocalizations.of(context).title;
            },
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            home: MyHomePage(),
            locale: localeModel.getLocale(),
            supportedLocales: [
              //我们只支持美国英语和中文简体
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
              //其它Locales
            ],
            localizationsDelegates: [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GmLocalizationsDelegate()
            ],
            localeResolutionCallback:
                (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {
                //如果已经选定语言，则不跟随系统
                return localeModel.getLocale();
              } else {
                //跟随系统
                Locale locale;
                if (supportedLocales.contains(_locale)) {
                  locale = _locale;
                } else {
                  //如果系统语言不是中文简体或美国英语，则默认使用美国英语
                  locale = Locale('zh', 'CN');
                }
                return locale;
              }
            },
            routes: <String, WidgetBuilder>{},
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(GmLocalizations.of(context).theme),
              onTap: () {
                navigationService.cNavigateTo(DemoThemeController());
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              title: Text(GmLocalizations.of(context).language),
              onTap: () {
                navigationService.cNavigateTo(DemoLanguageController());
              },
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              title: Text(GmLocalizations.of(context).statemanagement),
              onTap: () {
                navigationService.cNavigateTo(DemoProviderController());
              },
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
