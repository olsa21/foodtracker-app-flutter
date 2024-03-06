import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';

import '../../2application/food/food_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({Key? key, required this.food, this.log, this.date, this.type}) : super(key: key);
  final FoodEntity food;
  final LogEntity? log;
  final String? date;
  final String? type;

  @override
  State<FoodDetailPage> createState() {
    final controller = TextEditingController();
    controller.text="100";
    return _FoodDetailPageState(controller: controller);
  }
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final TextEditingController controller;
  late String dropdownValueType;
  late String dropdownValueGramm;
  double portionSize = 1;

  _FoodDetailPageState({required this.controller});

  @override
  void initState() {
    dropdownValueType = widget.log?.type ?? "Breakfast";
    dropdownValueGramm = "Gramm";
    controller.text = widget.log?.amount.round().toString() ?? "100";
  }

  String getCalculatedValue(double amount, String inputGramm, double portionSizeGramm){
    double input = double.parse(inputGramm);
    double portionSizeFactor = portionSizeGramm/100;
    return (amount*input*portionSizeFactor).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    String input = controller.text.isNotEmpty ? controller.text : "0";

    final intl = AppLocalizations.of(context)!;
    final String imgPath = "${widget.food.imageDirPath}${widget.food.ean}.jpg";

    return Scaffold(
      appBar: AppBar(
        title: Text("$dropdownValueType ${(widget.log == null)?  intl.add : intl.edit}"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 110,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(height: 150, child: (File(imgPath).existsSync()) ? Image.file(File(imgPath)) : Center(child: Text("This Product has no Image", style: themeData.textTheme.headline1))),
                Text("${widget.food.brand} ${widget.food.name}", style: themeData.textTheme.bodyText1, overflow: TextOverflow.ellipsis,),
                const SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text("${getCalculatedValue(widget.food.calories, input, portionSize)} kcal\n${intl.calories}"),
                    Text("${getCalculatedValue(widget.food.carbs, input, portionSize)} g\n${intl.carbs}"),
                    Text("${getCalculatedValue(widget.food.proteins, input, portionSize)} g\n${intl.protein}"),
                    Text("${getCalculatedValue(widget.food.fat, input, portionSize)} g\n${intl.fat}", overflow: TextOverflow.ellipsis,),],),
                const SizedBox(height: 10,),
                Text(intl.nutriments),
                const SizedBox(height: 10,),
                Row(children: [Text(intl.calories),const Spacer(),Text(getCalculatedValue(widget.food.calories, input, portionSize)),],),
                Row(children: [Text(intl.fat),const Spacer(),Text(getCalculatedValue(widget.food.fat, input, portionSize)),],),
                Row(children: [Text(intl.satFat),const Spacer(),Text(getCalculatedValue(widget.food.fatSaturated, input, portionSize)),],),
                Row(children: [Text(intl.carbs),const Spacer(),Text(getCalculatedValue(widget.food.carbs, input, portionSize)),],),
                Row(children: [Text(intl.sugar),const Spacer(),Text(getCalculatedValue(widget.food.sugar, input, portionSize)),],),
                Row(children: [Text(intl.protein),const Spacer(),Text(getCalculatedValue(widget.food.proteins, input, portionSize)),],),
                Row(children: [Text(intl.salt),const Spacer(),Text(getCalculatedValue(widget.food.salt, input, portionSize)),],),

                const Spacer(),
                Row(children: [
                  (widget.food.servingSize == 0)?
                    Text(intl.gram):
                  DropdownButton<String>(
                    value: dropdownValueGramm,
                    icon: const Icon(Icons.arrow_downward),
                    //elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      if(newValue == intl.gram){
                        controller.text ="100";
                        portionSize =1;
                      }
                      else{
                        controller.text ="1";
                        portionSize = widget.food.servingSize;
                      }

                      setState(() {
                        dropdownValueGramm = newValue!;
                      });
                    },
                    items: <String>["${intl.portion}(${widget.food.servingSize.toStringAsFixed(1)})", "Gramm"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],),



                Row(children: [
                  SizedBox(width: 70, child: TextField(controller: controller, onChanged: (text) { setState(() { });}, keyboardType: TextInputType.number,)),
                  const SizedBox(width: 20,),
                  DropdownButton<String>(
                    value: dropdownValueType,
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueType = newValue!;
                      });
                    },
                    items: <String>["Breakfast","Lunch", "Dinner", "Snack"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: () {
                      if(controller.text.isEmpty || controller.text == "0") {
                        return;
                      }

                      LogEntity log;
                      if (widget.log == null) {
                        //create log
                        log = LogEntity(
                            ean: widget.food.ean,
                            amount: double.parse(controller.text)*portionSize,
                            type: dropdownValueType,
                            date: widget.date);
                        BlocProvider.of<FoodBloc>(context).add(InsertFoodEvent(
                            foodEntity: widget.food, logEntity: log));
                      } else {
                        //existing log is edited and reused
                        log = widget.log!.copyWith(
                            type: dropdownValueType,
                            amount: double.parse(controller.text)*portionSize,);

                        BlocProvider.of<FoodBloc>(context)
                            .add(UpdateFoodLogEvent(logEntity: log));
                      }

                      AutoRouter.of(context).popUntilRoot();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                    child:
                        (widget.log == null)
                            ? Text(intl.add, style: TextStyle(color: Colors.white),)
                            : Text(intl.edit, style: TextStyle(color: Colors.white)),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
