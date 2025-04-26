import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminDashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectScreen extends AdminDashboardEvent {
  final int index;

  SelectScreen(this.index);

  @override
  List<Object?> get props => [index];
}

abstract class AdminDashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminDashboardInitial extends AdminDashboardState {
  final int selectedIndex;

  AdminDashboardInitial({required this.selectedIndex,});

  AdminDashboardInitial copyWith({int? selectedIndex, int? notificationCount}) {
    return AdminDashboardInitial(
      selectedIndex: selectedIndex ?? this.selectedIndex,

    );
  }

  @override
  List<Object?> get props => [selectedIndex];
}

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {

  AdminDashboardBloc()
      : super(AdminDashboardInitial(selectedIndex: 0,)) {

    on<SelectScreen>((event, emit) {
      if (state is AdminDashboardInitial) {
        final currentState = state as AdminDashboardInitial;
        emit(currentState.copyWith(selectedIndex: event.index));
      }
    });


  }
}

