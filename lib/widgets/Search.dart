import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import '../models/Weather.dart';
import '../screens/WeatherDetails.dart';
import '../services/OpenWeatherService.dart';

class Search extends StatefulWidget {
  const Search({
    Key? key,
  }) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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

  Future<void> search() async {
    Weather? weather =
        await OpenWeatherService().getWeatherByCity(dropdownValue);

    if (weather != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WeatherDetails(weather)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() => dropdownValue = districts[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF3f2b96),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Search",
            style: TextStyle(
                fontSize: 25, letterSpacing: 2.0, color: Colors.white),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: dropdownValue,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Color(0xFF3f2b96),
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
              ),
              IconButton(
                  onPressed: () => search(),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
