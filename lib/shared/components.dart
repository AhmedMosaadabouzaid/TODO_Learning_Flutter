import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget defulatTextFormField ({
  required Function onTapFunction ,
  required TextEditingController textEditingController,
  required String labelText,
  required IconData prefixIcon,
  required Function validate,
  required Function onChange,
  required Function onSubmit,
  required TextInputType inputType,
  required bool isObsecure,
    })
  =>TextFormField(
    onTap: ()=>onTapFunction(),
    controller: textEditingController,
    validator: (value) => validate(value),
    onChanged: (value) => onChange(value),
    onFieldSubmitted: (value) => onSubmit(value),
    keyboardType: inputType,
    textAlign: TextAlign.start,
    obscureText: isObsecure,
    maxLines: 1,


    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(),
    ),
);


  Widget builtListItem(
      int count,
       Map tasks,

      )
  =>Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView.separated(
        itemBuilder: (context,index)=>Row(

          children: [
            CircleAvatar(
              radius: 30.0,
              child: Text("${tasks['time']}"),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${tasks['task']}"),
                Text("${tasks['date']}"),
              ],
            ),
            IconButton(onPressed: (){},
                icon: Icon(Icons.check_circle,color: Colors.green,size: 25,)),
            SizedBox(width: 15),
            IconButton(onPressed: (){},
                icon: Icon(Icons.archive,size: 25,)),
          ],

        ),
        separatorBuilder: (context,builder)=>Column(
          children: [
            SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(height: 8.0),
          ],
        ),
        itemCount: count),
  );

class BuildTaskItem extends StatelessWidget {
  final Map model;

  const BuildTaskItem(this.model);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {

        AppCubit.get(context).deleteFromDB(
          model['id'],
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              icon: Icon(
                Icons.check_box_sharp,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context).updateDb(
                   'done',
                 model['id'],
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
              onPressed: () {
                AppCubit.get(context).updateDb(
                  'archived',
                 model['id'],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}