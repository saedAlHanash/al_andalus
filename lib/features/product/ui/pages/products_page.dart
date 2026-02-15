import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/widgets/not_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../bloc/products_cubit/products_cubit.dart';
import '../widget/item_product.dart';
import '../widget/search_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.title});

  final String title;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _scrollController = ScrollController();
  var loadingNewData = false;

  ProductsCubit get cubit => context.read<ProductsCubit>();

  void scrollListener() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 5) {
      context.read<ProductsCubit>().getNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(scrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  void initState() {
    final state = context.read<ProductsCubit>().state;
    if (state.done && state.meta.haveNext) {
      _scrollController.addListener(scrollListener);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titleText: widget.title, elevation: 0),
      body: BlocConsumer<ProductsCubit, ProductsInitial>(
        listener: (context, state) {
          loggerObject.w(state.meta.toJson());
          if (state.done && state.meta.haveNext) {
            _scrollController.addListener(scrollListener);
          } else {
            _scrollController.removeListener(scrollListener);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SearchProductsWidget(),
                Expanded(
                  child: state.isDataEmpty
                      ? NotFoundWidget()
                      : RefreshWidget(
                          isLoading: state.loading,
                          onRefresh: () => context.read<ProductsCubit>().getData(newData: true),
                          child: state.isDataEmpty
                              ? NotFoundWidget()
                              : GridView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.all(20.0).r,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0.r,
                                    mainAxisSpacing: 20.0.r,
                                    mainAxisExtent: 220.0.h,
                                  ),
                                  itemCount: state.result.length,
                                  itemBuilder: (_, i) {
                                    final item = state.result[i];
                                    return ItemProduct(product: item);
                                  },
                                ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
