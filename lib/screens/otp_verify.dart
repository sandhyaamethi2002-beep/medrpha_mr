import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppManager/ViewModel/LoginVM/login_otp_vm.dart';
import '../AppManager/ViewModel/LoginVM/verify_login_otp_vm.dart';


class OtpVerification extends StatefulWidget {
  final String mobileNumber;
  final String otp;

  const OtpVerification({
    Key? key,
    required this.mobileNumber,
    required this.otp,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {

  final LoginOtpVM loginOtpVM = Get.find();
  final VerifyLoginOtpVM verifyLoginOtpVM = Get.find();

  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();

  final otp1Focus = FocusNode();
  final otp2Focus = FocusNode();
  final otp3Focus = FocusNode();
  final otp4Focus = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your OTP is ${widget.otp}"),
        ),
      );
    });
  }

  @override
  void dispose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();
    super.dispose();
  }

  void resendOtp() async {
    bool success = await loginOtpVM.sendOtp(widget.mobileNumber);

    if (success) {
      String? newOtp = loginOtpVM.otpResponse.value?.otp;

      if (newOtp != null && newOtp.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Your OTP is $newOtp"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to resend OTP"),
        ),
      );
    }
  }

  Widget otpBox({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return SizedBox(
      width: 50,
      height: 55,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color(0xFF1A5ED3),
                width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (focusNode == otp1Focus) {
              FocusScope.of(context)
                  .requestFocus(otp2Focus);
            } else if (focusNode == otp2Focus) {
              FocusScope.of(context)
                  .requestFocus(otp3Focus);
            } else if (focusNode == otp3Focus) {
              FocusScope.of(context)
                  .requestFocus(otp4Focus);
            } else {
              focusNode.unfocus();
            }
          }

          if (value.isEmpty) {
            if (focusNode == otp2Focus) {
              FocusScope.of(context)
                  .requestFocus(otp1Focus);
            } else if (focusNode == otp3Focus) {
              FocusScope.of(context)
                  .requestFocus(otp2Focus);
            } else if (focusNode == otp4Focus) {
              FocusScope.of(context)
                  .requestFocus(otp3Focus);
            }
          }
        },
      ),
    );
  }

  void verifyOtp() async {

    String enteredOtp = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;

    if (enteredOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text("Please enter complete OTP")),
      );
      return;
    }

    bool success =
    await verifyLoginOtpVM.verifyOtp(
      widget.mobileNumber,
      enteredOtp,
    );

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            verifyLoginOtpVM
                .verifyResponse
                .value
                ?.message ??
                "OTP Verified Successfully",
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
            content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 100),

            Image.asset(
              'assets/images/img.png',
              height: 120,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            const Text(
              "Mobile OTP Verification",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Please enter the 4-digit code sent to\n+91 ${widget.mobileNumber}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                otpBox(
                    controller:
                    otp1Controller,
                    focusNode: otp1Focus),
                otpBox(
                    controller:
                    otp2Controller,
                    focusNode: otp2Focus),
                otpBox(
                    controller:
                    otp3Controller,
                    focusNode: otp3Focus),
                otpBox(
                    controller:
                    otp4Controller,
                    focusNode: otp4Focus),
              ],
            ),

            const SizedBox(height: 30),

            RichText(
              text: TextSpan(
                text:
                "Didn't receive the code? ",
                style: const TextStyle(
                    color:
                    Colors.black54),
                children: [
                  TextSpan(
                    text: "Resend",
                    style:
                    const TextStyle(
                        color:
                        Colors.red,
                        fontWeight:
                        FontWeight
                            .bold),
                    recognizer:
                    TapGestureRecognizer()
                      ..onTap =
                          resendOtp,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// 🔥 BUTTON WITH LOADING
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                verifyLoginOtpVM
                    .isLoading
                    .value
                    ? null
                    : verifyOtp,
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                      0xFF1A5ED3),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        12),
                  ),
                ),
                child:
                verifyLoginOtpVM
                    .isLoading
                    .value
                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )
                    : const Text(
                  "Verified",
                  style: TextStyle(
                      fontSize:
                      18,
                      color: Colors
                          .white,
                      fontWeight:
                      FontWeight
                          .bold),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}