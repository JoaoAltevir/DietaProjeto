class Alimento {
  String id;
  String nome;
  String carboidratos;
  String gordura;
  String proteina;
  String caloria;
  String unidadeMedida;
  String valorCota;

  Alimento({this.id = '', required this.nome, required this.caloria,required this.unidadeMedida,required this.valorCota,this.carboidratos="",this.gordura="",this.proteina=""});
  
}