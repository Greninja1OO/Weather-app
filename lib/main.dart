import 'dart:convert';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:string_extensions/string_extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myController = TextEditingController();
  final myController1 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  String weather = 'rain';
  var language = {
    'Afrikaans': 'af',
    'Albanian': 'al',
    'Arabic': 'ar',
    'Azerbaijani': 'az',
    'Bulgarian': 'bg',
    'Catalan': 'ca',
    'Czech': 'cz',
    'Danish': 'da',
    'German': 'de',
    'Greek': 'el',
    'English': 'en',
    'Basque': 'ceu',
    'Persian': 'fa',
    'Finnish': 'fi',
    'French': 'fr',
    'Galician': 'gl',
    'Hebrew': 'he',
    'Hindi': 'hi',
    'Croatian': 'hr',
    'Hungarian': 'hu',
    'Indonesian': 'id',
    'Italian': 'it',
    'Japanese': 'ja',
    'Korean': 'kr',
    'Latvian': 'la',
    'Lithuanian': 'lt',
    'Macedonian': 'mk',
    'Norwegian': 'no',
    'Dutch': 'nl',
    'Polish': 'pl',
    'Portuguese': 'pt',
    'Romanian': 'ro',
    'Russian': 'ru',
    'Swedish': 'sv',
    'Slovak': 'sk',
    'Slovenian': 'sl',
    'Spanish': 'sp',
    'Serbian': 'sr',
    'Thai': 'th',
    'Turkish': 'tr',
    'Ukrainian': 'ua',
    'Vietnamese': 'vi',
    'Chinese': 'zn_cn',
    'Zulu': 'zu'
  };
  String unit = 'metric';
  String str = '11d';
  String place = 'Bangalore';
  String lang = 'en';

  @override
  Widget build(BuildContext context) {
    switch (str) {
      case '11d':

      case '11n':
        weather = "thunderstrom";
        break;
      case '09d':

      case '09n':
        weather = "drizzle";
        break;
      case '10d':

      case '10n':
        weather = "rain";
        break;
      case '13d':

      case '13n':
        weather = "snow";
        break;
      case '50d':

      case '50n':
        weather = "h";
        break;
      case '01d':
        weather = "clear day";
        break;
      case '01n':
        weather = "clear night";
        break;
      case '02d':

      case '02n':
        weather = "few clouds";
        break;
      case '03d':
      case '03n':
        weather = 'night clouds';
        break;
      case '04d':

      case '04n':
        weather = "heavy clouds";
        break;
      default:
        weather = "Invalid";
        break;
    }
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Weather App"),
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Container(
                      height: 120,
                      width: 400,
                      color: Color(0xff44000000),
                      child: Column(children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              icon: Icon(
                                Icons.place,
                                color: Colors.white,
                              ),
                              hintStyle: TextStyle(color: Colors.white54),
                              hintText: 'Search Location',
                              labelText: 'Place',
                              labelStyle: TextStyle(color: Colors.white70)),
                          controller: myController,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.language_sharp,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white54),
                            hintText: 'Type the Language',
                            labelText: 'Language',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          controller: myController1,
                        ),
                      ])),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: (() {
                      place = myController.text;
                      myController.text =
                          myController.text.capitalize.toString();
                      myController1.text =
                          myController1.text.capitalize.toString();
                      lang = language[myController1.text].toString();
                      place = place.capitalize.toString();

                      setState(() {});
                    }),
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  FutureBuilder(
                      future: apicall(place, lang, unit),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          str = snapshot.data['icon'];

                          return Column(children: [
                            Text(snapshot.data['description'].toString()),
                            Text(place),
                            Text((snapshot.data['temp']).toStringAsFixed(2)),
                            Image.network(
                                'http://openweathermap.org/img/wn/${str}@2x.png'),
                            Text(
                                (snapshot.data['temp_min']).toStringAsFixed(2)),
                            Text(
                                (snapshot.data['temp_max']).toStringAsFixed(2)),
                          ]);
                        } else {
                          return CircularProgressIndicator();
                        }
                      })
                ]),
              ],
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/$weather.jpg"),
                    fit: BoxFit.cover)),
          ),
        ));
  }
}

Future apicall(String place, String lang, String unit) async {
  final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=${place}&appid=d23e4bbc6dc29e67a34db53172ec7dc1&lang=${lang}&units=$unit");
  final response = await http.get(url);
  print(response.body);
  final json = jsonDecode(response.body);

  final output = {
    'description': json['weather'][0]['description'],
    'temp': json['main']['temp'],
    'icon': json['weather'][0]['icon'],
    'temp_max': json['main']['temp_max'],
    'temp_min': json['main']['temp_min']
  };
  return output;
}
