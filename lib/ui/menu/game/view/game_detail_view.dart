import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pintupay/core/pintupay/pintupay_palette.dart';
import 'package:pintupay/core/pintupay/pintupay_constant.dart';
import 'package:pintupay/core/util/util.dart';
import 'package:pintupay/ui/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nav_router/nav_router.dart';
import 'package:pintupay/ui/menu/emoney/model/emoney_product_response.dart';
import 'package:pintupay/ui/menu/game/model/game_product_response.dart';

import '../../../component/shimmer.dart';
import '../cubit/game_detail_cubit.dart';

class GameDetailView extends StatelessWidget {

  GameDetailView({Key? key }) : super(key: key);

  final TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Component.header(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Component.appBar(
                  BlocProvider.of<GameDetailCubit>(context).gameProviderResponse.name ?? "", 
                  transparet: true
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: TextFormField(
                      controller: idController,
                      decoration: Component.decorationNoBorder("Masukan id"),
                      maxLength: 16,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Wajib diisi*";
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                BlocBuilder<GameDetailCubit, GameDetailState>(
                  builder: (context, state) {
                    if (state is GameDetailLoading) {
                      return const ShimmerList();
                    } else if (state is GameDetailLoaded) {
                      return Flexible(child: listProduct(state.gameProductResponse));
                    } else if (state is GameDetailEmpty) {
                        return Center(child: Component.textBold("Product Kosong"),);
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    ); 
  }

  Widget listProduct(GameProductResponse gameProductResponse) {
    var size = MediaQuery.of(navGK.currentContext!).size;
    const double itemHeight = 140;
    final double itemWidth = size.width / 1.8;
    return GridView.builder(
      // physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount: gameProductResponse.game!.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemBuilder: (BuildContext context, int index) { 
        return InkWell(
          onTap: () {
            if(idController.text.isNotEmpty){
              // BlocProvider.of<GameDetailCubit>(context).inquiry(idController.text, GameProductResponse.Game![index]);
            } else {
              CoreFunction.showToast("Harap masukan no pelanggan");
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Component.textBold(
                    gameProductResponse.game![index].name ?? "", 
                    fontSize: PintuPayConstant.fontSizeLargeExtra,
                    textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Component.textBold(
                        CoreFunction.moneyFormatter(gameProductResponse.game![index].salePrice),
                        fontSize: PintuPayConstant.fontSizeMedium,
                        colors: PintuPayPalette.orange,
                        textAlign: TextAlign.center
                      ),
                      // const SizedBox(width: 10,),
                      // Text(
                      //   CoreFunction.moneyFormatter(GameProductResponse.Game![index].priceMerchant),
                      //   style: const TextStyle(
                      //     color: PintuPayPalette.grey,
                      //     fontFamily: PintuPayConstant.avenirRegular,
                      //     fontSize: PintuPayConstant.fontSizeSmall,
                      //     overflow: TextOverflow.ellipsis,
                      //     decoration: TextDecoration.lineThrough
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}