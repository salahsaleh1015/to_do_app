import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';

Widget defaultFormField(
        {@required TextEditingController? textController,
        @required TextInputType? type,
       Function(String val)? onSubmitted,
      Function(String val)? onChanged,
        @required String? Function(String? val)? validate,
        @required IconData? prefix,
        VoidCallback? onTap,
        @required String? label}) =>
    TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(),
      ),
      controller: textController,
      onTap: onTap,
      keyboardType: type,
      obscureText: false,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      validator: validate,
    );
Widget buildTasks(Map model)=>Padding(
  padding: const EdgeInsets.all(15),
  child: Row(
    children: [
      CircleAvatar(
        child: Text("${model['time']}"),
        radius: 40,
        backgroundColor: Colors.blue,
      ),
      SizedBox(
        width: 20,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${model['name']}",style: TextStyle(
              fontSize: 20
          ),),
          Text("${model['date']}",style: TextStyle(color: Colors.grey[600]),)
        ],
      )
    ],
  ),
);
