

enum ReferenciaLocal{
  Origem,
  Destino
}


enum StatusViagem{
  Aberta,
  AguardadandoMotorista,
  MotoristaNotificado,
  MotoristaACaminho,
  Iniciada,
  Finalizada,
  Cancelada
}

enum AcaoRelatorio {
  Editar,
  Deletar
}


enum StepMotoristaHome {
  Inicio, /*primeira etapa do processo*/
  Procurandoviagem, /*procurando motorista*/
  Viagemencontrada, /*notifica ao motorista com pergunta se ele quer aceitar*/
  Viagemaceita, /*motorista aceitou viagem, motorista vai até o passageiro*/
  Iniciarviagem, /*motorista aceitou viagem, motorista vai até o passageiro*/
  Fimviagem /*fim corrida*/
}

enum StepPassageiroHome {
  Inicio, /*primeira etapa do processo*/
  SelecionarOrigemDestino, /*menu com busca de itens*/
  ConfirmaValor, /*menu confirmacao de corrida*/
  ProcurandoMotorista, /*procurando motorista*/
  Procurandoviagem, /*procurando motorista*/
  Viagemencontrada, /*notifica ao motorista com pergunta se ele quer aceitar*/
  MotoristaAceitou, /*motorista aceitou viagem, motorista vai até o passageiro*/
  CorridaAndamento, /*fim corrida*/
  Fimcorrida /*fim corrida*/
}

enum TipoCarro{
  Pop,
  Top
}

enum TipoLocal{
  casa,
  trabalho
}

enum Ambiente {
  Passageiro,
  Motorista
}