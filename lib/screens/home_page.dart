import 'package:flutter/material.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/utils/constants/states_list.dart';
import 'package:safe_return/widgets/alert_list_tile.dart';
import 'package:safe_return/widgets/input_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? choosedState;

  @override
  void initState() {
    super.initState();
    setState(() {
      choosedState = MalaysiaStates.states.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            child: Column(
              children: [
                headerTitle(),
                SizedBox(height: size.height * 0.02),
                newCaseContainer(),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.43,
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      "ALERTS",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const AlertListTile(),
                  const AlertListTile(),
                  SizedBox(height: size.height * 0.5)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newCaseContainer() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search,
                  size: 25,
                ),
                Text(
                  "Quick Search",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.06,
                      child: const InputWidget(
                        hintText: "Name",
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    SizedBox(
                      height: size.height * 0.06,
                      child: const InputWidget(
                        hintText: "Age",
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      height: size.height * 0.06,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          menuMaxHeight: size.height * 0.25,
                          value: MalaysiaStates.states.first.toLowerCase(),
                          items: MalaysiaStates.states
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.toLowerCase(),
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              choosedState = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.04),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.newCase),
                child: Container(
                  height: size.height * 0.2,
                  width: size.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [
                        Colors.orangeAccent.shade700,
                        Colors.orange,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wysiwyg,
                        opticalSize: 48,
                        applyTextScaling: true,
                        size: 28,
                        color: Colors.white,
                      ),
                      Text(
                        "New Case",
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget headerTitle() {
    return Text(
      "safe return".toUpperCase(),
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
