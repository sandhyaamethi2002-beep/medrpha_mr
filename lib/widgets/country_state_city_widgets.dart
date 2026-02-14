import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:collection/collection.dart';

class CountryStateCityWidget extends StatefulWidget {
  final Function(String country, String state, String city) onChanged;

  const CountryStateCityWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<CountryStateCityWidget> createState() =>
      _CountryStateCityWidgetState();
}

class _CountryStateCityWidgetState extends State<CountryStateCityWidget> {
  final List<Country> countryList = CountryService().getAll();

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<csc.State> stateList = [];
  List<csc.City> cityList = [];

  bool isLoadingStates = false;
  bool isLoadingCities = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ---------------- COUNTRY ----------------
        DropdownSearch<Country>(
          items: (filter, loadProps) => countryList,
          itemAsString: (Country c) => "${c.flagEmoji} ${c.name}",
          // Compare function taaki objects match ho sakein
          compareFn: (item1, item2) => item1.name == item2.name,
          selectedItem: countryList.firstWhereOrNull((c) => c.name == selectedCountry),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(hintText: "Search Country..."),
            ),
          ),
          decoratorProps: _decoration("Country *", CupertinoIcons.globe),
          validator: (value) => value == null ? "Country is required" : null,
          onChanged: (Country? country) async {
            if (country == null) return;

            setState(() {
              selectedCountry = country.name;
              selectedState = null;
              selectedCity = null;
              stateList = [];
              cityList = [];
              isLoadingStates = true;
            });

            final states = await csc.getStatesOfCountry(country.countryCode);

            setState(() {
              stateList = states;
              isLoadingStates = false;
            });
            _notifyParent();
          },
        ),

        const SizedBox(height: 18),

        /// ---------------- STATE ----------------
        if (isLoadingStates)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CupertinoActivityIndicator(),
          )
        else
          DropdownSearch<csc.State>(
            items: (filter, loadProps) => stateList,
            itemAsString: (csc.State s) => s.name,
            // FIX: State identification ke liye compareFn
            compareFn: (item1, item2) => item1.name == item2.name && item1.isoCode == item2.isoCode,
            selectedItem: stateList.firstWhereOrNull((s) => s.name == selectedState),
            popupProps: const PopupProps.menu(showSearchBox: true),
            decoratorProps: _decoration("State *", CupertinoIcons.map_pin_ellipse),
            validator: (value) => value == null ? "State is required" : null,
            enabled: stateList.isNotEmpty,
            onChanged: (csc.State? state) async {
              if (state == null) return;

              setState(() {
                selectedState = state.name;
                selectedCity = null;
                cityList = [];
                isLoadingCities = true;
              });

              final cities = await csc.getStateCities(state.countryCode, state.isoCode);

              setState(() {
                cityList = cities;
                isLoadingCities = false;
              });
              _notifyParent();
            },
          ),

        const SizedBox(height: 18),

        /// ---------------- CITY ----------------
        if (isLoadingCities)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CupertinoActivityIndicator(),
          )
        else
          DropdownSearch<csc.City>(
            items: (filter, loadProps) => cityList,
            itemAsString: (csc.City c) => c.name,
            // FIX: City identification ke liye compareFn
            compareFn: (item1, item2) => item1.name == item2.name,
            selectedItem: cityList.firstWhereOrNull((c) => c.name == selectedCity),
            popupProps: const PopupProps.menu(showSearchBox: true),
            decoratorProps: _decoration("City *", CupertinoIcons.location_solid),
            validator: (value) => value == null ? "City is required" : null,
            enabled: cityList.isNotEmpty,
            onChanged: (csc.City? city) {
              setState(() {
                selectedCity = city?.name;
              });
              _notifyParent();
            },
          ),
      ],
    );
  }

  // Common UI Decoration for v6+
  DropDownDecoratorProps _decoration(String label, IconData icon) {
    return DropDownDecoratorProps(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, size: 22, color: Colors.blue.shade400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    );
  }

  void _notifyParent() {
    if (selectedCountry != null && selectedState != null && selectedCity != null) {
      widget.onChanged(selectedCountry!, selectedState!, selectedCity!);
    }
  }
}