import 'package:crypto_wallet/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../net/api_methods.dart';
import '../net/flutterfire.dart';
import '../theme/colors.dart';
import '../widgets/coin_item.dart';
import 'auth_pages/login_page.dart';
import 'coin_info_page.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // ignore: unused_local_variable
    Future<List> getData;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            gradient: LinearGradient(
              colors: [appBgColorPrimary, appBgColorSecondary],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Explore"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () async {
                    final searchedResult = await showSearch(
                      context: context,
                      delegate: MySearchBar(
                        data: watch(apiRepositoryProvider).getAllCoinsName(),
                      ),
                    );
                    String coinName = "";
                    String coinId = "";
                    var temp = searchedResult.toString().split(" ");
                    setState(() {
                      coinId = temp[0];
                      coinName = temp[1];
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CoinInfoPage(coinName: coinName, coinId: coinId)));
                  },
                ),
                IconButton(
                    onPressed: () {
                      watch(authRepositoryProvider).signout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    icon: const FaIcon(FontAwesomeIcons.signOutAlt)),
              ],
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: () {
                return getData =
                    watch(apiRepositoryProvider).getCoinsMarketData();
              },
              child: FutureBuilder(
                  future: watch(apiRepositoryProvider).getCoinsMarketData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.hasData) {
                      var data = snapshot.data as List<dynamic>;
                      // return Text(data.elementAt(1).toString());
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CoinItem(
                                  coinData: data.elementAt(index),
                                  watcher: watch,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CoinInfoPage(
                                              coinName:
                                                  data.elementAt(index)['name'],
                                              coinId:
                                                  data.elementAt(index)['id'],
                                            )));
                              },
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
        );
      },
    );
  }
}
