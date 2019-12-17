GITHUB地址: [https://github.com/CZXBigBrother/MCFlutterScaffoldProject](https://github.com/CZXBigBrother/MCFlutterScaffoldProject)
![QQ20191217-112054.gif](https://upload-images.jianshu.io/upload_images/3258209-8b5e87c92ed0f26a.gif?imageMogr2/auto-orient/strip)

# flutter项目快速开发集成通用的依赖库
* 1.国际化
* 2.主题切换
* 3.存储管理
* 4.状态管理
* 5.通用工具
这五项几乎是每个项目都通用的,所以这次提取出来统一配置,之后启动新项目时直接拿来即用.

# 项目的结构

![Snip20191217_6.png](https://upload-images.jianshu.io/upload_images/3258209-72ea5993520284e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

# 1.国际化
我们依赖国际化的两个package:
* 1.intl  [https://pub.flutter-io.cn/packages/intl](https://pub.flutter-io.cn/packages/intl)
* 2.intl_translation [https://pub.flutter-io.cn/packages/intl_translation](https://pub.flutter- io.cn/packages/intl_translation)
#### intl有一篇专门使用的文章[使用Intl包](https://book.flutterchina.club/chapter13/intl.html)


intl_translation 是用来生成arb的翻译文件,所以添加的依赖只用在dev环境下

![Snip20191217_7.png](https://upload-images.jianshu.io/upload_images/3258209-89854a69fffea804.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)
这里我们会创建一个代理文件
```
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart'; //1

class GmLocalizations {
  static Future<GmLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    //2
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return new GmLocalizations();
    });
  }

  static GmLocalizations of(BuildContext context) {
    return Localizations.of<GmLocalizations>(context, GmLocalizations);
  }

  String get title => Intl.message('MCflutter 快速开发框架', name: 'title');
  String get language => Intl.message('语言', name: 'language');
  String get setting => Intl.message('设置', name: 'setting');
  String get theme => Intl.message('主题', name: 'theme');
  String get auto => Intl.message('自动', name: 'auto');
  String get statemanagement => Intl.message('状态管理', name: 'statemanagement');
}

//Locale代理类
class GmLocalizationsDelegate extends LocalizationsDelegate<GmLocalizations> {
  const GmLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<GmLocalizations> load(Locale locale) {
    //3
    return GmLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源.
  @override
  bool shouldReload(GmLocalizationsDelegate old) => false;
}
```
# 2.状态管理Provider
Provider使用起来学习成本更小而且管理容易
Provider[https://pub.flutter-io.cn/packages/provider](https://pub.flutter-io.cn/packages/provider)
Provider学习文章[https://www.jianshu.com/p/f220136c05d4](https://www.jianshu.com/p/f220136c05d4)
![image.png](https://upload-images.jianshu.io/upload_images/3258209-5c6d11333668866b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)

创建一个通知的基类
```
class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;
  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}
```
主题和语言改变发出通知
```
class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果为设置主题，则默认使用蓝色主题
  ColorSwatch get theme => Global.themes
      .firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}
class LocaleModel extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale getLocale() {
    if (_profile.locale == null) return null;
    var t = _profile.locale.split("_");
    return Locale(t[0], t[1]);
  }
  // 获取当前Locale的字符串表示
  String get locale => _profile.locale;
  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}
```
在main中注册
```
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
```
# 3.主题
主题相对来说比较简单,不需要依赖太多外部的框架
global设置
```
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

  static List<MaterialColor> get themes => _themes;
```
在上面写的函数中可以找到,添加了通知
```
ChangeNotifierProvider.value(value: LocaleModel()),
theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
```
# 4.存储
shared_preferences [https://pub.flutter-io.cn/packages/shared_preferences](https://pub.flutter-io.cn/packages/shared_preferences)
shared_preferences很多人都已经用过了不做过多的介绍.主要说明下,如何把原来异步的任务变成同步.
shared_preferences 异步有两个地方,一个是初始一个是存储
项目初始化的时候,可以将shared_preferences初始化然后存储下来,shared_preferences在get的时候是同步的,我们就不需要处理了,存储的时候我们依旧是异步的,这样能解决app启动是需要初始化的参数问题
```
  static SharedPreferences preferences;
```
# 5.工具(持续更新)
1.NavigationService 不需要context的push工具
.....
