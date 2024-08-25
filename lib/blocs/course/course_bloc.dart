import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:edu_vista/models/course.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<CourseFetchEvent>(_onGetCourse);
  }

  FutureOr<void> _onGetCourse(CourseEvent event, Emitter<CourseState> emit) {}
}
