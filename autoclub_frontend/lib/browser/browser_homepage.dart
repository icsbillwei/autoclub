import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'browser_window.dart';


class BrowserHomepage extends StatelessWidget {

  final Function(BrowserPages) updateBrowserPage;

  const BrowserHomepage(
    {super.key, required this.updateBrowserPage}
      );

  @override
  Widget build(BuildContext context) {

    /*
    This is the Homepage SUBPAGE of the browser
    This provides buttons for navigating onto other subpages, such as the used dealer

    uses updateBrowserPage from parent
     */
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const SizedBox(height: 80,),
          SvgPicture.asset("/images/corone.svg", width: 200,),
          const SizedBox(height: 80,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /*
              Autos And Auctions Page
               */

              ElevatedButton(
                onPressed: () {
                  updateBrowserPage(BrowserPages.autosandauctions);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    children: [
                      SvgPicture.asset("images/autosandauctions-icon.svg", width: 60,),
                      const SizedBox(height: 20,),
                      Text("Autos & Auctions", style: Theme.of(context).textTheme.displaySmall,)
                    ],
                  ),
                ),
              ),

              SizedBox(width: 20,),

              /*
              Motorpedia page (currently blank)
               */

              ElevatedButton(
                onPressed: () {
                  updateBrowserPage(BrowserPages.motorpedia);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                  child: Column(
                    children: [
                      Image.asset("images/mp.png", width: 60,),
                      const SizedBox(height: 20,),
                      Text("Motorpedia", style: Theme.of(context).textTheme.displaySmall,)
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}