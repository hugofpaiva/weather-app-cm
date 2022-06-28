import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localstorage/localstorage.dart';
import '../models/Weather.dart';
import '../screens/WeatherDetails.dart';

class FavouritesListView extends StatelessWidget {
  List<Weather> favourites;
  final void Function(Weather city) removeCityFunction;
  FavouritesListView(
      {required this.favourites, required this.removeCityFunction});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: favourites.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Container(
            margin:
                const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
            child: Slidable(
                key: Key(favourites[index].city!),
                endActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: ScrollMotion(),
                  children: [
                    Padding(padding: EdgeInsets.only(left:5)),
                    SlidableAction(
                      onPressed: (context) =>
                          removeCityFunction(favourites[index]),
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WeatherDetails(favourites[index])),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFFD3CCE3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Image.network(
                                    "http://openweathermap.org/img/wn/${favourites[index].icon}@2x.png"),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                            favourites[index].city ?? "",
                                            style: TextStyle(fontSize: 16))),
                                    Text(favourites[index].weather)
                                  ],
                                )
                              ],
                            )),
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                                '${(favourites[index].temperature.currentTemp).toInt()}',
                                style: TextStyle(fontSize: 36)),
                            Text("ºC"),
                          ],
                        )),
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
