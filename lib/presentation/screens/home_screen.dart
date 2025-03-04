import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/blocs/home/home_bloc.dart';
import 'package:flutter_bloc_template/core/navigation/app_routes.dart';
import 'package:flutter_bloc_template/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_template/core/utils/widget/common_app_bar.dart';
import 'package:flutter_bloc_template/core/utils/widget/nev_drawer.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeBloc _homeBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
    _homeBloc.add(HomeEventInitial());

    // Listen for scroll events to trigger pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _homeBloc.add(LoadMoreItemsEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CommonAppBar(title: "Home", scaffoldKey: _scaffoldKey),
      drawer: const CommonDrawer(),
      body: BlocProvider(
        create: (context) => _homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is RepoLoadingState || state is HomeInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RepoLoadedState) {
              return ListView.separated(
                controller: _scrollController,
                itemCount: state.hasMore
                    ? state.listItem.length + 1
                    : state.listItem.length,
                itemBuilder: (context, index) {
                  if (index >= state.listItem.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final item = state.listItem[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0)
                        .copyWith(top: 12.0),
                    child: InkWell(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.blue,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            item.owner?.avatarUrl ?? '',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, bottom: 8.0),
                                        child: SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2) -
                                              20.0,
                                          child: Text(
                                            item.name ?? '',
                                            style:
                                                AppTextStyles.titleTextStyle(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    "Owner: ${item.owner?.login ?? ''}",
                                    style: AppTextStyles.bodyTextStyle(),
                                  ),
                                ],
                              ),
                            ),
                            Text("⭐ ${item.stargazersCount?.toInt() ?? '0'}",
                                style: AppTextStyles.titleTextStyle()),
                          ],
                        ),
                      ),
                      onTap: () {
                        context.push(AppRoutes.DETAILS_SCREEN, extra: item);
                      },
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return SizedBox(height: 2.0);
                },
              );
            } else if (state is RepoErrorState) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const Center(child: Text("No data available"));
          },
        ),
      ),
    );
  }
}
