class HomeLayout extends StatelessWidget {



  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder:(context, state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.Titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.Screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(cubit.isBottomSheetShown == false) {
                  scaffoldkey.currentState!.showBottomSheet(
                        (context) =>
                        Container(
                          color:Colors.grey[100],
                          padding: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key:formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextForm(
                                    context,
                                    controller: titleController,
                                    keyBoardType: TextInputType.text,
                                    preIcon: Icons.title,
                                    IsPassword: true,
                                    text: 'Task Title',
                                    onTap:(){
                                      return null;
                                    },
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultTextForm(
                                    context,
                                    controller: timeController,
                                    keyBoardType: TextInputType.datetime,
                                    preIcon: Icons.watch_later_outlined,
                                    text: 'Task Time',
                                    onTap: ()
                                    {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value)
                                      {
                                        timeController.text = value!.format(context);
                                        print(value.format(context));
                                      });
                                    },
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultTextForm(
                                    context,
                                    controller: dateController,
                                    keyBoardType: TextInputType.datetime,
                                    preIcon: Icons.date_range,
                                    text: 'Task Time',
                                    onTap: ()
                                    {

                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2021-12-12'),
                                      ).then((value)
                                      {
                                        dateController.text = DateFormat.yMMMd().format(value!);
                                        print(DateFormat.yMMMd().format(value));
                                      });
                                    },
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                  ).closed.then((value) {
                    cubit.IconChange(
                      icon: Icons.edit,
                      isShow:false,
                    );
                  });
                  cubit.IconChange(
                    icon: Icons.check_circle,
                    isShow:true,
                  );

                }
                else {
                  if(formkey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    //     getDataFromDatabase(database).then((value)
                    //     {
                    //       cubit.tasks = value;
                    //       cubit.fabIcon = Icons.edit;
                    //       isBottomSheetShown = false;
                    //     });
                    //   });
                  }
                }
              },
              child: Icon(
                cubit.fabIcon,
                size: 25,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [

                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}