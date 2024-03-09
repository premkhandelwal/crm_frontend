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
import 'package:crm/ui/screens/add_screens/add_batch_screen.dart';
import 'package:crm/ui/screens/add_screens/add_customer_screen.dart';
import 'package:crm/ui/screens/add_screens/add_vehicle_manufacturer_screen.dart';
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
    masterBloc.add(FetchBatchEvent());
    infoBloc.add(FetchAllComplaintsEvent());
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

    void addCustomer() async {
      final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const AddCustomerScreen(returnData: true),
      ));
      customers.add(result);
    }

    void addVehicleManufacturer() async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => AddVehicleManufacturerScreen(
            returnData: true,
            editVehicleManufacturer: VehicleManufacturer(
                name: "", customerId: selectedCustomer!.id)),
      ));
      if (selectedCustomer != null) {
        masterBloc.add(
            FetchVehicleForCustomerEvent(customerId: selectedCustomer!.id));
      }
    }

    void addBatch() async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => AddBatchScreen(
            returnData: true,
            editBatch: Batch(
                batchName: "",
                customerId: selectedCustomer!.id,
                vehicleManufacturerId: selectedVehicleManufacturer!.id)),
      ));
      if (selectedVehicleManufacturer != null) {
        masterBloc.add(FetchBatchForVehicleManufacturerEvent(
            vehicleManufacturerId: selectedVehicleManufacturer!));
      }
    }

    void addBmsSerialNo(BuildContext context, Batch? selectedBatchForCustomer) {
      TextEditingController ctller = TextEditingController();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Add Serial No"),
          content: TextFormField(
            controller: ctller,
            decoration: const InputDecoration(hintText: "Enter BMS Serial No"),
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
    }

    return BlocConsumer<ComplaintCubit, ComplaintState>(
      listener: (context, complaintState) {
        if (complaintState is SelectedCustomerChangedState) {
          layerInd = 1; //Into the Vehicle Manufacturer screen
          selectedCustomer = complaintState.customer;
          filteredComplaintList.removeWhere(
              (element) => element.customerId != selectedCustomer?.id);
          masterBloc.add(FetchVehicleForCustomerEvent(
              customerId: complaintState.customer.id));
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
              } else if (customerState is FetchVehicleForCustomerState &&
                  customerState.submissionStatus == SubmissionStatus.success) {
                vehicleManufacturerListForCustomer =
                    List.from(customerState.vehicleManufacturerList);
              }
            },
            builder: (context, customerState) {
              // Your existing UI code...
              if (customerState.submissionStatus ==
                  SubmissionStatus.inProgress) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    Center(
                        child: Text((customerState is FetchCustomerState
                            ? "Fetching customers..."
                            : customerState is FetchVehicleForCustomerState
                                ? "Fetching vehicle manufacturers..."
                                : customerState is FetchBatchForVehicleManufacturerState
                                    ? "Fetching batch..."
                                    : customerState is FetchBmsState
                                        ? "Fetching BMS..."
                                        : customerState is FetchHarnessState
                                            ? "Fetching Harness..."
                                            : customerState is FetchMakeState
                                                ? "Fetching Make..."
                                                : "Fetching...")))
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
                          child: BlocConsumer<InfoBloc, InfoState>(
                            listener: (context, state) {
                              if (state is ComplaintSubmitState &&
                                  state.submissionStatus ==
                                      SubmissionStatus.success) {
                                if (state.complaint != null) {
                                  complaintsList.add(state.complaint!);
                                  filteredComplaintList.add(state.complaint!);
                                  filteredComplaint = state.complaint;
                                }
                              } else if (state is ComplaintFetchState &&
                                  state.submissionStatus ==
                                      SubmissionStatus.success) {
                                complaintsList = List.from(state.complaintList);
                                filteredComplaintList =
                                    List.from(complaintsList);
                              } else if (state is UpdateComplaintStatusState &&
                                  state.status == SubmissionStatus.success) {
                                int indInComplaintList = -1;
                                int indInFilteredComplaintList = -1;
                                if (filteredComplaint != null) {
                                  filteredComplaint = state.complaint;

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
                                }
                              }
                            },
                            builder: (context, state) {
                              return selectedCustomer == null
                                  ? customers.isNotEmpty
                                      ? buildCustomerWidget(customers)
                                      : const Center(
                                          child: Text("No customers found!!"))
                                  : layerInd == 1
                                      ? vehicleManufacturerListForCustomer
                                              .isNotEmpty
                                          ? buildVehicleManufacturerListView(
                                              vehicleManufacturerListForCustomer,
                                              filteredComplaintList)
                                          : const Center(
                                              child: Text(
                                                  "No vehicle manufacturers found!!"))
                                      : layerInd == 2
                                          ? batchListForCustomer.isNotEmpty
                                              ? buildBatchListView(
                                                  batchListForCustomer,
                                                  filteredComplaintList)
                                              : const Center(
                                                  child:
                                                      Text("No batch found!!"))
                                          : layerInd == 3
                                              ? serialNoListforSelectedBms
                                                      .isNotEmpty
                                                  ? buildBmsSerialNoListView(
                                                      serialNoListforSelectedBms,
                                                      filteredComplaintList)
                                                  : const Center(
                                                      child: Text(
                                                          "No BMS Serial Number added!!"))
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
          floatingActionButton: layerInd != 4
              ? FloatingActionButton(
                  onPressed: () async {
                    layerInd == 0
                        ? addCustomer()
                        : layerInd == 1
                            ? addVehicleManufacturer()
                            : layerInd == 2
                                ? addBatch()
                                : layerInd == 3
                                    ? addBmsSerialNo(
                                        context, selectedBatchForCustomer)
                                    : Container();
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
