import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/payment.dart';
import 'package:bynextcourier/repository/payment_repository.dart';
import 'package:equatable/equatable.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentRepository repository;
  TokenBloc _tokenBloc;

  StreamSubscription<TokenState> _tokenSubscription;


  set tokenBloc(TokenBloc value) {
    if (_tokenBloc != value){
      _tokenBloc = value;
      _tokenSubscription = _tokenBloc.listen((tokenState) {
        if(tokenState.token != null){
          add(GetPayment());
//          _tokenSubscription.cancel();
        }
      });
    }
  }


  @override
  Future<Function> close() {
    _tokenSubscription?.cancel();
    return super.close();
  }

  @override
  get initialState => PaymentState(null);

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is GetPayment) {
      try {
        final payment = await repository.fetchPayment(_tokenBloc.state.token);
        yield PaymentState(payment);
      }
      catch (e){
        yield PaymentState(null);
      }
    }
  }
}

// Events
abstract class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPayment  extends PaymentEvent {}

// States
class PaymentState extends Equatable {
  PaymentState(this.payment);

  @override
  List<Object> get props => [payment];

  final Payment payment;
}