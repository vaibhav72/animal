import 'package:animal/core/http_client.dart';
import 'package:animal/data/cubits/animal_cubit/animal_cubit.dart';

import 'package:animal/data/repositories/bear_repository.dart';
import 'package:animal/utils/meta_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => BearRepository(HttpClient(MetaStrings.baseUrl)),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            AnimalCubit(context.read<BearRepository>())..getBears(),
        child: MaterialApp(
          title: 'Bear List',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Bear Lists'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 40) {
        context.read<AnimalCubit>().getBears();
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AnimalCubit>().refreshBears();
        },
        child:
            BlocConsumer<AnimalCubit, AnimalState>(listener: (context, state) {
          if (state is AnimalError) {
            ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
          if (state is AnimalLoadedWithMessage) {
            ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ));
          }
        }, builder: (context, state) {
          if (state.bears.isEmpty && state is AnimalLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.bears.isEmpty) {
            return const Center(
              child: Text('No bears found'),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == state.bears.length) {
                if (!context.read<AnimalCubit>().reachedLastPage) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox();
              }

              return ListTile(
                trailing: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                        children: const [
                          Expanded(
                              child: Text(
                            'Deleting bear...',
                          )),
                          CircularProgressIndicator(),
                        ],
                      )));
                      context
                          .read<AnimalCubit>()
                          .deleteBear(state.bears[index].id);
                    },
                    child: const Icon(Icons.delete)),
                title: Text(state.bears[index].animalName),
                subtitle: Text(state.bears[index].type),
              );
            },
            itemCount: state.bears.length + 1,
          );
        }),
      ),
    );
  }
}
