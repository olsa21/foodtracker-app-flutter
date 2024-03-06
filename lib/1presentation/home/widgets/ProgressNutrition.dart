import 'package:flutter/material.dart';
import 'package:foodtracker/1presentation/home/widgets/CustomProgressBar.dart';

class ProgressNutrition extends StatelessWidget {
  final String title;
  final int current;
  final int maximum;

  const ProgressNutrition(
      {Key? key,
      required this.title,
      required this.current,
      required this.maximum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: themeData.textTheme.bodyText1,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomProgressBar(value: current / maximum),
          const SizedBox(
            height: 5,
          ),
          Text("$current/$maximum g"),
        ],
      ),
    );
  }
}
