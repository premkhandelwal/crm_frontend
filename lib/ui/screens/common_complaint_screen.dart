// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:crm/enums.dart';
import 'package:crm/logic/blocs/info/info_bloc.dart';
import 'package:crm/logic/blocs/master/master_bloc.dart';
import 'package:crm/logic/cubits/complaint/complaint_cubit.dart';
import 'package:crm/models/batch_request.dart';
import 'package:crm/models/bms_request.dart';
import 'package:crm/models/complaint_request.dart';
import 'package:crm/models/customer_request.dart';
import 'package:crm/models/vehicle_manufacturer_request.dart';
import 'package:crm/ui/screens/common_complaint_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<Customer> customers = [];
List<Bms> bmsList = [];

class CommonComplaintScreen extends StatefulWidget {
  const CommonComplaintScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CommonComplaintScreen> createState() => _CommonComplaintScreenState();
}

class _CommonComplaintScreenState extends State<CommonComplaintScreen> {
  late MasterBloc masterBloc;
  late InfoBloc infoBloc;
  late ComplaintCubit complaintCubit;

  @override
  void initState() {
    masterBloc = BlocProvider.of<MasterBloc>(context);
    infoBloc = BlocProvider.of<InfoBloc>(context);
    complaintCubit = BlocProvider.of<ComplaintCubit>(context);
    masterBloc.add(FetchCustomerEvent());
    masterBloc.add(FetchBmsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Customer? selectedCustomer;

    List<VehicleManufacturer> vehicleManufacturerListForCustomer = [];
    VehicleManufacturer? selectedVehicleManufacturer;
    List<Batch> batchListForCustomer = [];
    Batch? selectedBatchForCustomer;
    List<String> serialNoListforSelectedBms = [];
    String? selectedBmsSerialNo;
    List<Complaint> complaintsList = [];
    List<Complaint> filteredComplaintList = [];
    int layerInd = 0; //Home Page
    Complaint? filteredComplaint;

    return BlocConsumer<ComplaintCubit, ComplaintState>(
      listener: (context, complaintState) {
        if (complaintState is SelectedCustomerChangedState) {
          layerInd = 1; //Into the Vehicle Manufacturer screen
          selectedCustomer = complaintState.customer;
          filteredComplaintList.removeWhere(
              (element) => element.customerId != selectedCustomer?.id);
          infoBloc.add(FetchVehicleForCustomerEvent(
              customerId: complaintState.customer.id));
          infoBloc.add(
              FetchComplaintsEvent(customerId: complaintState.customer.id));
        } else if (complaintState is SelectedBatchChangedState) {
          layerInd = 3; //Into the Bms sr no screen

          selectedBatchForCustomer = complaintState.batch;
          filteredComplaintList.removeWhere(
              (element) => element.batchId != selectedBatchForCustomer?.id);

          serialNoListforSelectedBms =
              selectedBatchForCustomer?.bmsSrNoList ?? [];
        } else if (complaintState is SelectedSerialNoChangedState) {
          layerInd = 4; //Into the Complaint screen
          selectedBmsSerialNo = complaintState.serialNo;

          int indComplaint = filteredComplaintList.indexWhere(
              (element) => element.bmsSerialNo == selectedBmsSerialNo);
          if (indComplaint == -1) {
            filteredComplaint = null;
          } else {
            filteredComplaint = filteredComplaintList[indComplaint];
          }
        }
      },
      builder: (context, complaintState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
          ),
          body: BlocConsumer<MasterBloc, MasterState>(
            listener: (context, customerState) {
              if (customerState is FetchCustomerState &&
                  customerState.submissionStatus == SubmissionStatus.success) {
                customers = List.from(customerState.customerList);
              } else if (customerState is FetchBmsState &&
                  customerState.submissionStatus == SubmissionStatus.success) {
                bmsList = List.from(customerState.bmsList);
              } else if (customerState
                      is FetchBatchForVehicleManufacturerState &&
                  customerState.submissionStatus == SubmissionStatus.success) {
                layerInd = 2; //Into the batch screen
                selectedVehicleManufacturer = customerState.vehicleManufacturer;
                filteredComplaintList.removeWhere((element) =>
                    element.vehicleManufacturerId !=
                    selectedVehicleManufacturer?.id);
                batchListForCustomer = customerState.batchList;
              }
            },
            builder: (context, customerState) {
              // Your existing UI code...
              if (customerState is FetchCustomerState &&
                  customerState.submissionStatus ==
                      SubmissionStatus.inProgress) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Center(child: Text("Fetching customers"))
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Go back button code
                      if (selectedCustomer != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      filteredComplaintList =
                                          List.from(complaintsList);
                                      if (selectedBmsSerialNo != null) {
                                        layerInd = 3;
                                        selectedBmsSerialNo = null;
                                        filteredComplaintList = List.from(
                                            filteredComplaintList.where(
                                                (element) =>
                                                    element.batchId ==
                                                    selectedBatchForCustomer
                                                        ?.id));
                                      } else if (selectedBatchForCustomer !=
                                          null) {
                                        layerInd = 2;
                                        selectedBatchForCustomer = null;
                                        filteredComplaintList = List.from(
                                            filteredComplaintList.where(
                                                (element) =>
                                                    element
                                                        .vehicleManufacturerId ==
                                                    selectedVehicleManufacturer
                                                        ?.id));
                                      } else if (selectedVehicleManufacturer !=
                                          null) {
                                        layerInd = 1;
                                        selectedVehicleManufacturer = null;
                                        filteredComplaintList =
                                            List.from(complaintsList);
                                      } else {
                                        layerInd = 0;
                                        selectedCustomer = null;
                                      }

                                      // filteredComplaint = null;
                                      complaintCubit
                                          .backButtonPressed(layerInd);
                                    },
                                    child: const Text("Go back")),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      //User action
                      (layerInd == 4 && filteredComplaint == null)
                          ? Container()
                          : buildUserActionDescription(
                              selectedCustomer,
                              selectedVehicleManufacturer,
                              selectedBatchForCustomer,
                              selectedBmsSerialNo),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: selectedCustomer == null
                              ? buildCustomerWidget(customers)
                              : BlocConsumer<InfoBloc, InfoState>(
                                  listener: (context, state) {
                                    if (state is FetchVehicleForCustomerState &&
                                        state.submissionStatus ==
                                            SubmissionStatus.success) {
                                      vehicleManufacturerListForCustomer =
                                          List.from(
                                              state.vehicleManufacturerList);
                                    } else if (state is ComplaintFetchState &&
                                        state.submissionStatus ==
                                            SubmissionStatus.success) {
                                      complaintsList =
                                          List.from(state.complaintList);
                                      filteredComplaintList =
                                          List.from(complaintsList);
                                    } else if (state
                                            is UpdateComplaintStatusState &&
                                        state.status ==
                                            SubmissionStatus.success) {
                                      int indInComplaintList = -1;
                                      int indInFilteredComplaintList = -1;
                                      if (filteredComplaint != null) {
                                        indInComplaintList = complaintsList
                                            .indexOf(filteredComplaint!);
                                        indInFilteredComplaintList =
                                            filteredComplaintList
                                                .indexOf(filteredComplaint!);
                                      }
                                      if (state.complaint != null) {
                                        if (indInComplaintList != -1) {
                                          complaintsList[indInComplaintList] =
                                              state.complaint!;
                                        }
                                        if (indInFilteredComplaintList != -1) {
                                          filteredComplaintList[
                                                  indInFilteredComplaintList] =
                                              state.complaint!;
                                        }
                                        filteredComplaint = state.complaint;
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    return layerInd == 1
                                        ? buildVehicleManufacturerListView(
                                            vehicleManufacturerListForCustomer,
                                            filteredComplaintList)
                                        : layerInd == 2
                                            ? buildBatchListView(
                                                batchListForCustomer,
                                                filteredComplaintList)
                                            : layerInd == 3
                                                ? buildBmsSerialNoListView(
                                                    serialNoListforSelectedBms,
                                                    filteredComplaintList)
                                                : (layerInd == 4)
                                                    ? ComplaintForm(
                                                        selectedCustomer:
                                                            selectedCustomer,
                                                        selectedBatchForCustomer:
                                                            selectedBatchForCustomer,
                                                        selectedVehicleManufacturer:
                                                            selectedVehicleManufacturer,
                                                        selectedBmsSerialNo:
                                                            selectedBmsSerialNo,
                                                        filteredComplaint:
                                                            filteredComplaint,
                                                      )
                                                    : Container();
                                  },
                                ))
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: layerInd == 3
              ? FloatingActionButton(
                  onPressed: () {
                    TextEditingController ctller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Add Serial No"),
                        content: TextFormField(
                          controller: ctller,
                          decoration: const InputDecoration(
                              hintText: "Enter BMS Serial No"),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              List<String> bmsSrNoList =
                                  selectedBatchForCustomer?.bmsSrNoList ?? [];
                              bmsSrNoList.add(ctller.text);
                              masterBloc.add(AddBmsSrNoInBatchEvent(
                                  batch: selectedBatchForCustomer!
                                      .copyWith(bmsSrNoList: bmsSrNoList)));
                            },
                            child: const Text("Add"),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
