import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {

  DashboardCubit() : super(const DashboardState(navBarItem: NavBarItem.place));

  DateTime? backButtonPressTime;
  final snackBarDuration = const Duration(seconds: 3);

  void pickItem(int i) async {
    switch (i) {
      case 0:
        emit(const DashboardState(navBarItem: NavBarItem.place));
        break;
      case 1:
        emit(const DashboardState(navBarItem: NavBarItem.tourguide));
        break;
    }
  }

  Future<bool> handleWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed = backButtonPressTime == null || now.difference(backButtonPressTime!) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      // CoreFunction.showToast("Tekan sekali lagi untuk keluar");
      return false;
    }
    return true;
  }
}
