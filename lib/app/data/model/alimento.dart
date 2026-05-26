class Alimento {
  int id;
  String nome;
  String carboidratos;
  String gordura;
  String proteina;
  String caloria;
  String unidadeMedida;
  String valorCota;

  Alimento({this.id = 0, required this.nome, required this.caloria,required this.unidadeMedida,required this.valorCota,this.carboidratos="",this.gordura="",this.proteina=""});
  
}