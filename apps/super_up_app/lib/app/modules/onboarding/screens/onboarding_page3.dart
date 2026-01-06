import 'package:flutter/material.dart';
import 'package:super_up/app/modules/auth/phone_login/phone_authentication.dart';
import 'package:super_up_core/super_up_core.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/onboarding3.png",
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.68,
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 8, bottom: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.white,
                  margin: EdgeInsets.all(0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text(
                            "Now Discute Anything",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Create Conferences, Invite People, Discuss Any Topic Together",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: MediaQuery.sizeOf(context).width * 0.45,
                child: InkWell(
                  onTap: () {
                    context.toPage(
                      const PhoneAuthentication(),
                      withAnimation: true,
                      removeAll: true,
                    );
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: AppTheme.primaryGreen,
                    child: Center(
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
