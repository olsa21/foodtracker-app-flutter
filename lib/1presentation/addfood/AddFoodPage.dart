import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodtracker/1presentation/addfood/widgets/FoodAddCard.dart';
import 'package:foodtracker/1presentation/addfood/widgets/SearchAppBar.dart';

import '../../2application/food/food_bloc.dart';

@RoutePage()
class AddFoodPage extends StatelessWidget {
  final String? date;

  const AddFoodPage({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FoodBloc>(context).add(LocalFoodListRequestedEvent(date: null));
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SearchAppBar(date: date,)),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (BuildContext context, FoodState state) {
            if (state is FoodStateFoodListLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return FoodAddCard(
                    food: state.foodEntityList[index],
                    date: date,
                  );
                },
                itemCount: state.foodEntityList.length,
              );
            }else  {

            }
          return ListView();
        },
      ),
    );
  }
}