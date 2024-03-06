import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodtracker/1presentation/home/widgets/HomePageAppBar.dart';
import 'package:foodtracker/1presentation/home/widgets/OverviewDay.dart';
import 'package:foodtracker/1presentation/home/widgets/OverviewMeal.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:foodtracker/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../2application/food/food_bloc.dart';
import '../routes/routes_import.gr.dart';


// D I

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime selectedDate;


  @override
  void initState() {
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    bool isDark = themeData.brightness == Brightness.dark;
    List<MealEntity> listEntireDay = <MealEntity>[];
    List<MealEntity> list1 = <MealEntity>[];
    List<MealEntity> list2 = <MealEntity>[];
    List<MealEntity> list3 = <MealEntity>[];
    List<MealEntity> list4 = <MealEntity>[];

    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        print("->HomePage BlocBuilder: "+state.toString());
        if (state is FoodStateFoodLoaded) {
          AutoRouter.of(context).replace(FoodDetailPageRoute(food: state.foodEntity));
        } else if(state is FoodStateLoading){
          AutoRouter.of(context).push(const LoadingPageRoute());
        }
        else if(state is FoodStateError){
          //AutoRouter.of(context).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent,));
          });
        }
        else if(state is FoodStateFoodListLoaded){

        }
        else if(state is FoodStateRemoteFoodListLoaded){

        }
        else if(state is FoodStateMealListLoaded){

          //1. mixed list of Meal
          listEntireDay.clear();
          list1.clear();
          list2.clear();
          list3.clear();
          list4.clear();

          listEntireDay = state.mealEntityList;

          for (var element in listEntireDay) {
            if(element.log.type == "Breakfast"){
              list1.add(element);
            }
            else if(element.log.type == "Lunch"){
              list2.add(element);
            }
            else if(element.log.type == "Dinner") {
              list3.add(element);
            } else if(element.log.type == "Snack"){
              list4.add(element);
            }
          }
        }else if (state is SuccessState) {
          //reload list
          if(AutoRouter.of(context).current.name == "LoadingPageRoute"){
            AutoRouter.of(context).pop();

          }
          BlocProvider.of<FoodBloc>(context).add(MealListRequestedEvent(date: DateFormat('yyyy-MM-dd').format(selectedDate)));
        }
        else {
          BlocProvider.of<FoodBloc>(context).add(MealListRequestedEvent(date: DateFormat('yyyy-MM-dd').format(selectedDate)));
        }

        void _presentDatePicker() {
          showDatePicker(
              builder: (context, child) {
                return Theme(
                  data: (isDark) ? AppTheme.calendarDataDark : AppTheme.calendarDataLight,
                      child: child!,
                );
              },
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100))
              .then((pickedDate) {
            // Check if no date is selected
            if (pickedDate == null) {
              return;
            }
            selectedDate = pickedDate;
            BlocProvider.of<FoodBloc>(context).add(MealListRequestedEvent(
                date: DateFormat('yyyy-MM-dd').format(selectedDate)));
          });
        }

        final intl = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: HomePageAppBar(),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                IconButton(onPressed: () {
                  selectedDate = selectedDate.add(const Duration(days: -1));
                  BlocProvider.of<FoodBloc>(context).add(MealListRequestedEvent(date: DateFormat('yyyy-MM-dd').format(selectedDate)));
                  setState(() {});
                }, icon: const Icon(Icons.arrow_back),),
                  InkResponse(
                    child: Text(
                      DateFormat('EEE, dd.MM.yyyy').format(selectedDate),
                      style: const TextStyle(fontSize: 22),
                    ),
                    onTap: () {
                      _presentDatePicker();
                    },
                  ),
                IconButton(onPressed: (){
                  selectedDate = selectedDate.add(const Duration(days: 1));
                  BlocProvider.of<FoodBloc>(context).add(MealListRequestedEvent(date: DateFormat('yyyy-MM-dd').format(selectedDate)));
                  setState(() {});
                }, icon: const Icon(Icons.arrow_forward),),
              ],),
              Text(intl.overview, style: themeData.textTheme.headline1,),
              OverviewDay(mealList: listEntireDay),
              const SizedBox(height: 10,),
              Text(intl.log,style: themeData.textTheme.headline1,),
              const SizedBox(height: 10,),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    OverviewMeal(title: intl.breakfast ,list: list1),
                    const SizedBox(height: 10,),
                    OverviewMeal(title: intl.lunch ,list: list2),
                    const SizedBox(height: 10,),
                    OverviewMeal(title: intl.dinner ,list: list3),
                    const SizedBox(height: 10,),
                    OverviewMeal(title: intl.snack ,list: list4),
                    const SizedBox(height: 10,),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                AutoRouter.of(context).push(AddFoodPageRoute(date: DateFormat('yyyy-MM-dd').format(selectedDate)));
              },
              child: const Icon(Icons.add_circle_outline)),
        );
      },
    );
  }
}