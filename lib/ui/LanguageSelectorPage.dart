import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/localization/application.dart';

class LanguageSelectorPage extends StatefulWidget {
  @override
  _LanguageSelectorPageState createState() => _LanguageSelectorPageState();
}
final List<String> languagesList = application.supportedLanguages;
 final List<String> languageCodesList = application.supportedLanguagesCodes;
 final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
    languagesList[2]: languageCodesList[2],
  };

String label = languagesList[0];
class _LanguageSelectorPageState extends State<LanguageSelectorPage> {


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         "Save Blood"
  //       ),
  //     ),

  //   );
  // }

   Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
       title: Text("Save Blood",style: TextStyle(color: Colors.white),),
       //title: Text(AppTranslations.of(ctx).text("key_user_name"),style: TextStyle(color: Colors.white),),
       
        actions: <Widget>[
          PopupMenuButton<String>(
            // overflow menu
            onSelected: _select,
            icon: new Icon(Icons.language, color: Colors.white),
            itemBuilder: (BuildContext context) {
              return languagesList
                  .map<PopupMenuItem<String>>((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),

      body: new Material(
        child: new Container(
          padding: const EdgeInsets.all(20.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                    child: new Column(
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.only(top: 100.0)),
                        new Text(AppTranslations.of(context).text("key_user_name"), style: new TextStyle(color: Colors.amber, fontSize: 25.0),),
                        //new Text('Beautiful Flutter TextBox', style: new TextStyle(color: Colors.amber, fontSize: 25.0),),
                        new Padding(padding: EdgeInsets.only(top: 50.0)),
                        new TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Enter Email",
                              fillColor: Colors.red,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide() ,
                              ),
                            ),
                        )
                      ],
                    )
                  ),
                ),
        ),
      ),  
  );


}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}
  void _select(String language) {
    print("dd "+language);
    onLocaleChange(Locale(languagesMap[language]));
    setState(() {
      if (language == "Hindi") {
        label = "हिंदी";
      } else if (language == "Telugu") {
        label = language;
      }
      else {
        label = language;
      }
    });
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
          AppTranslations.load(locale);
        });
      }
}