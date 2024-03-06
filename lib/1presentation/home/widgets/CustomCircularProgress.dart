import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomCircularProgress extends StatelessWidget {
  final int current;
  final int maximum;

  const CustomCircularProgress(
      {Key? key, required this.current, required this.maximum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        CircularProgressIndicator(
          value: current / maximum,
          color: (current < maximum) ? Colors.cyan : Colors.red,
          backgroundColor: Colors.grey,

        ),
        const SizedBox(
          height: 10,
        ),
        (current < maximum)
            ? Text("${maximum - current} " + AppLocalizations.of(context)!.left)
            : Text("${(current - maximum)} " + AppLocalizations.of(context)!.tooMuch),
      ],
    );
  }
}
