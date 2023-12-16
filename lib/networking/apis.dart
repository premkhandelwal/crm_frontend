class Apis {
  // Base Urls
  static const String devBaseUrl = "http://localhost:3000/api/";
  static const String prodBaseUrl =
      "https://apricot-hummingbird-tam.cyclic.app/api/";
  static const String activeBaseUrl = devBaseUrl;

  // API Paths
  static const String addCustomer = "/masters/addCustomer";
  static const String editCustomer = "/masters/editCustomer";
  static const String deleteCustomer = "/masters/deleteCustomer";
  static const String fetchCustomers = "/masters/getAllCustomers";

  static const String addHarness = "/masters/addHarness";
  static const String editHarness = "/masters/editHarness";
  static const String deleteHarness = "/masters/deleteHarness";
  static const String fetchHarness = "/masters/getAllHarness";

  static const String addBms = "/masters/addBms";
  static const String editBms = "/masters/editBms";
  static const String deleteBms = "/masters/deleteBms";
  static const String fetchBms = "/masters/getAllBms";

  static const String addBatch = "/masters/addBatch";
  static const String editBatch = "/masters/editBatch";
  static const String deleteBatch = "/masters/deleteBatch";
  static const String fetchBatch = "/masters/getAllBatch";

  static const String addMake = "/masters/addMake";
  static const String editMake = "/masters/editMake";
  static const String deleteMake = "/masters/deleteMake";
  static const String fetchMake = "/masters/getAllMake";

  static const String addComplaint = "/addDetails/addComplaint";
  static const String fetchComplaint = "/addDetails/fetchComplaints";
}
