class ParametreHideAmountEvent {
  const ParametreHideAmountEvent();
}

/// Init listener
class ParametreHideAmountInitEvent extends ParametreHideAmountEvent {
  const ParametreHideAmountInitEvent();
}

/// Start listen
class ParametreHideAmountStartEvent extends ParametreHideAmountEvent {
  const ParametreHideAmountStartEvent();
}

/// Stop listen
class ParametreHideAmountStopEvent extends ParametreHideAmountEvent {
  const ParametreHideAmountStopEvent();
}
