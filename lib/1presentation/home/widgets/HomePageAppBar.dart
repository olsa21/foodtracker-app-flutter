import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../2application/food/food_bloc.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(intl.homepage),
      actions: [
        PopupMenuButton(itemBuilder: (context){
          return [
            PopupMenuItem(
                onTap: (){BlocProvider.of<FoodBloc>(context).add(SyncDatabaseEvent());},
                child: Row(
                  children: [
                    Icon(
                      Icons.sync,
                      color: (MediaQuery.of(context).platformBrightness == Brightness.dark)
                            ? Colors.white
                            : Colors.black),
                    Flexible(child: Text(intl.sync, overflow: TextOverflow.visible,)),
              ],
            ))
          ];
        })
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
