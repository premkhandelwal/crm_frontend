enum SubmissionStatus { initial, inProgress, success, failure }

enum ComplaintStatus {
  notResolved("Not Resolved"),
  notTested("Not Tested"),
  completed("completed"),
  dispatched("Dispatched"),
  waste("Waste");

  final String status;
  const ComplaintStatus(this.status);
}
