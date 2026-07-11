# Answers

## Checkpoint 1
On hot-reload, build() runs again but initState() does not, because build() redraws the UI while initState() only fires once when the widget is first created.

## Section 4
The QuantityStepper can be stateless because it only receives the current quantity and two callbacks; the parent widget manages the state with setState().

