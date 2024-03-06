import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../2application/food/food_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({Key? key, this.date}) : super(key: key);
  final String? date;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState(date: date);
}

class _SearchAppBarState extends State<SearchAppBar> {
  final String? date;

  _SearchAppBarState({this.date});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.addProduct),
      actions: [
        IconButton(onPressed: (){
          showSearch(context: context, delegate: CustomSearchDelegate())
              .then((value) => BlocProvider.of<FoodBloc>(context).add(LocalFoodListRequestedEvent(date: date)));
        }, icon: const Icon(Icons.search),),
        IconButton(onPressed: () async {
          final options = const ScanOptions(
             //...
          );

          final scanResult = await BarcodeScanner.scan(options: options);

          if(scanResult.type.toString() != "Cancelled"){
            BlocProvider.of<FoodBloc>(context).add(FoodRequestedEvent(ean: scanResult.rawContent, date: date));

            /*
            print(scanResult.type); // The result type (barcode, cancelled, failed)
            print(scanResult.rawContent); // The barcode content
            print(scanResult.format); // The barcode format (as enum)
            print(scanResult.formatNote); // If a unknown format was scanned this field contains a note
             */
          }
        }, icon: const Icon(Icons.qr_code_outlined),),
      ],
    );
  }
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}


class CustomSearchDelegate extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query ='';
      }, icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    //get list from OFF
    BlocProvider.of<FoodBloc>(context).add(RemoteFoodListRequestedEvent(searchName: query));
    print("HALLO");

    return BlocBuilder<FoodBloc, FoodState>(
      builder: (BuildContext context, FoodState state) {
        if (state is FoodStateRemoteFoodListLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              String name = state.foodEntityList[index].name;
              String brand = state.foodEntityList[index].brand;
              return ListTile(
                title: name.isNotEmpty
                    ? Text(name)
                    : Text(brand,style: const TextStyle(fontStyle: FontStyle.italic),),
                onTap: () {
                  BlocProvider.of<FoodBloc>(context).add(
                      FoodRequestedEvent(ean: state.foodEntityList[index].ean));
                  close(context, null);
                },
              );
            },
            itemCount: state.foodEntityList.length,
          );
        }
        return ListView();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("Query: $query");

    return BlocBuilder<FoodBloc, FoodState>(
      builder: (BuildContext context, FoodState state) {
        if(state is! FoodStateFoodListLoaded){
          BlocProvider.of<FoodBloc>(context).add( LocalFoodListRequestedEvent(date: null));
        }

        if (state is FoodStateFoodListLoaded) {//suppress error messages
          return ListView.builder(
            itemBuilder: (context, index) {
              String name = state.foodEntityList[index].name;
              if (query.isEmpty) {
                //entire content
                return ListTile(
                  title: Text(name),
                  onTap: () {
                    BlocProvider.of<FoodBloc>(context).add(FoodRequestedEvent(
                        ean: state.foodEntityList[index].ean));
                    close(context, null);
                  },
                );
              } else if (name.toLowerCase().contains(query.toLowerCase())) {
                //matching content
                return ListTile(
                  title: Text(name),
                  onTap: () {
                    BlocProvider.of<FoodBloc>(context).add(FoodRequestedEvent(
                        ean: state.foodEntityList[index].ean));
                    close(context, null);
                  },
                );
              } else {
                return Container();
              }
            },
            itemCount: state.foodEntityList.length,
          );
        }
        return ListView();
      },
    );
  }
  
}