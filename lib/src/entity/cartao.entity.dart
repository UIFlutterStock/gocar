class Cartao {
  Cartao(
      {this.CardNumber = '',
      this.NomeUsuario = '',
      this.DataExpiracao = '',
      this.ExpirationDate = '',
      this.SecurityCode = '',
      this.Brand = ''});

  String CardNumber;
  String NomeUsuario;
  String DataExpiracao;
  String ExpirationDate;
  String SecurityCode;
  String Brand;

  Cartao.fromMap(Map<dynamic, dynamic> data)
      : CardNumber = data["CardNumber"],
        NomeUsuario = data["NomeUsuario"],
        DataExpiracao = data["DataExpiracao"],
        ExpirationDate = data["DataExpiracao"],
        SecurityCode = data["DataExpiracao"],
        Brand = data["Brand"];

  toJson() {
    return {
      "CardNumber": this.CardNumber,
      "NomeUsuario": this.NomeUsuario,
      "DataExpiracao": this.DataExpiracao,
      "ExpirationDate": this.ExpirationDate,
      "SecurityCode": this.SecurityCode,
      "Brand": this.Brand,
    };
  }
}
