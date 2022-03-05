import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nav_router/nav_router.dart';
import 'package:pintupay/core/network/model/post_body.dart';
import 'package:pintupay/core/pintupay/pintupay_crypt.dart';
import 'package:pintupay/core/util/util.dart';
import 'package:pintupay/ui/register/view/account_verification.dart';
import 'package:pintupay/ui/register/view/register_form.dart';
import 'package:pintupay/ui/verification/model/check_phone_number.dart';
import 'package:pintupay/ui/verification/model/otp_register_model.dart';
import 'package:pintupay/ui/verification/provider/verification_provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

part 'check_phone_number_state.dart';

class CheckPhoneNumberCubit extends Cubit<CheckPhoneNumberState> {
  CheckPhoneNumberCubit() : super(CheckPhoneNumberInitial());

  Future onCheckPhoneNumber(String phoneNumber) async {
    var phone = PintuPayCrypt().encrypt(
      jsonEncode(CheckPhoneNumberModel(userOtp: UserOtp(phoneNumber: phoneNumber))),
      await PintuPayCrypt().getPassKeyPref()
    );
    var result = await VerificationProvider.checkPhoneNumber(PostBody(phone).toJson());
    final signCode = await SmsAutoFill().getAppSignature;
    CoreFunction.logPrint('print signcode: ', signCode);
    if(result.id != null){
      routePush(
        AccountVerification(responseCheckPhoneNumber: result),
        RouterType.material
      );
    }
  }

  onCheckOTP(OtpRegisterModel otpRegisterModel) async {
    var otp = PintuPayCrypt().encrypt(jsonEncode(otpRegisterModel), await PintuPayCrypt().getPassKeyPref());
    var result = await VerificationProvider.otpRegist(PostBody(otp).toJson());
    CoreFunction.logPrint("result", result.toJson());
    routePush(Register(responseCheckPhoneNumber: result), RouterType.material);
  }
}
