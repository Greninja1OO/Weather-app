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

  String weather = 'open';
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
  String str = '';
  String place = '';
  String lang = 'en';
  bool update = true;
  String up = 'Search';
  String temperature = '';
  bool degree = true;
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
        weather = 'night cloud';
        break;
      case '04d':

      case '04n':
        weather = "heavy clouds";
        break;
      default:
        weather = "open";
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
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/$weather.jpg"),
                    fit: BoxFit.cover)),
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
                          style: TextStyle(color: Colors.white70),
                          decoration: const InputDecoration(
                              icon: Icon(
                                Icons.place,
                                color: Colors.white,
                              ),
                              hintStyle: TextStyle(color: Colors.white54),
                              hintText: 'Search Location',
                              labelText: 'Place *',
                              labelStyle: TextStyle(color: Colors.white70)),
                          controller: myController,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white70),
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.language_sharp,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white54),
                            hintText: 'Type the Language',
                            labelText: 'Language(Default:English)',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          controller: myController1,
                        ),
                      ])),
                  Container(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff44000000))),
                    onPressed: (() {
                      place = myController.text;
                      myController.text =
                          myController.text.capitalize.toString();
                      myController1.text =
                          myController1.text.capitalize.toString();
                      lang = language[myController1.text].toString();
                      place = place.capitalize.toString();
                      update = !update;
                      if (update == true)
                        up = "Search";
                      else
                        up = "Click Again to Update";
                      setState(() {});
                    }),
                    child: Text(
                      "$up",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Container(height: 30),
                  FutureBuilder(
                      future: apicall(place, lang, unit),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) str = snapshot.data['icon'];
                        if (snapshot.hasData && update == true) {
                          temperature =
                              (snapshot.data['temp']).toStringAsFixed(2);
                          return Column(children: [
                            Container(
                                width: 400,
                                color: Color(0xff44000000),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "UTC+" +
                                            (snapshot.data['time'] / 3600)
                                                .floor()
                                                .toStringAsFixed(0) +
                                            ":" +
                                            ((snapshot.data['time'] / 3600 -
                                                        int.parse((snapshot
                                                                        .data[
                                                                    'time'] /
                                                                3600)
                                                            .floor()
                                                            .toStringAsFixed(
                                                                0))) *
                                                    60)
                                                .toStringAsFixed(0) +
                                            "\n" +
                                            place,
                                        style: TextStyle(color: Colors.white),
                                        textScaleFactor: 2,
                                      ),
                                      Text(
                                        temperature + "°C",
                                        textScaleFactor: 3,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Image.network(
                                          'http://openweathermap.org/img/wn/${str}@2x.png'),
                                    ])),
                            Container(
                                width: 400,
                                color: Color(0xff44000000),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ("Humidity : " +
                                                  snapshot.data['humidity']
                                                      .toStringAsFixed(2) +
                                                  "%"),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textScaleFactor: 1,
                                            ),
                                            Text(
                                              ("Wind Speed : " +
                                                  (snapshot.data['wind_speed'] *
                                                          18 /
                                                          5)
                                                      .toStringAsFixed(2) +
                                                  "km/hr"),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textScaleFactor: 1,
                                            ),
                                          ]),
                                      Container(
                                        width: 175,
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: Colors.white,
                                          ),
                                          Icon(
                                            Icons.arrow_downward,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      Column(children: [
                                        Text(
                                          '${(snapshot.data['temp_max']).toStringAsFixed(2)} °',
                                          style: TextStyle(color: Colors.white),
                                          textScaleFactor: 1,
                                        ),
                                        Text(
                                          (snapshot.data['temp_min'])
                                                  .toStringAsFixed(2) +
                                              ' °',
                                          style: TextStyle(color: Colors.white),
                                          textScaleFactor: 1,
                                        ),
                                      ])
                                    ]))
                          ]);
                        } else {
                          return Container();
                        }
                      })
                ]),
              ],
            ),
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
    'temp_min': json['main']['temp_min'],
    'wind_speed': json['wind']['speed'],
    'humidity': json['main']['humidity'],
    "time": json["timezone"]
  };
  return output;
}
