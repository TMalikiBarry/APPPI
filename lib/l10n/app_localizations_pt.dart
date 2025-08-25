// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'PI';

  @override
  String get welcome => 'Bem-vindo!';

  @override
  String get noFees => 'Gratuito';

  @override
  String get internetErrorTitle => '😔 Oooops';

  @override
  String get internetErrorSubtitle => 'Parece que você não tem conexão com a internet ou que o servidor não está disponível!';

  @override
  String get serverErrorTitle => '😔 Oooops';

  @override
  String get serverErrorSubtitle => 'Ocorreu um erro, tente novamente mais tarde.';

  @override
  String get erreurInattendue => 'Ocorreu um erro inesperado';

  @override
  String get reessayer => 'Tente novamente';

  @override
  String get errorDialogOk => 'Entendi';

  @override
  String get btnTextReject => 'Rejeitar';

  @override
  String get btnTextAccept => 'Aceitar';

  @override
  String get btnTextConfirm => 'Confirmar';

  @override
  String get btnTextCancel => 'Cancelar';

  @override
  String get btnTextYes => 'Sim';

  @override
  String get btnTextNo => 'Não';

  @override
  String get btnTextContinue => 'Continuar';

  @override
  String get btnTextSend => 'Enviar';

  @override
  String get btnTextAsk => 'Pedir';

  @override
  String get btnTextPay => 'Pagar';

  @override
  String get btnTextEdit => 'Editar';

  @override
  String get btnTextDisable => 'Desativar';

  @override
  String get btnTextEnable => 'Ativar';

  @override
  String get btnTextDelete => 'Deletar';

  @override
  String get btnTextSave => 'Salvar';

  @override
  String get statutLabel => 'Status';

  @override
  String get statutInitie => 'Em espera';

  @override
  String get statutRejete => 'Rejeitado';

  @override
  String get statutAccepte => 'Aceito';

  @override
  String get statutActive => 'Ativo';

  @override
  String get statutDesactive => 'Desativado';

  @override
  String get introductionLegende => 'Bem-vindo ao SPI';

  @override
  String get introductionItem1 => 'Gerencie suas despesas atribuindo orçamentos';

  @override
  String get introductionItem2 => 'Economize para realizar seus sonhos';

  @override
  String get introductionItem3 => 'Planeje seus pagamentos para se livrar da dor';

  @override
  String get introductionItem4 => 'Pague e transfira gratuitamente para qualquer conta';

  @override
  String get introductionItem5 => 'Economize e compartilhe despesas entre amigos';

  @override
  String get introductionItem6 => 'Utilize o alias para privacidade e precisão';

  @override
  String get introductionLogin => 'Conectar';

  @override
  String get introductionGotIt => 'Got it';

  @override
  String get introductionFooterTitle => 'Você não tem uma conta';

  @override
  String get introductionFooterSubtitle => 'Encontre uma agência próxima';

  @override
  String get loginPageTitle => 'Conectar';

  @override
  String get loginPageSubTitle => 'Utilize o identificador obtido da sua instituição financeira';

  @override
  String get loginPageFooterIntro => 'Continuando, você concorda com ';

  @override
  String get loginPageFooterCGU => 'nosso Termo de uso';

  @override
  String get loginPageFooterPC => 'nossa Política de privacidade';

  @override
  String get coordinationEt => 'e';

  @override
  String get loginFormUsernameLabel => 'Identificador';

  @override
  String get loginFormUsernameHint => 'Fornecido pela instituição';

  @override
  String get loginUsernameErrorEmpty => 'Identificador obrigatório';

  @override
  String get loginUsernameErrorInvalid => 'Identificador inválido';

  @override
  String get loginFormPasswordLabel => 'Senha';

  @override
  String get loginFormPasswordHint => 'Senha';

  @override
  String get loginPasswordErrorEmpty => 'Senha obrigatória';

  @override
  String get loginPasswordErrorInvalid => 'Senha inválida';

  @override
  String get loginFormBtnConnexion => 'Continuar';

  @override
  String get changePasswordPageTitle => 'Mudar senha';

  @override
  String get changePasswordPageSubTitle => 'Por favor, mude sua senha para a segurança';

  @override
  String get changePasswordFormPasswordHint => 'Definir uma nova senha';

  @override
  String get changePasswordFormConfirmHint => 'Confirme a nova senha';

  @override
  String get changePasswordFormBtnConnexion => 'Validar';

  @override
  String get changePasswordErrorEmpty => 'Nova senha obrigatória';

  @override
  String get changePasswordErrorInvalid => 'Deve conter pelo menos um dígito, uma letra e o caractere @ ou _';

  @override
  String get changePasswordErrorDifferent => 'As duas senhas são diferentes';

  @override
  String get createCodePinFormTitle => 'Crie seu código pin';

  @override
  String get createCodePinFormSubTitle => 'Ele contribui para proteger suas informações confidenciais na próxima vez que você abrir o aplicativo';

  @override
  String get configureBiometryMethod => 'a biometria';

  @override
  String get configureBiometryMethodFace => 'Face ID';

  @override
  String get configureBiometryMethodFingerprint => 'empreinte';

  @override
  String configureBiometryFormTitle(String method) {
    return 'Ative $method para a próxima vez?';
  }

  @override
  String configureBiometryFormSubTitle(String method) {
    return 'Utilize $method em vez do código PIN';
  }

  @override
  String configureBiometryFormSubmitBtn(String method) {
    return 'Utilizar $method';
  }

  @override
  String get configureBiometryFormNotNowBtn => 'Não agora';

  @override
  String get identificationFormLoginMessage => 'Digite seu código PIN';

  @override
  String get identificationFormForgotMessage => 'Código PIN esquecido?';

  @override
  String identificationHelloUser(String user) {
    return 'Olá, $user';
  }

  @override
  String get identificationErrorPinInvalid => 'O código PIN é inválido';

  @override
  String get biometric_auth => 'Autenticação biométrica';

  @override
  String get biometric_auth_required => 'Use sua impressão digital ou reconhecimento facial';

  @override
  String get biometric_use_pwd => 'Use um código secreto';

  @override
  String get biometric_use_fingerprint => 'Verificar identidade';

  @override
  String get biometric_echec_biometric => 'Falha biométrica. Tente novamente';

  @override
  String get biometric_error => 'Erro biométrico';

  @override
  String get biometric_success_authentification => 'Autenticação bem-sucedida';

  @override
  String get biometric_success_setting => 'Configurações';

  @override
  String get biometric_activation_setting => 'Ative a biometria em suas configurações';

  @override
  String get biometric_tmp_later => 'Biometria temporariamente desativada. Tente novamente mais tarde';

  @override
  String get upgrade_profile_tier1 => 'Nível Um';

  @override
  String get upgrade_profile_tier2 => 'Nível Dois';

  @override
  String get upgrade_profile_step1 => 'Etapa 1';

  @override
  String get upgrade_profile_step2 => 'Etapa 2';

  @override
  String get permissionNotificationTitle => 'Não perca nada';

  @override
  String get permissionNotificationSubTitle => 'Receba notificações sobre despesas, segurança e suas economias para ficar sempre atualizado';

  @override
  String get permissionNotificationEnableBtn => 'Ativar notificações';

  @override
  String get permissionNotificationNotNowBtn => 'Não agora';

  @override
  String get permissionContactTitle => 'Encontre seus amigos';

  @override
  String get permissionContactSubTitle1 => 'Você mantém o controle! ';

  @override
  String get permissionContactSubTitle2 => 'Nós nunca conservamos seus contatos telefônicos.';

  @override
  String get permissionContactEnableBtn => 'Acesso e atualização dos contatos';

  @override
  String get permissionContactNotNowBtn => 'Não agora';

  @override
  String get permissionErrorTitle => '😔 Oooops';

  @override
  String get permissionErrorDevice => 'Seu dispositivo não é suportado.';

  @override
  String get permissionErrorToken => 'Ocorreu um erro. Tente novamente';

  @override
  String get permissionErrorApi => 'Erro de comunicação - Verifique sua conexão com a internet ou tente novamente mais tarde!';

  @override
  String get securityLogoutTitle => 'Você tem certeza que deseja se desconectar?';

  @override
  String get securityLogoutSubTitle => 'Se você deseja continuar trabalhando, clique em « Cancelar » e você voltará para o seu estado atual. Se você realmente deseja se desconectar, clique em « Desconectar ».';

  @override
  String get securityLogoutBtnConfirmer => 'Desconectar';

  @override
  String get securityLogoutBtnAnnuler => 'Cancelar';

  @override
  String get aliasCreatePageTitle => 'Criar um alias';

  @override
  String get aliasCreatePageSubTitle => 'As pessoas podem enviar dinheiro para você a partir de seu alias';

  @override
  String get aliasCreateSHIDTitle => 'Escolher o endereço de pagamento';

  @override
  String get aliasCreateSHIDSubTitle => 'O endereço de pagamento é criado pelo SPI';

  @override
  String get aliasCreateMBNOTitle => 'Escolher o número de telefone';

  @override
  String get aliasCreateMBNOSubTitle => 'Será registrado como alias pelo SPI';

  @override
  String get aliaSuccessPageTitle => '🤩 Bravo';

  @override
  String get aliaSuccessPageSubTitle => 'Seu alias está criado';

  @override
  String get aliaSuccessPageDescription => 'Você pode compartilhá-lo com outras pessoas, o que permite que elas realizem transferências para seu conta. O alias simplifica o processo e permite que você realize transações com facilidade, preservando sua privacidade';

  @override
  String get aliaSuccessPageBtnText => 'Continue';

  @override
  String get aliaSuccessClaimPageTitle => 'Demanda de reivindicação enviada com sucesso';

  @override
  String get addPhoneNumberPageTitle => 'Número de telefone';

  @override
  String get addPhoneNumberPageSubTitle => 'Um código de verificação será enviado para este número';

  @override
  String get addPhoneNumberFormHint => 'Telefone móvel';

  @override
  String get addPhoneNumberFormErrorEmpty => 'Campo obrigatório';

  @override
  String get addPhoneNumberFormErrorInvalid => 'Número inválido';

  @override
  String get addPhoneNumberFormBtnContinuer => 'Continuar';

  @override
  String get verifyPhoneNumberPageTitle => 'Código de verificação';

  @override
  String verifyPhoneNumberPageSubTitle(String number) {
    return 'Digite o código enviado para $number';
  }

  @override
  String aliaMBNOResendMessage(String delay) {
    return 'Reenviar o código em $delay';
  }

  @override
  String get aliaMBNOResendMessageBtn => 'Reenviar o código';

  @override
  String get aliaMBNOInvalidOtpMessage => 'Código OTP inválido';

  @override
  String get aliasInvalidOtpResend => 'Reenviar';

  @override
  String get aliaErrorPageTitle => '😔 Oooops';

  @override
  String get aliaErrorPageSubTitle => 'Este alias está ocupado';

  @override
  String get aliaErrorPageDescription => 'O número de telefone já está registrado como alias em outro conta';

  @override
  String get aliaErrorPageReclamationBtnText => 'Revendiquer o alias';

  @override
  String get aliaErrorPageChoisisserBtnText => 'Escolha outro alias';

  @override
  String get aliaErrorClaimNotExistPageSubTitle => 'Revendicação não encontrada';

  @override
  String get aliaErrorClaimNotExistPageDescription => 'Esta reivindicação não está mais disponível. Ela terminou, foi fechada ou arquivada!';

  @override
  String get aliaErrorClaimLockedPageSubTitle => 'Uma reivindicação está em curso neste alias';

  @override
  String get aliaErrorClaimNotFoundPageSubTitle => 'O alias foi deletado pelo seu proprietário';

  @override
  String get aliasClaimDetailsHeadTitle => 'Revendicação de alias';

  @override
  String get aliasClaimDetailsHeadSubTitle => 'Número de telefone reclamado';

  @override
  String get aliasClaimDetailsBtnConfirmer => 'Aceitar';

  @override
  String get aliasClaimDetailsDateDemande => 'Data da solicitação';

  @override
  String get aliasClaimDetailsDateAcceptation => 'Data de aceitação';

  @override
  String get aliasClaimDetailsDateRefus => 'Data de rejeição';

  @override
  String aliasClaimDetailsAlert(String dateVerrouillage, String dateCloture) {
    return 'Se você não rejeitar esta solicitação com sucesso até a data de $dateVerrouillage, você não poderá mais fazer transações com este alias. Se à data de $dateCloture a solicitação ainda estiver pendente, o alias será deletado.';
  }

  @override
  String get aliasClaimAcceptDialogTitle => 'Você tem certeza que deseja aceitar a reivindicação?';

  @override
  String aliasClaimAcceptDialogMessage(String alias) {
    return 'Na aceitação, seu alias $alias será deletado, esta ação será irreversível. Você não poderá mais receber pagamentos com este alias. No entanto, você ainda poderá usar a conta de pagamento associada.';
  }

  @override
  String get aliasClaimAcceptSuccessTitle => 'Revendicação aceita';

  @override
  String aliasClaimAcceptSuccessDescription(String alias) {
    return 'Seu alias $alias foi deletado';
  }

  @override
  String get aliasClaimRejectSuccessTitle => 'Revendicação rejeitada';

  @override
  String aliasClaimRejectSuccessDescription(String alias) {
    return 'Seu alias $alias foi conservado';
  }

  @override
  String get aliasClaimDetailsRefusPageSubTitile => 'O rejeito só pode ser aceito se você provar que o número de telefone pertence a você inserindo o código OTP';

  @override
  String get aliasClaimConfirmError => 'A confirmação falhou, por favor, tente novamente';

  @override
  String get aliasClaimConfirmSuccessRejectTitle => 'Alias conservado';

  @override
  String get aliasClaimConfirmSuccessAcceptTitle => 'Alias deletado';

  @override
  String get aliasFormLabel => 'Alias';

  @override
  String get aliasFormHint => 'Endereço de pagamento ou número de telefone';

  @override
  String get aliasFormEmpty => 'Obrigatório';

  @override
  String get aliasFormInvalid => 'Deve ser um endereço de pagamento de 36 caracteres ou um número de telefone com o indicativo';

  @override
  String get aliasFormNotFound => 'O alias do beneficiário não existe em PI';

  @override
  String get contactActionsTitle => 'Contato';

  @override
  String get contactWithNoPhoneNumber => 'Este contato não possui um número de telefone';

  @override
  String get contactTransferTitle => 'Transfert por contato';

  @override
  String contactPhoneAsAccountAlias(String phoneNumber) {
    return '$phoneNumber é um alias de conta';
  }

  @override
  String contactPhoneAsAccountNumber(String phoneNumber) {
    return '$phoneNumber é um número de conta';
  }

  @override
  String get contactCreateTitle => 'Adicionar um contato';

  @override
  String get contactCreateSubtitle => 'Salvar um contato com seu alias';

  @override
  String get contactCreateNameLabel => 'Nome e sobrenome';

  @override
  String get contactCreateNameErrorEmpty => 'Nome obrigatório';

  @override
  String get contactBtnSave => 'Salvar e continuar';

  @override
  String get homePageToolbarTabbarCompte => 'Conta';

  @override
  String get homePageToolbarTabbarAbonnement => 'Assinaturas';

  @override
  String get homePageToolbarTabbarEconomie => 'Economia';

  @override
  String get homeSolde => 'Saldo';

  @override
  String get homeActionSend => 'Enviar';

  @override
  String get homeActionRequest => 'Receber';

  @override
  String get homeActionMore => 'Plus';

  @override
  String get homeTransactions => 'Transactions';

  @override
  String get homeTransactionsRecent => 'Transações recentes';

  @override
  String get transactionsNoRecent => 'Nenhuma transação recente';

  @override
  String get transactionsNoRecentSubtitle => 'Suas transações recentes aparecerão aqui';

  @override
  String get transactionsErrorLoading => 'Erro ao carregar as transações';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get homeTransactionsRecentsNombreTitle => 'Últimas transações';

  @override
  String get homeTransactionsRecentsNombreSubTitle => 'Escolha o número de transações que você deseja ver aparecer em seu widget';

  @override
  String get homeTransactionsRecentsNombreBtnSave => 'Salvar';

  @override
  String get homeActionMoreSheetProgrammerTitle => 'Programar um pagamento';

  @override
  String get homeActionMoreSheetProgrammerSubTitle => 'Criar um novo transferência';

  @override
  String get homeActionMoreSheetAbonnementTitle => 'Trouver un abonnement';

  @override
  String get homeActionMoreSheetAbonnementSubTitle => 'Convertir un paiement passé en abonnement';

  @override
  String get homeActionMoreSheetPartagerTitle => 'Compartilhar um pagamento';

  @override
  String get homeActionMoreSheetPartagerSubTitle => 'Dividir um pagamento entre amigos';

  @override
  String get homeActionMoreSheetTirelireTitle => 'Nova bolsa';

  @override
  String get homeActionMoreSheetTirelireSubTitle => 'Adicionar uma bolsa para um objetivo';

  @override
  String get homeActionMoreSheetBudgetTitle => 'Definir um orçamento';

  @override
  String get homeActionMoreSheetBudgetSubTitle => 'Criar um orçamento para suas despesas';

  @override
  String get homeActionMoreSheetWidgetTitle => 'Adicionar um widget';

  @override
  String get homeActionMoreSheetAWidgetSubTitle => 'Gerenciar os widgets do ecrã principal';

  @override
  String get transactionsSeeAll => 'Todas as transações';

  @override
  String get transactionsSendInputHint => 'Nome, Alias';

  @override
  String get transactionsSendOptionAliasTitle => 'Por alias';

  @override
  String get transactionsSendOptionAliasSubtitle => 'Alias do beneficiário';

  @override
  String get transactionsSendOptionIbanTitle => 'Por IBAN';

  @override
  String get transactionsSendOptionIbanSubtitle => 'Número da conta bancária';

  @override
  String get transactionsSendOptionOthrTitle => 'Por outro conta';

  @override
  String get transactionsSendOptionOthrSubtitle => 'Número de conta SFD / EME';

  @override
  String get transactionsSendOptionNewContactTitle => 'Novo contato';

  @override
  String get transactionsSendOptionNewContactSubtitle => 'Adicionar um contato com seu alias';

  @override
  String get transactionsSendRecentItemYouSend => 'Você enviou ';

  @override
  String get transactionsSendRecentItemYouReceive => 'Você recebeu ';

  @override
  String get transactionsSendTitleTransfert => 'Transferência';

  @override
  String get transactionsSendTitleRecents => 'Transferências recentes';

  @override
  String get transactionsSendTitleContacts => 'Contatos';

  @override
  String get transactionsSendTitleRequest2Pay => 'Demanda de pagamento';

  @override
  String get transactionsSendTitleRequest2PayRecents => 'Demanda recentes';

  @override
  String get transactionsSendScheduleTitle => 'Quem pagar';

  @override
  String get transactionsSendFormAliasTitle => 'Transferência por Alias';

  @override
  String get transactionsSendFormAliasSubtitle => 'Cole ou digite o alias';

  @override
  String get transactionsSendFormOthrTitle => 'Transferência por outro conta';

  @override
  String get transactionsSendFormOthrSubtitle => 'Número de conta de um SFD ou de um EME';

  @override
  String get transactionsSendFormIbanTitle => 'Transferência por IBAN';

  @override
  String get transactionsSendFormIbanSubtitle => 'Cole ou digite o IBAN';

  @override
  String get transactionsSendFormQrCodeTitleTransfer => 'Transferência por QR Code';

  @override
  String get transactionsSendFormQrCodeTitlePayment => 'Pagamento por QR Code';

  @override
  String get transactionsSendFormQrCodeSubtitle => 'Digite o montante';

  @override
  String get transactionsSendSuccessBtnVoir => 'Ver o pagamento';

  @override
  String get transactionsSendSuccessBtnReessayer => 'Tentar novamente';

  @override
  String get transactionsSendErrorTitle => '😔 Oooops';

  @override
  String get transactionsSendErrorDescription => 'A transação falhou.';

  @override
  String get transactionsSendErrorBtn => 'Continuar';

  @override
  String get transactionFormAmountHint => 'Montante';

  @override
  String get transactionFormAmountEmpty => 'Obrigatório';

  @override
  String get transactionFormAmountInvalid => 'Saldo insuficiente';

  @override
  String get transactionFormAmountLow => 'Montante mínimo 5 frcs';

  @override
  String get transactionFormMotifHint => 'Adicionar uma nota';

  @override
  String get transactionFormMotifLabel => 'Nota';

  @override
  String get transactionFormMotifInvalid => 'Não mais de 104 caracteres';

  @override
  String get transactionFormFactureLabel => 'Fatura';

  @override
  String get transactionFormIbanLabel => 'IBAN';

  @override
  String get transactionFormIbanHint => 'IBAN do beneficiário';

  @override
  String get transactionFormIbanEmpty => 'Obrigatório';

  @override
  String get transactionFormIbanInvalid => 'Formato do IBAN inválido';

  @override
  String get transactionFormIbanPaysLabel => 'País do banco';

  @override
  String get transactionFormIbanNomLabel => 'Nome do banco';

  @override
  String get transactionFormOthrLabel => 'Número de conta';

  @override
  String get transactionFormOthrHint => 'Número de conta do beneficiário';

  @override
  String get transactionFormOthrEmpty => 'Obrigatório';

  @override
  String get transactionFormOthrPaysLabel => 'País da instituição financeira';

  @override
  String get transactionFormOthrNomLabel => 'Nome da instituição financeira';

  @override
  String get transactionFormContinueBtn => 'Continuar';

  @override
  String get transactionFormSaveContactBtn => 'Salvar e fazer um transferência';

  @override
  String get transactionFormVerificationTitle => 'Verificação';

  @override
  String get transactionFormVerificationSubtitle => 'Você realmente deseja fazer um transferência para este beneficiário?';

  @override
  String get transactionFormVerificationTypeLabel => 'Tipo';

  @override
  String get transactionFormVerificationTypeIBAN => 'Transferência por IBAN';

  @override
  String get transactionFormVerificationTypeOTHR => 'Transferência por outro conta';

  @override
  String get transactionFormVerificationClientName => 'Nome do cliente';

  @override
  String get transactionFormVerificationBtnConfirm => 'Confirmar';

  @override
  String get transactionFormVerificationBtnReject => 'Cancelar';

  @override
  String get transactionFormScheduleTitle => 'Programar';

  @override
  String get transactionFormScheduleSubtitle => 'Seu pagamento será feito na data escolhida';

  @override
  String get transactionFormScheduleDateLabel => 'Data';

  @override
  String get transactionFormScheduleDateRangeLabel => 'Data de início - Data de fim';

  @override
  String get transactionFormScheduleDateSelectTitle => 'Selecionar uma data';

  @override
  String get transactionFormScheduleDateRangeSelectTitle => 'Selecionar uma faixa de datas';

  @override
  String get transactionFormScheduleFrequenceLabel => 'Frequência';

  @override
  String get transactionFormScheduleFrequenceUnefois => 'Uma vez';

  @override
  String get transactionFormScheduleFrequenceQuotidienne => 'Diária';

  @override
  String get transactionFormScheduleFrequenceHebdomadaire => 'Semanal';

  @override
  String get transactionFormScheduleFrequenceMensuelle => 'Mensal';

  @override
  String get transactionFormScheduleFrequenceAnnuelle => 'Anual';

  @override
  String get transactionFormScheduleFrequenceSurMesure => 'Sob medida';

  @override
  String get transactionFormSchedulePeriodiciteLabel => 'Périodicité';

  @override
  String transactionFormScheduleFrequenceSelected(String periodicite, String frequence) {
    return 'Todos os $periodicite $frequence';
  }

  @override
  String transactionFormScheduleDateRange(String start, String end) {
    return 'de $start a $end';
  }

  @override
  String transactionFormScheduleDateSelected(String start) {
    return 'A partir de $start';
  }

  @override
  String transactionFormScheduleSuccessMessage(String montant, String payee) {
    return 'Você programou $montant FCFA para $payee';
  }

  @override
  String get transactionFormScheduleSuccessBtn => 'Ver o abonnamento';

  @override
  String transactionsSendSuccessBtnTitle(String payee) {
    return 'Você enviou dinheiro para $payee';
  }

  @override
  String get subscriptionEmptyTitle => 'Transações a vir';

  @override
  String get subscriptionEmptySubTitle => 'Gerencie seus assinaturas e pagamentos programados em um só lugar';

  @override
  String get subscriptionListOnceTitle => 'Pagamentos programados';

  @override
  String get subscriptionEmptyBtnCreate => 'Novo';

  @override
  String get subscriptionListFrequenceTitle => 'Assinaturas';

  @override
  String get subscriptionMenuScheduleTitle => 'Programar um pagamento';

  @override
  String get subscriptionMenuScheduleSubtitle => 'Executar um pagamento em uma data específica';

  @override
  String get subscriptionMenuSubscribeTitle => 'Criar um assinatura';

  @override
  String get subscriptionMenuSubscribeSubtitle => 'Converter um pagamento em uma assinatura';

  @override
  String get subscriptionMenuSubscribeSubtitle2 => 'Procure em suas transações e selecione um pagamento recorrente';

  @override
  String get subscriptionDateScheduledForTitle => 'Programado para';

  @override
  String subscriptionDateScheduledFor(String date) {
    return 'Programado para o $date';
  }

  @override
  String get subscriptionDateNextPaymentTitle => 'Próximo pagamento';

  @override
  String subscriptionDateNextPayment(String date) {
    return 'Próximo pagamento em $date';
  }

  @override
  String subscriptionDateEndsSince(String date) {
    return 'Terminado desde o $date';
  }

  @override
  String get subscriptionDateToday => 'Pagamento para hoje';

  @override
  String get subscriptionDisabled => 'Assinatura desativada';

  @override
  String get subscriptionPaymentTo => 'Pagamento para';

  @override
  String get subscriptionStartDate => 'Data de início';

  @override
  String get subscriptionEditNoteBtn => 'Modificar a nota';

  @override
  String transactionsRtpSuccessBtnTitle(String payee) {
    return 'Você enviou uma solicitação de pagamento para $payee';
  }

  @override
  String get transactionsRtpSuccessBtnVoir => 'Ver a solicitação';

  @override
  String transactionRtpDetailsTitleInitiee(String payeur) {
    return 'Você solicitou a $payeur';
  }

  @override
  String transactionRtpDetailsTitleRecue(String paye) {
    return 'Você deve a $paye';
  }

  @override
  String get transactionRtpDetailsEcheanceDate => 'Data de vencimento';

  @override
  String get transactionRtpDetailsRemiseTitle => 'Pagamento imediato';

  @override
  String get transactionRtpDetailsRemiseLabel => 'Remessa';

  @override
  String transactionRtpDetailsRemiseHint(String dateReponse) {
    return 'válido até o $dateReponse';
  }

  @override
  String get transactionRtpDetailsSplitPaymentTitle => 'Pagamento compartilhado';

  @override
  String get transactionRtpDetailsSplitPaymentTo => 'Pagado para';

  @override
  String get transactionRtpDetailsPICOTitle => 'Retirada com compra PICO';

  @override
  String get transactionRtpDetailsPICASHTitle => 'Retirada PICASH';

  @override
  String get transactionRtpDetailsAmtAchatTitle => 'Compra';

  @override
  String get transactionRtpDetailsAmtRetraitTitle => 'Retirada';

  @override
  String get transactionRtpDetailsAmtFraisTitle => 'Taxas';

  @override
  String get transactionRtpDetailsDiffereTitle => 'Débito diferido';

  @override
  String get transactionRtpDetailsDiffereSubtitle => 'Compre agora, pague mais tarde!';

  @override
  String get transactionRtpDetailsDiffereDescription => 'Seu saldo será debitado no final do mês';

  @override
  String transactionRtpDetailsDifferePayFrequence(int occurence, String frequence) {
    return 'Pagar em $occurence $frequence';
  }

  @override
  String transactionRtpDetailsDifferePayAmt(String montant, String frequence) {
    return '$montant por $frequence';
  }

  @override
  String transactionRtpRejectTitle(String paye) {
    return 'Rejeitar a solicitação de $paye';
  }

  @override
  String transactionRtpRejectSubtitle(String montant, String paye) {
    return '$montant para $paye';
  }

  @override
  String get transactionRtpRejectRsnDemandeur => 'Demandante desconhecida';

  @override
  String get transactionRtpRejectRsnMontant => 'Montante incorreto';

  @override
  String get transactionRtpRejectRsnRemittance => 'Fatura incorreta';

  @override
  String get transactionRtpRejectMessage => 'A solicitação de pagamento foi rejeitada com sucesso';

  @override
  String get transactionDetailsFrequenceMois => 'meses';

  @override
  String get transactionDetailsFrequenceSemaine => 'semanas';

  @override
  String get transactionDetailsFrequenceJour => 'dias';

  @override
  String get transactionDetailsRetourner => 'Retornar';

  @override
  String get transactionDetailsAnnuler => 'Cancelar';

  @override
  String get transactionDetailsRecevoir => 'Receber';

  @override
  String get transactionDetailsPartager => 'Compartilhar';

  @override
  String get transactionDetailsPlanifier => 'Programar';

  @override
  String get transactionDetailsMotifCredit => 'Recebido sem nota';

  @override
  String get transactionDetailsMotifDebit => 'Enviado sem nota';

  @override
  String get transactionDetailsReference => 'Referência';

  @override
  String get transactionDetailsPays => 'País';

  @override
  String get transactionDetailsPayeLabel => 'Pagado para';

  @override
  String get transactionDetailsPayeurLabel => 'Recebido de';

  @override
  String get transactionDetailsDateLabel => 'Recebido em';

  @override
  String get transactionDetailsTelecharger => 'Baixar';

  @override
  String get transactionDetailsRecuPaiement => 'Recebido do pagamento';

  @override
  String get transactionDetailsAlias => 'Alias';

  @override
  String get transactionDetailsCategorie => 'Categoria';

  @override
  String get transactionDetailsTicket => 'Ticket de caixa';

  @override
  String get transactionDetailsAnalytique => 'Excluir do analítico';

  @override
  String get transactionDetailsQuestion => 'Selecione uma pergunta';

  @override
  String get transactionDetailsTeleverser => 'Enviar';

  @override
  String get transactionDetailsRecuPaiementPDF => 'Recebido do pagamento';

  @override
  String get transactionDetailsRecuPaiementPDFSousTitre => 'Você pode compartilhar ou baixar o PDF';

  @override
  String get transactionDetailsTicketCaisse => 'Recebido pago';

  @override
  String get transactionDetailsTicketCaisseSubtitle => 'Você pode compartilhar o recibo';

  @override
  String get transactionDetailsCompte => 'Conta';

  @override
  String get transactionDetailsInstitution => 'Instituição';

  @override
  String get transactionDetailsReturnTitle => 'Êtes-vous sûr de vouloir retourner les fonds ?';

  @override
  String get transactionDetailsReturnSuccessMessage => 'Você retornou os fundos com sucesso';

  @override
  String get transactionDetailsRetourDateLabel => 'Retornado em';

  @override
  String get transactionDetailsCancelTitle => 'Demanda de cancelamento';

  @override
  String get transactionDetailsCancelSubTitle => 'Qual é a razão da demanda?';

  @override
  String get transactionDetailsCancelRsnDestinataire => 'Erro no destinatário';

  @override
  String get transactionDetailsCancelRsnMontant => 'Erro no montante';

  @override
  String get transactionDetailsCancelRsnService => 'Serviço não fornecido';

  @override
  String get transactionDetailsCancelRsnFraud => 'Tentativa de fraude';

  @override
  String get transactionDetailsCancelRsnDuplicate => 'Já pago';

  @override
  String get transactionDetailsCancelBtnSend => 'Solicitar o cancelamento';

  @override
  String get transactionDetailsCancelSuccessMessage => 'Demanda de cancelamento enviada';

  @override
  String get transactionDetailsCancelSuccessDescription => 'A demanda está aguardando o tratamento. \n Você será notificado assim que o beneficiário responder.';

  @override
  String get transactionDetailsCancelDemandeLabel => 'Solicitado em';

  @override
  String get transactionDetailsCancelDateLabel => 'Demanda de cancelamento';

  @override
  String transactionDetailsCancelHeadSubtitle(String montant) {
    return '$montant recebido';
  }

  @override
  String get transactionDetailsCancelReasonLabel => 'Razão';

  @override
  String get transactionDetailsCancelRejectMessage => 'A demanda de cancelamento foi rejeitada com sucesso';

  @override
  String get transactionDetailsRecuTitlePage => 'Payment completed';

  @override
  String get transactionDetailsRecuSubTitlePage => 'Pode partilhar ou descarregar o PDF';

  @override
  String get transactionDetailsRecuTitle => 'Recebido do pagamento';

  @override
  String get transactionDetailsRecuSubTitle => 'Você pode compartilhar ou baixar o PDF';

  @override
  String get transactionDetailsRecuInfoIdentifiant => 'Identificador';

  @override
  String get transactionDetailsRecuInfoReference => 'Referência';

  @override
  String get transactionDetailsRecuInfoFrais => 'Taxas';

  @override
  String get transactionDetailsRecuInfoFraisDefault => 'Gratuito';

  @override
  String get transactionDetailsRecuInfoPayeLabel => 'Enviado para';

  @override
  String get transactionDetailsRecuInfoPayeurLabel => 'Recebido de';

  @override
  String get transactionDetailsRecuInfoClientAlias => 'Alias';

  @override
  String get transactionDetailsRecuInfoPayeurID => 'ID do remetente';

  @override
  String get transactionDetailsRecuInfoPayeID => 'ID do beneficiário';

  @override
  String get transactionDetailsRecuInfoClientCompte => 'Número de conta';

  @override
  String get transactionDetailsRecuInfoClientInstitution => 'Instituição';

  @override
  String get transactionDetailsRecuInfoDateReception => 'Data de recebimento';

  @override
  String get transactionDetailsRecuInfoDateEnvoi => 'Data de envio';

  @override
  String get transactionDetailsRecuInfoMontant => 'Montante';

  @override
  String get transactionDetailsTicketSaveTitle => 'Salvar o recibo da transação';

  @override
  String get transactionDetailsTicketSaveGallery => 'Abrir a galeria';

  @override
  String get transactionSplitTitle => 'Compartilhar com';

  @override
  String get transactionSplitRepartitionTitle => 'Compartilhar o pagamento';

  @override
  String get transactionSplitRepartitionSubtitle1 => 'Fatura selecionada';

  @override
  String transactionSplitRepartitionSubtitle2(int nombre) {
    return 'Compartilhado - $nombre';
  }

  @override
  String get transactionSplitRepartitionParMontant => 'Por montante';

  @override
  String get transactionSplitRepartitionSelf => 'Eu';

  @override
  String get transactionSplitRepartitionPartRegle => 'Parte paga';

  @override
  String get transactionSplitRepartitionPartDoit => 'Você deve';

  @override
  String get transactionSplitRepartitionSuccessMessage => 'Solicitações de pagamento enviadas';

  @override
  String get transactionErrorSoldeInsuffisant => 'Saldo insuficiente';

  @override
  String get transactionErrorDejaRetourne => 'Transação já retornada';

  @override
  String get transactionErrorDelaiDepasse => 'A data limite foi ultrapassada';

  @override
  String get transactionErrorDestinataireIndisponible => 'Instituição do beneficiário momentaneamente indisponível';

  @override
  String get transactionErrorUnknow => 'Sua solicitação não pode ser processada no momento. Por favor, tente novamente mais tarde';

  @override
  String get transactionSearchTitle => 'Transações';

  @override
  String get transactionSearchEmptySubtitle => 'Nenhuma transação corresponde à sua pesquisa';

  @override
  String get transactionSearchEmptyTitle => 'Nenhum resultado';

  @override
  String get loadMore => 'Carregar mais';

  @override
  String get transactionSearchInputSearchHint => 'Pesquisar';

  @override
  String get transactionSearchInputFilterTitle => 'Filtrar';

  @override
  String get transactionSearchInputFilterDateTitle => 'Plage de datas';

  @override
  String get transactionSearchInputFilterDateSubTitle => 'Selecione a faixa';

  @override
  String transactionSearchInputFilterDateRange(String debut, String fin) {
    return 'Datas de $debut - à $fin';
  }

  @override
  String get transactionSearchInputFilterDateSelectTitle => 'Selecionar uma faixa de datas';

  @override
  String get transactionSearchInputFilterCategoriesTitle => 'Categorias';

  @override
  String get transactionSearchInputFilterCategoriesSensRecus => 'Recebidos';

  @override
  String get transactionSearchInputFilterCategoriesSensPayes => 'Pagados';

  @override
  String get transactionSearchInputFilterBtnAppliquer => 'Aplicar';

  @override
  String get qrcodePageBtnScan => 'Scan';

  @override
  String get qrcodePageBtnMonCode => 'Meu Código';

  @override
  String get qrcodePagePartageTitle => 'Compartilhar';

  @override
  String get qrcodePagePartageQrCodeTitle => 'Seu QR Code';

  @override
  String get qrcodePagePartageQrCodeSubTitle => 'Compartilhar a imagem';

  @override
  String get qrcodePagePartageAliasTitle => 'Seu alias';

  @override
  String get qrcodePagePartageAliasSubTitle => 'Copie o alias no presse-papiers';

  @override
  String get qrcodeScanPageMessage => 'Ponha sua câmera no QR code.\nO scan é feito automaticamente';

  @override
  String get qrcodeEncodeErrorMsg => 'Erro ao exibir seu QR Code!';

  @override
  String get qrcodeDecodeErrorNotQrImage => 'Imagem do QR Code inválida';

  @override
  String get qrcodeDecodeErrorInvalideAlias => 'Alias contido no QR Code é inválido';

  @override
  String get qrcodeDecodeErrorInvalideFormat => 'Formato do QR Code inválido';

  @override
  String get popupSelectDateBtnValider => 'Validar';

  @override
  String get profilePageBtnInviter => 'Invite seus amigos';

  @override
  String get profilePageMenuCompteTitle => 'Conta';

  @override
  String get profilePageMenuSecurityTitle => 'Segurança & Confidencialidade';

  @override
  String get profilePageMenuParametreTitle => 'Configurações da aplicação';

  @override
  String get profilePageMenuHelpTitle => 'Centro de Ajuda';

  @override
  String get profilePageMenuAproposTitle => 'Sobre nós';

  @override
  String get profilePageBtnDeconnexion => 'Desconectar';

  @override
  String get profilePageAppVersion => 'Versão da aplicação';

  @override
  String get profileSecuritePageTitle => 'Segurança & Confidencialidade';

  @override
  String get profileSecuriteMenuSecuriteTitle => 'Segurança';

  @override
  String get profileSecuriteMenuItemPinTitle => 'Modificar o código PIN';

  @override
  String get profileSecuriteMenuItemTrustedTitle => 'Pessoas de confiança';

  @override
  String get profileSecuriteMenuItemBlacklistTitle => 'Lista negra';

  @override
  String get profileSecuriteMenuItemAppareilsTitle => 'Aparelhos';

  @override
  String get profileSecuriteMenuItemBiometryTitle => 'Autorizar biometria';

  @override
  String get profileSecuriteMenuItemMontantTitle => 'Ocultar os montantes';

  @override
  String get profileSecuriteMenuItemMontantSubTitle => 'Bascule o ecrã do seu dispositivo para baixo para ocultar e exibir rapidamente os montantes';

  @override
  String get profileSecuriteMenuConfidentialiteTitle => 'Confidencialidade';

  @override
  String get profileSecuriteMenuItemShakeToPayTitle => 'Rendez-me descobridor';

  @override
  String get profileSecuriteMenuItemShakeToPaySubTitle => 'Quando eu sacudir o telefone';

  @override
  String get profileSecuriteMontantPopupTitle => 'Exibição dos montantes';

  @override
  String get profileSecuriteMontantPopupSubTitle => 'Bascule o ecrã do seu dispositivo para baixo para ocultar e exibir rapidamente os montantes.';

  @override
  String get comptePageTitle => 'Conta';

  @override
  String get comptePageListeInfosTitle => 'Informações pessoais';

  @override
  String get comptePageListeDetailsTitle => 'Detalhes da conta';

  @override
  String get comptePageBtnFermer => 'Fechar a conta';

  @override
  String get comptePersonnelPageTitle => 'Informações pessoais';

  @override
  String get comptePersonnelPageListeNomTitle => 'Nome e Sobrenome';

  @override
  String get comptePersonnelPageListeTelephoneTitle => 'Número de telefone';

  @override
  String get comptePersonnelPageListePaysTitle => 'País de residência';

  @override
  String get comptePersonnelPageListeAdresseTitle => 'Endereço';

  @override
  String get compteDetailsPageTitle => 'Detalhes da conta';

  @override
  String get compteDetailsPageListeTypeComTitle => 'Tipo de conta';

  @override
  String get compteDetailsPageListeNumCompTitle => 'Número de conta';

  @override
  String get compteDetailsPageListeAliasTitle => 'Alias';

  @override
  String get compteDetailsPageBtnSupprimer => 'Suprimir o meu alias';

  @override
  String get compteDetailsPagePopupDeleteAliasTitle => 'Você tem certeza que deseja suprimir o seu alias?';

  @override
  String get compteDetailsPagePopupDeleteAliasSubTitle => 'Se você confirmar a supressão do seu alias, esta ação será irreversível. Seu alias será completamente removido do nosso sistema e os outros usuários não poderão mais realizar pagamentos em seu nome ou encontrá-lo usando este alias. Por favor, note que você também perderá todas as informações associadas ao alias, incluindo o histórico de pagamentos e os registros de informações relacionadas.';

  @override
  String get compteDetailsPagePopupDeleteAliasBtnConfirmer => 'Suprimir o meu alias';

  @override
  String get compteDetailsPagePopupDeleteAliasBtnAnnuler => 'Cancelar';

  @override
  String get compteDetailsPagePopupDeleteAliasErrorMsg => 'A supressão do seu alias falhou, por favor, tente novamente mais tarde';

  @override
  String get appSettingPageTitle => 'Configurações da aplicação';

  @override
  String get appSettingPageMenuLanguageTitle => 'Idioma';

  @override
  String get appSettingPageMenuLanguageFr => 'Português';

  @override
  String get appSettingPageMenuLanguageEn => 'Inglês';

  @override
  String get appSettingPageMenuLanguagePt => 'Português';

  @override
  String get appSettingPageMenuLanguageSelectTitle => 'Escolha o idioma para a aplicação';

  @override
  String get appSettingPageMenuThemeTitle => 'Tema';

  @override
  String get appSettingPageMenuThemeDark => 'Escuro';

  @override
  String get appSettingPageMenuThemeLight => 'Claro';

  @override
  String get appSettingPageMenuThemeYellow => 'Amarelo';

  @override
  String get appSettingPageMenuThemeGreen => 'Verde';

  @override
  String get appSettingPageMenuThemeBlue => 'Azul';

  @override
  String get appSettingPageMenuThemeDefault => 'Sistema';

  @override
  String get appSettingPageMenuThemePageTitle => 'Aparência';

  @override
  String get appSettingPageMenuQrCodeTitle => 'Meu QR Code por defeito';

  @override
  String get appSettingPageMenuQrCodeSelectTitle => 'Ativar para exibir o meu QR Code por defeito';

  @override
  String get appSettingPageMenuQrCodeDeselectTitle => 'Desativar para exibir a câmera por defeito';

  @override
  String get appSettingPageMenuNotificationTitle => 'Notificações na aplicação';

  @override
  String get appSettingPageMenuNotificationStyleTitle => 'Estilo de alerta';

  @override
  String get appSettingPageMenuNotificationStyleSnackBar => 'Banners';

  @override
  String get appSettingPageMenuNotificationStyleDialog => 'Alertas';

  @override
  String get appSettingPageMenuNotificationStyleDialogDesc => 'Os alertas requerem uma ação antes de continuar. Os banners aparecem no topo da tela e desaparecem automaticamente';

  @override
  String get appSettingPageMenuNotificationStyleNone => 'Nenhum';

  @override
  String get appSettingPageMenuNotificationSonTitle => 'Som';

  @override
  String get appSettingPageMenuNotificationSonPageTitle => 'Notificação Sonora';

  @override
  String get appSettingPageMenuNotificationSonDefault => 'Por defeito';

  @override
  String get appSettingPageMenuNotificationVibrTitle => 'Vibração';

  @override
  String get appSettingPageMenuNotificationVibrSubtitle => 'Vibrações para notificação';

  @override
  String get categorieDefaultTitle => 'Categorias por defeito';

  @override
  String get categorieCustomTitle => 'Categorias personalizadas';

  @override
  String get categorieCustomAdd => 'Adicionar uma categoria';

  @override
  String get categorieCustomEdit => 'Modificar';

  @override
  String get categorieFormNameLabel => 'Nome da categoria';

  @override
  String get categorieFormCreateBtn => 'Criar';

  @override
  String get categorieFormNameInvalid => 'O nome não deve ter mais de 25 caracteres';

  @override
  String get categorieFormNameAlready => 'Esta categoria já existe';

  @override
  String get categorieEditBtn => 'Modificar';

  @override
  String get categorieFormSaveBtn => 'Salvar';

  @override
  String get categorieFormIconSheetTitle => 'Definir a imagem de capa';

  @override
  String get categorieFormIconSheetEmojiTitle => 'Utilizar os Emojis';

  @override
  String get categorieFormIconSheetGalleryTitle => 'Selecionar na galeria';

  @override
  String get categorieFormIconSheetPhotoTitle => 'Tirar uma foto';

  @override
  String get notificationPageTitle => 'Notificações';

  @override
  String get notificationPageListeEmptyTitle => 'Você está ciente de tudo';

  @override
  String get notificationPageListeEmptySubTitle => 'Revenez plus tard pour obtenir des informations et des recommandations afin de maintenir votre compte à jour';

  @override
  String get notificationPageClaimTitle => 'Revendação de alias';

  @override
  String notificationPageClaimSubtitle(String alias) {
    return 'Você recebeu uma revendação sobre o seu alias $alias';
  }

  @override
  String get notificationPageAnnulationRequestTitle => 'Cancelamento';

  @override
  String notificationPageAnnulationRequestSubtitle(String payeur) {
    return 'Solicitado por $payeur';
  }

  @override
  String notificationPageRtpInitieeSubtitle(String payeur) {
    return 'Solicitado a $payeur';
  }

  @override
  String notificationPageRtpRecueSubtitle(String payeur) {
    return 'Solicitado por $payeur';
  }

  @override
  String get ignore => 'Ignorar';

  @override
  String get externalCustomer => 'Cliente externo';

  @override
  String get coming_soon => 'Disponível em breve ...';

  @override
  String get alias_copied => 'Alias copiado !';

  @override
  String get bottom_bar_home => 'Home';

  @override
  String get bottom_bar_transaction => 'Transactions';
}
