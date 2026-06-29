import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:flutter/material.dart';
import 'package:m_cubit/abstraction.dart';

import '../../../../generated/l10n.dart';

part 'home_state.dart';

class HomeCubit extends MCubit<HomeInitial> {
  HomeCubit() : super(HomeInitial.initial());

  @override
  AbstractState get mState => state;

  void initialController() {
    state.controller.dispose();
    emit(state.copyWith(controller: PageController(initialPage: 0)));
  }

  int get getIndex {
    try {
      if (!state.controller.hasClients) return 0;
      return state.controller.page?.round() ?? 0;
    } catch (e) {
      return 0;
    }
  }

  bool get canPop {
    try {
      if (!state.controller.hasClients) return true;
      return state.controller.page?.round() == 0;
    } catch (e) {
      return true;
    }
  }

  void jumpPage(int i) {
    try {
      if (state.controller.hasClients) {
        state.controller.jumpToPage(i);
      }
    } catch (e) {
      loggerObject.e('HomeCubit jumpPage error: $e');
    }
    emit(state.copyWith(notify: state.notify + 1));
  }

  void refresh() {
    emit(state.copyWith(notify: state.notify + 1));
  }

  @override
  Future<void> close() {
    state.controller.dispose();
    return super.close();
  }
}
