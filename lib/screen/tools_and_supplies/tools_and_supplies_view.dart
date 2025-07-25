import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'bloc/tools_and_supplies_state.dart';
import 'provider/tools_and_supplies_provide.dart';

class ToolsAndSuppliesView extends StatefulWidget {
  const ToolsAndSuppliesView({super.key});

  @override
  State<ToolsAndSuppliesView> createState() => _ToolsAndSuppliesViewState();
}

class _ToolsAndSuppliesViewState extends State<ToolsAndSuppliesView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    Provider.of<ToolsAndSuppliesProvider>(
      context,
      listen: false,
    ).onInit(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<ToolsAndSuppliesBloc, ToolsAndSuppliesState>(
      listener: (context, state) {
        if (state is ToolsAndSuppliesInitialState) {}
        if (state is ToolsAndSuppliesLoadingState) {}
        if (state is ToolsAndSuppliesLoadingDismissState) {}
        if (state is GetListToolsAndSuppliesSuccessState) {
          log('message GetListToolsAndSuppliesSuccessState');
          context
              .read<ToolsAndSuppliesProvider>()
              .getListToolsAndSuppliesSuccess(context, state);
        }
        if (state is GetListToolsAndSuppliesFailedState) {}
      },
      builder: (context, state) {
        return Consumer<ToolsAndSuppliesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.data == null) {
              return const Center(child: Text('Không có dữ liệu'));
            }
            provider.controllerDropdownPage ??= TextEditingController(
              text: provider.rowsPerPage.toString(),
            );

            return Scaffold(
              appBar: AppBar(
                title: buildHeader(
                  size.width,
                  _searchController,
                  (value) {
                    setState(() {
                      searchTerm = value;
                    });
                  },
                  subScreen: provider.subScreen,
                  onNew: () {
                    log('message onNew');
                    setState(() {
                      provider.onChangeScreen(
                        item: null,
                        isMainScreen: false,
                        isEdit: true,
                      );
                    });
                  },
                  onTap: () {
                    log('message onTap');
                    setState(() {
                      provider.onChangeScreen(
                        item: null,
                        isMainScreen: true,
                        isEdit: false,
                      );
                    });
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: provider.body,
              ),
            );
          },
        );
      },
    );
  }
}