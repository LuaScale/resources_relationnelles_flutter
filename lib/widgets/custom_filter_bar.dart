import 'package:flutter/material.dart';
import 'package:resources_relationnelles_flutter/services/get_user.dart';

class CustomFilterBar extends StatelessWidget implements PreferredSizeWidget {

  final Text? title;

  const CustomFilterBar({
    super.key,
    this.title,
  });

  dynamic getUser() async {
    return await fetchUtilisateurByToken();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(), 
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
            var user = snapshot.data;
        if(user == null){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()),
          );
        } else {
          return AppBar(
              backgroundColor: const Color(0xFFFFFFFF), // Fond Blanc
              actions: [
                //ajouter ici des filtres pour les ressources
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed:  () {
                         
                        }
                ),
              ],
            );
            }
      }
      );
  }
}
