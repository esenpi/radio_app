import 'package:radio_app/blocs/moderator_page%20(prospective%20feature%20-%20not%20used)/moderator_rating_bloc.dart';
import 'package:radio_app/blocs/moderator_page%20(prospective%20feature%20-%20not%20used)/moderator_rating_event.dart';
import 'package:radio_app/blocs/rating/rating_bloc.dart';
import 'package:radio_app/blocs/rating/rating_event.dart';
import 'package:radio_app/blocs/rating/rating_state.dart';
import 'package:radio_app/model/moderator_rating.dart';
import 'package:radio_app/model/rating.dart';
import 'package:radio_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:radio_app/blocs/rating/rating_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'signin_page.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<RatingBloc>(context).add(LoadRatings());
    super.initState();
  }

  double moderatorValue = 1.5;
  double playlistValue = 1.5;

  @override
  Widget build(BuildContext context) {
    final RatingBloc _ratingBloc = BlocProvider.of<RatingBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bewertungen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.appColor,
        actions: [
          InkWell(
              onTap: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: const Icon(Icons.logout_outlined, color: Colors.white))
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignIn()),
              (route) => false,
            );
          }
        },
        child:
            /*
            RatingStars(
              value: value,
              onValueChanged: (v) {
                //
                print("Rating: $v");
                setState(() {
                  value = v;
                });
                // datetime to firebase timestamp
                ModeratorRating rating = ModeratorRating(
                    rating: v.toInt(),
                    date: Timestamp.fromDate(DateTime.now()),
                    shown: false);
                BlocProvider.of<ModeratorRatingBloc>(context)
                    .add(InsertModeratorRatingEvent(rating));
              },
              starBuilder: (index, color) => Icon(
                Icons.star,
                color: color,
              ),
              starCount: 5,
              starSize: 50,
              valueLabelColor: const Color(0xff9b9b9b),
              valueLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              valueLabelRadius: 10,
              maxValue: 5,
              starSpacing: 2,
              maxValueVisibility: true,
              valueLabelVisibility: true,
              animationDuration: Duration(milliseconds: 1000),
              valueLabelPadding:
                  const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
              valueLabelMargin: const EdgeInsets.only(right: 8),
              starOffColor: const Color(0xffe7e8ea),
              starColor: Colors.yellow,
            ),  */
            Container(
          child: BlocBuilder<RatingBloc, RatingState>(
            builder: (context, state) {
              print('Current state: $state');

              if (state is RatingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RatingLoaded) {
                final ratings = state.ratings;
                return Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: ratings.length,
                    itemBuilder: (context, index) {
                      final rating = ratings[index];
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 5.0,
                              offset: Offset(
                                  0, 5), // shadow direction: bottom right
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            "Bewertung",
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.appColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                  "Moderator ${rating.moderatorRating} / Playlist ${rating.playlistRating}"),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.purple[900],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    rating.date,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showAddRatingDialog(context, true, rating);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.withOpacity(0.5),
                                ),
                                onPressed: () {
                                  _ratingBloc.add(DeleteRating(rating.id!));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is RatingOperationSuccess) {
                print("Success ${state.message}");
                _ratingBloc.add(LoadRatings()); // Reload ratings
                return Container(); // Or display a success message
              } else if (state is RatingError) {
                // print long error message with stacktrace
                print("Error: ${state.errorMessage}");
                return Center(child: Text(state.errorMessage));
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.appColor,
        onPressed: () {
          _showAddRatingDialog(context, false, null);
        },
        child: const Icon(
          Icons.star,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddRatingDialog(
      BuildContext context, bool isEdit, Rating? ratings) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();

    if (isEdit) {
      titleController.text = ratings!.title;
      descriptionController.text = ratings.description;
      dateController.text = ratings.date;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Bewertung ändern' : 'Bewertung hinfügen'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*
                TextField(
                  controller: titleController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: 'Task',
                    hintStyle: const TextStyle(fontSize: 14),
                    icon: const Icon(CupertinoIcons.square_list,
                        color: AppColors.appColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),*/
                const SizedBox(height: 15),
                Text("Moderator bewerten"),
                RatingStars(
                  value: moderatorValue,
                  onValueChanged: (v) {
                    //
                    print("Rating: $v");
                    setState(() {
                      moderatorValue = v;
                    });
                  },
                  starBuilder: (index, color) => Icon(
                    Icons.star,
                    color: color,
                  ),
                  starCount: 5,
                  starSize: 30,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  valueLabelRadius: 10,
                  maxValue: 5,
                  starSpacing: 1,
                  maxValueVisibility: true,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                  valueLabelMargin: const EdgeInsets.only(right: 8),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                ),
                Text("Playlist bewerten"),
                RatingStars(
                  value: playlistValue,
                  onValueChanged: (v) {
                    //
                    print("Rating: $v");
                    setState(() {
                      playlistValue = v;
                    });
                  },
                  starBuilder: (index, color) => Icon(
                    Icons.star,
                    color: color,
                  ),
                  starCount: 5,
                  starSize: 30,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  valueLabelRadius: 10,
                  maxValue: 5,
                  starSpacing: 1,
                  maxValueVisibility: true,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                  valueLabelMargin: const EdgeInsets.only(right: 8),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                ),
                /*TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: 'Description',
                    hintStyle: const TextStyle(fontSize: 14),
                    icon: const Icon(CupertinoIcons.bubble_left_bubble_right,
                        color: AppColors.appColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),*/
                const SizedBox(height: 15),
                TextField(
                  controller:
                      dateController, //editing controller of this TextField
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: 'Date',
                    hintStyle: const TextStyle(fontSize: 14),
                    icon: const Icon(CupertinoIcons.calendar,
                        color: AppColors.appColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  readOnly: true, // when true user cannot edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      //get the picked date in the format => 2022-07-04 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(
                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                      print(
                          formattedDate); //formatted date output using intl package =>  2022-07-04
                      //You can format date as per your need

                      setState(() {
                        dateController.text =
                            formattedDate; //set foratted date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(isEdit ? 'Ändern' : 'Ok'),
              onPressed: () {
                final rating = isEdit
                    ? Rating(
                        id: ratings!.id!,
                        title: titleController.text,
                        description: descriptionController.text,
                        moderatorRating: moderatorValue ?? 0.0,
                        playlistRating: playlistValue ?? 0.0,
                        // if date is empty then use current date
                        date: dateController.text.isEmpty
                            ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                            : dateController.text,
                        completed: titleController.text.isEmpty)
                    : Rating(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        description: descriptionController.text,
                        moderatorRating: moderatorValue ?? 0.0,
                        playlistRating: playlistValue ?? 0.0,
                        date: dateController.text.isEmpty
                            ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                            : dateController.text,
                        completed: false,
                      );
                if (isEdit) {
                  var updatedTo = rating.copyWith(
                      completed: titleController.text.isNotEmpty);
                  BlocProvider.of<RatingBloc>(context)
                      .add(UpdateRating(rating.id!, updatedTo));
                  Navigator.pop(context);
                } else {
                  BlocProvider.of<RatingBloc>(context).add(AddRating(rating));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
