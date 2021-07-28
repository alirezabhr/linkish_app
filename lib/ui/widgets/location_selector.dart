import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  final List<dynamic> provincesAndCities;
  final Function(String, String) setProvinceAndCity;
  LocationSelector(this.provincesAndCities, this.setProvinceAndCity);

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  late final List<dynamic> data;
  late List<dynamic> citiesList;
  late Map provinceValue;
  late String cityValue;

  setData() {
    data = widget.provincesAndCities;
    provinceValue = widget.provincesAndCities.first;
    citiesList = provinceValue['cities'];
    cityValue = citiesList.first['name'];
  }

  @override
  void initState() {
    setData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "موقعیت مکانی",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                child: DropdownButton<Map>(
                  value: provinceValue,
                  items: List.generate(
                    data.length,
                    (index) => DropdownMenuItem(
                      value: data[index],
                      child: Text(data[index]['name']),
                    ),
                  ),
                  onChanged: (Map? newValue) {
                    setState(() {
                      provinceValue = newValue!;
                      citiesList = provinceValue['cities'];
                      cityValue = (citiesList.first)['name'];
                    });
                    widget.setProvinceAndCity(provinceValue['name'], cityValue);
                  },
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple, fontSize: 18),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
              DropdownButton<String>(
                value: cityValue,
                items: List.generate(
                  provinceValue['cities'].length,
                  (index) => DropdownMenuItem(
                    value: provinceValue['cities'][index]['name'],
                    child: Text(provinceValue['cities'][index]['name']),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    cityValue = newValue!;
                  });
                  widget.setProvinceAndCity(provinceValue['name'], cityValue);
                },
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
