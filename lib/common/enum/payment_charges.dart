enum PaymentCharges {
  debitCart(1.5),
  creditCard(2.5);

  const PaymentCharges(this.value);
  final double value;
}
