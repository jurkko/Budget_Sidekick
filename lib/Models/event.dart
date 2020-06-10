
class Event {
  String name;
  String dueDate;
  //this shouldnt be negative anyway
  double target;
  double current;
  String uid;
  Event({this.name, this.dueDate, this.target, this.current});
}
