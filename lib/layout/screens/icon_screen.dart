import 'package:flutter/material.dart';
import '../../shared/constant.dart';

class IconScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IconScreenState();
  }
}

class IconScreenState extends State<IconScreen> {
  var selectedIcon = Icons.ac_unit;
  List<IconData> icons = [
    Icons.run_circle_outlined,
    Icons.time_to_leave,
    Icons.sports_baseball,
    Icons.sports_basketball,
    Icons.sports_football,
    Icons.sports_esports,
    Icons.sports_golf,
    Icons.sports_handball,
    Icons.sports_hockey,
    Icons.sports_mma,
    Icons.sports_kabaddi,
    Icons.sports_score,
    Icons.sports_soccer,
    Icons.sports_tennis,
    Icons.sports_volleyball,
    Icons.menu_book,
    Icons.code,
    Icons.computer,
    Icons.icecream,
    Icons.fastfood,
    Icons.camera_alt,
    Icons.work,
    Icons.receipt,
    Icons.yard,
    Icons.wine_bar,
    Icons.wash,
    Icons.accessible_forward_outlined,
    Icons.airline_seat_recline_extra,
    Icons.airline_seat_individual_suite,
    Icons.airplanemode_active_sharp,
    Icons.airplay,
    Icons.architecture,
    Icons.audiotrack,
    Icons.article,
    Icons.beach_access,
    Icons.bed,
    Icons.bedtime,
    Icons.border_color,
    Icons.build,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose an icon'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myIcon = selectedIcon;
          Navigator.pop(context);
        },
        child: Text('OK'),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (selectedIcon != icons[index]) {
                setState(() {
                  selectedIcon = icons[index];
                });
              }
            },
            child: Icon(
              icons[index],
              color: selectedIcon == icons[index] ? Colors.blue : Colors.black,
              size: 40,
            ),
          );
        },
      ),
    );
  }
}
