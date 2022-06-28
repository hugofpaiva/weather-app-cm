import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:weather_application/models/Weather.dart';
import 'package:weather_application/services/OpenWeatherService.dart';
import 'package:weather_application/widgets/FavouritesListView.dart';
import '../widgets/Search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> districts = [
    "Aveiro",
    "Beja",
    "Braga",
    "Bragança",
    "Castelo Branco",
    "Coimbra",
    "Évora",
    "Faro",
    "Guarda",
    "Leiria",
    "Lisboa",
    "Portalegre",
    "Porto",
    "Santarém",
    "Setúbal",
    "Viana do Castelo",
    "Vila Real",
    "Viseu"
  ];
  late String dropdownValue;
  bool initialized = false;
  final LocalStorage storage = new LocalStorage('Weather.json');
  List<Weather> favouriteCitiesWeather = [];
  ValueNotifier<bool> _hasInitialized = ValueNotifier(false);

  static List encodeToJson(List<Weather> list) {
    List jsonList = [];
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  void initState() {
    super.initState();
    setState(() => dropdownValue = districts[0]);
  }

  void loadCities() async {
    if (initialized) {
      return;
    }

    initialized = true;

    List<dynamic> favouriteCitiesWeatherStorage =
        storage.getItem('favouriteCitiesWeather') ?? [];

    if (favouriteCitiesWeatherStorage.isEmpty) {
      favouriteCitiesWeather = [];
    } else {
      await Future.forEach<dynamic>(favouriteCitiesWeatherStorage,
          (element) async {
        Weather tempWeather = Weather.fromJson(element);
        if (!favouriteCitiesWeather
            .any((item) => item.city == tempWeather.city)) {
          Weather? weather =
              await OpenWeatherService().getWeatherByCity(tempWeather.city);
          if (weather != null) {
            favouriteCitiesWeather.add(weather);
          } else {
            favouriteCitiesWeather.add(tempWeather);
          }
        }
      });
    }
    _hasInitialized.value = true;
  }

  void addSelectedCity() async {
    Weather? weather =
        await OpenWeatherService().getWeatherByCity(dropdownValue);
    if (weather != null &&
        !favouriteCitiesWeather.any((item) => item.city == weather.city)) {
      favouriteCitiesWeather.add(weather);
      storage.setItem(
          'favouriteCitiesWeather', encodeToJson(favouriteCitiesWeather));
    }
    Navigator.of(context).pop();
    setState(() => {});
  }

  void removeCity(Weather city) async {
    favouriteCitiesWeather.remove(city);
    storage.setItem(
        'favouriteCitiesWeather', encodeToJson(favouriteCitiesWeather));
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin:
              const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Search(),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Favourite Cities",
                style: TextStyle(fontSize: 25, letterSpacing: 2.0),
              ),
              Expanded(
                  child: FutureBuilder(
                future: storage.ready,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: const SpinKitDoubleBounce(
                        color: const Color(0xFF3f2b96),
                        size: 50.0,
                      ),
                    );
                  }
                  if (!initialized) {
                    loadCities();
                  }

                  return ValueListenableBuilder(
                      valueListenable: _hasInitialized,
                      builder: (BuildContext context, bool hasInitialized,
                              Widget? child) =>
                          FavouritesListView(
                              favourites: favouriteCitiesWeather,
                              removeCityFunction: removeCity));
                },
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text("Add city to favourites"),
                content: DropdownButton(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: districts.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => dropdownValue = newValue!);
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () => addSelectedCity(),
                      child: const Text("Add"))
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
