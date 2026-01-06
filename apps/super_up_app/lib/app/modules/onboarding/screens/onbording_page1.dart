import 'package:flutter/material.dart';
import 'package:super_up/app/modules/onboarding/screens/onboarding_page2.dart';
import 'package:super_up_core/super_up_core.dart';

class OnbordingPage1 extends StatelessWidget {
  const OnbordingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset(
            "assets/onboarding2.png",
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.68,
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
                            "See Each Other Any Time",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Get To See Each Other Anywhere, Anytimes, Enjoy Safe Discret Messaging",
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
                    context.toPage(OnboardingPage2());
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
