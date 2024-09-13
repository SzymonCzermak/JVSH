class AIContext {
  String conTEX = '';

  AIContext();

  // Metoda do ustawiania wartości zmiennej con
  void updateContext(String newContext) {
    conTEX = newContext;
  }

  // Metoda do zwrócenia aktualnej wartości zmiennej con
  String getContext() {
    return conTEX;
  }
}
