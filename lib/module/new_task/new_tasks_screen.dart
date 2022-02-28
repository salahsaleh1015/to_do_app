import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/component/constants.dart';
import 'package:to_do_app/shared/component/reusable.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(

        itemBuilder: (context , i){
      return buildTasks(tasks[i]);
    }, separatorBuilder:(context , i){
      return Container(width: double.infinity,height: 10,);
    }, itemCount:tasks.length);
  }
}
