import 'package:flutter/material.dart';
import 'package:super_up/app/core/widgets/s_app_button.dart';
import 'package:super_up_core/super_up_core.dart';

class SuccesPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const SuccesPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.55,
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(20),
                height: MediaQuery.sizeOf(context).height * 0.50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Successfull",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your transaction has been initiate succesfully",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Transaction amount",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "${data["amount"]}",
                      style: TextStyle(
                        fontSize: 30,
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Transaction type",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${data["type"]}",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(height: 40),
                    AppButton(
                      text: "Done",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.sizeOf(context).width * .5 - 45,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade100,
                child: CircleAvatar(
                  backgroundColor: AppTheme.primaryGreen,
                  radius: 30,
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      size: 40,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
