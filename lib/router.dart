import 'package:bynextcourier/bloc/arrival_bloc.dart';
import 'package:bynextcourier/bloc/driver_chat/driver_chat_bloc.dart';
import 'package:bynextcourier/bloc/shift_details_bloc.dart';
import 'package:bynextcourier/bloc/sign_contract/sign_contract_bloc.dart';
import 'package:bynextcourier/bloc/queued_tasks_bloc.dart';
import 'package:bynextcourier/bloc/token_bloc.dart';
import 'package:bynextcourier/model/assigned_shift.dart';
import 'package:bynextcourier/repository/driver_chat_repository.dart';
import 'package:bynextcourier/repository/schedule_repository.dart';
import 'package:bynextcourier/repository/sign_contract_repository.dart';
import 'package:bynextcourier/repository/queued_tasks_repository.dart';
import 'package:bynextcourier/screen/batched_orders/batched_orders_screen.dart';
import 'package:bynextcourier/screen/chat/driver_chat_screen.dart';
import 'package:bynextcourier/screen/forgot_password.dart';
import 'package:bynextcourier/screen/goto_location/task_go_to_location_step_2.dart';
import 'package:bynextcourier/screen/image_screen.dart';
import 'package:bynextcourier/screen/laundromat_dropoff/laundromat_dropoff_step1.dart';
import 'package:bynextcourier/screen/laundromat_pickup/laundromat_pickup_step1.dart';

import 'package:bynextcourier/screen/shifts.dart';
import 'package:bynextcourier/screen/sign_contract_screen.dart';
import 'package:bynextcourier/screen/goto_location/task_go_to_location.dart';
import 'package:bynextcourier/screen/supplies/pickup_supplies_step1.dart';
import 'package:bynextcourier/screen/tasks.dart';
import 'package:bynextcourier/screen/webview_screen.dart';
import 'package:bynextcourier/view/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/barcode_details_bloc.dart';
import 'bloc/forgot_password_bloc.dart';
import 'bloc/http_client_bloc.dart';
import 'bloc/issues_bloc.dart';
import 'bloc/payment_bloc.dart';
import 'bloc/schedule_bloc.dart';
import 'bloc/task/task_bloc.dart';
import 'constants.dart';
import 'generated/l10n.dart';
import 'helpers/task_router.dart';
import 'helpers/utils.dart';
import 'repository/barcode_details_repository.dart';
import 'repository/issues_repository.dart';
import 'repository/payment_repository.dart';
import 'repository/token_repository.dart';
import 'screen/delivery_to_client/customer_delivery_step3.dart';
import 'screen/issues.dart';
import 'screen/my_salary.dart';
import 'screen/navigation_settings.dart';
import 'screen/pickup/customer_pickup_step1.dart';
import 'screen/pickup/customer_pickup_step3.dart';
import 'screen/pickup/customer_pickup_step4.dart';
import 'screen/pickup/customer_pickup_step5.dart';

const webRoute = 'web';
const signContractRoute = 'signContract';
const forgotPasswordRoute = 'forgotPassword';
const tasksRoute = 'tasks';
const navigationSettingsRoute = 'navigationSettings';
const shiftsRoute = 'shifts';
const mySalaryRoute = 'mySalary';
const issuesRoute = 'issues';
const taskGoToLocationRoute = 'taskGoToLocation';
const taskGoToLocationStep2Route = 'taskGoToLocationStep2';
const taskPickupFromClientRoute = 'taskPickupFromClientRoute';
const taskPickupFromClientStep4Route = 'taskPickupFromClientStep4Route';
const taskPickupFromClientStep5Route = 'taskPickupFromClientStep5Route';
const taskPickupFromClientStep3Route = 'taskPickupFromClientStep3Route';
const taskPickupSuppliesRoute = 'taskPickupSuppliesRoute';
const taskDeliverToClientStep3Route = 'taskDeliverToClientStep3Route';
const taskLaundromatPickupRoute = 'taskLaundromatPickupRoute';
const taskLaundromatDropOffRoute = 'taskLaundromatDropOffRoute';
const taskBatchedOrdersRoute = 'taskBatchedOrdersRoute';
const imageRoute = 'imageRoute';
const driverChatRoute = 'driverChatRoute';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) {
          Widget page;
          switch (settings.name) {
//            case homeRoute:
//              page = HomeScreen();
//              break;
//            case splashRoute:
//              page = MultiBlocProvider(
//                providers: [BlocProvider(create: (context) => SplashBloc()..start())],
//                child: BlocListener<SplashBloc, SplashState>(
//                  listener: (context, state) {
//                    if (state is SplashDone) {
//                      Navigator.of(context).pushReplacementNamed(loginRoute);
//                    }
//                  },
//                  child: SplashScreen(),
//                ),
//              );
//              break;
//            case loginRoute:
//              page = MultiBlocProvider(
//                  providers: [
//                    BlocProvider(
//                      create: (context) => LoginFormBloc()
//                      ..tokenRepository = context.repository<TokenRepository>(),
//                    ),
//                  ],
//                  child: BlocListener<LoginFormBloc, LoginFormState>(
//                      listener: (context, loginFormState) {
//                        if (loginFormState is LoginFormDone) {
////                          Navigator.of(context).pushReplacementNamed(homeRoute);
//                        }
//                      },
//                      child: LoginScreen()));
//              break;
            case webRoute:
              final args = settings.arguments as Map;
              page = WebViewScreen(
                url: args['url'],
                title: args['title'] ?? '',
                shouldSignContract: args['shouldSignContract'] ?? false,
              );
              break;
            case forgotPasswordRoute:
              page = BlocProvider(
                  create: (context) => ForgotPasswordBloc()
                    ..tokenRepository = context.repository<TokenRepository>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>(),
                  child: ForgotPasswordScreen());
              break;
            case tasksRoute:
              page = BlocProvider(
                  create: (context) => QueuedTasksListBloc()
                    ..repository = context.repository<QueuedTasksRepository>()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..shiftDetailsBloc = context.bloc<ShiftDetailsBloc>(),
                  child: TasksScreen());
              break;
            case navigationSettingsRoute:
              page = NavigationSettingsScreen();
              break;
            case shiftsRoute:
              page = BlocProvider(
                  create: (context) => ScheduleBloc()
                    ..repository = context.repository<ScheduleRepository>()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..add(ScheduleLoad()),
                  child: BlocListener<ScheduleBloc, ScheduleState>(
                    listener: (context, scheduleState) async {
                      if (scheduleState is ScheduleReady && scheduleState.cancellationShift != null) {
                        if (scheduleState.cancellationLockedToChanges) {
                          showCustomDialog<bool>(context,
                              title: S.of(context).alertTitleReminder,
                              message: S.of(context).alertMessageCallReminder,
                              buttons: [
                                FlatButton(
                                  child: Text(S.of(context).ok),
                                  onPressed: () {},
                                ),
                                FlatButton(
                                  child: Text(S.of(context).call),
                                  onPressed: () async {
                                    if (await canLaunch('tel:')) {
                                      await launch('tel:${driverSupportNumber.replaceAll(RegExp(r'[^\+\d]'), '')}');
                                    }
                                  },
                                ),
                              ]);
                        } else {
                          bool cancellationConfirm = await showCustomDialog<bool>(context,
                              title: S.of(context).alertTitleShiftCancellation,
                              message:
                                  'You will be canceled from ${scheduleState.cancellationSchedule.date}, ${scheduleState.cancellationSchedule.dayName}  ${scheduleState.cancellationShift.type.description} shift. \n \n Are you sure?',
                              buttons: [
                                FlatButton(
                                  child: Text(S.of(context).no),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                FlatButton(
                                  child: Text(S.of(context).yes),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ]);
                          final assigned = scheduleState.assigned[scheduleState.cancellationShift.id];
                          if (cancellationConfirm == true) {
                            if (assigned.lessThen24h) {
                              cancellationConfirm = await showCustomDialog<bool>(context,
                                  title: S.of(context).alertTitleShiftCancellation,
                                  message: S.of(context).alertMessageLessThan24hCancellation,
                                  buttons: [
                                    FlatButton(
                                      child: Text(S.of(context).no),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    FlatButton(
                                      child: Text(S.of(context).yes),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ]);
                            }
                          }

                          TextEditingController reasonController = TextEditingController();
                          if (cancellationConfirm == true && assigned.status != AssignedShiftStatus.pending) {
                            cancellationConfirm = await showCustomDialog2(context,
                                title: Text(S.of(context).alertTitleShiftCancellationReason),
                                child: TextField(
                                  controller: reasonController,
                                  minLines: 4,
                                ),
                                buttons: [
                                  IconButton(
                                    icon: Image.asset('assets/images/checkbox-red-declined.png'),
                                    onPressed: () => Navigator.of(context).pop(false),
                                  ),
                                  IconButton(
                                    icon: ColorFiltered(
                                      colorFilter: const ColorFilter.mode(const Color(0xFF403D9C), BlendMode.srcIn),
                                      child: Image.asset('assets/images/checkbox-grey-checked.png'),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(true),
                                  ),
                                ]);

                            if (cancellationConfirm && reasonController.text.trim().length == 0) {
                              showCustomDialog2(context,
                                  title: Text('Error'),
                                  child: Text('Please specify reason for cancellation'),
                                  buttons: [
                                    FlatButton(child: Text('OK'), onPressed: () => Navigator.of(context).pop())
                                  ]);
                              cancellationConfirm = false;
                            }
                          }
                          if (cancellationConfirm == true) {
                            context
                                .bloc<ScheduleBloc>()
                                .add(ScheduleCancelShift(scheduleState.cancellationShift.id, reasonController.text));
                          }
                        }
                        // to allow next selection of teh same item
                        context.bloc<ScheduleBloc>().add(ScheduleBlankEvent());
                      }
                    },
                    child: ShiftsScreen(),
                  ));
              break;
            case mySalaryRoute:
              page = BlocProvider(
                  create: (context) => PaymentBloc()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..repository = context.repository<PaymentRepository>(),
                  child: MySalaryScreen());
              break;
            case issuesRoute:
              page = BlocProvider(
                  create: (context) => IssuesBloc()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..repository = context.repository<IssueRepository>(),
                  child: IssuesScreen());
              break;
            case signContractRoute:
              page = BlocProvider(
                  create: (context) => SignContractBloc()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..shiftDetailsBloc = context.bloc<ShiftDetailsBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>()
                    ..repository = context.repository<SignContractRepository>(),
                  child: Stack(
                    children: <Widget>[
                      SignContractScreen(),
                      BlocBuilder<SignContractBloc, SignContractState>(
                        builder: (context, state) =>
                            state is SignContractProcessing ? CustomProgressIndicator() : Container(),
                      )
                    ],
                  ));
              break;
            case taskGoToLocationRoute:
              page = TaskGoToLocationScreen();
              break;
            case taskGoToLocationStep2Route:
              page = TaskGoToLocationStep2Screen();
              break;
            case taskPickupFromClientRoute:
              // common 1st route for pickup and delivery from customer
              page = BlocListener<ArrivalBloc, ArrivalState>(
                listener: TaskRouter.arrivalListener,
                child: CustomerPickupStep1(),
              );
              break;
            case taskPickupFromClientStep4Route:
              page = CustomerPickupStep4();
              break;
            case taskPickupFromClientStep5Route:
              page = BlocProvider(
                create: (context) => BarcodeDetailsBloc()
                  ..tokenBloc = context.bloc<TokenBloc>()
                  ..httpClientBloc = context.bloc<HttpClientBloc>()
                  ..taskBloc = context.bloc<TaskBloc>()
                  ..repository = context.repository<BarcodeDetailsRepository>()
                  ..add(GetBarcodeDetails()),
                child: CustomerPickupStep5(),
              );
              break;
            case taskPickupFromClientStep3Route:
              page = CustomerPickupStep3();
              break;
            case taskPickupSuppliesRoute:
              page = PickupSuppliesStep1();
              break;
            case taskDeliverToClientStep3Route:
              page = BlocProvider(
                create: (context) => BarcodeDetailsBloc()
                  ..tokenBloc = context.bloc<TokenBloc>()
                  ..httpClientBloc = context.bloc<HttpClientBloc>()
                  ..taskBloc = context.bloc<TaskBloc>()
                  ..repository = context.repository<BarcodeDetailsRepository>()
                  ..add(GetBarcodeDetails()),
                child: CustomerDeliveryStep3(),
              );
              break;
            case taskLaundromatPickupRoute:
              page = LaundromatPickupStep1();
              break;
            case taskLaundromatDropOffRoute:
              page = LaundromatDropOffStep1();
              break;
            case taskBatchedOrdersRoute:
              page = BatchedOrdersScreen();
              break;
            case imageRoute:
              page = ImageScreen(
//                url: settings.arguments,
                imageProvider: settings.arguments,
              );
              break;
            case driverChatRoute:
              final args = settings.arguments as Map;
              page = BlocProvider(
                  create: (context) => DriverChatBloc()
                    ..repository = context.repository<DriverChatRepository>()
                    ..tokenBloc = context.bloc<TokenBloc>()
                    ..httpClientBloc = context.bloc<HttpClientBloc>(),
                  child: DriverChatScreen(task: args['task']));
              break;
            default:
              page = Scaffold(
                appBar: AppBar(),
                body: Center(child: Text('No route defined for ${settings.name}')),
              );
          }
          return GestureDetector(onTap: () => FocusScope.of(context).requestFocus(new FocusNode()), child: page);
        });
  }
}
