import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/widgets/s_app_button.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/package.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/annonces/presentation/credit_pay_bottom_sheet.dart';
import 'package:super_up/app/modules/annonces/presentation/payment_page.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  Package? selectedPackage;

  @override
  Widget build(BuildContext context) {
    final CreditProvider creditProvider = GetIt.I<CreditProvider>();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset("assets/wallet_image.png"),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 230,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.scaffoldColors,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Text.rich(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: "Update to ",
                          children: [
                            TextSpan(
                              style: TextStyle(color: AppTheme.primaryGreen),
                              text: "Pro ",
                            ),
                            TextSpan(text: "to Get The Best")
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Get your accounnt to another level, Write, Chat and Call without any limitation, Get the best experience",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Card(
                        margin: EdgeInsets.all(0),
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Column(
                            children: [
                              BadgeWidget(title: "Amzing cover page"),
                              SizedBox(height: 5),
                              BadgeWidget(
                                  title:
                                      "Add social media link to expa  nd business"),
                              SizedBox(height: 5),
                              BadgeWidget(
                                  title: "Directly chat with customers"),
                              SizedBox(height: 5),
                              BadgeWidget(
                                  title:
                                      "Get more trafic to your page or website"),
                              SizedBox(height: 5)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ValueListenableBuilder<AppState<List<Package>>>(
                          valueListenable: creditProvider.packagesList,
                          builder: (context, state, child) {
                            if (state.isLoading) {
                              return Column(
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  SizedBox(height: 30),
                                ],
                              );
                            }
                            if (state.hasError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 50),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        state.errorModel!.error,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red.shade500,
                                            fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          creditProvider.fetchPackages();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 30,
                                        )),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              );
                            }
                            if ((state.data ?? []).isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Aucun forfait de crédits disponible.',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          creditProvider.fetchPackages();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              );
                            }
                            final List<Package> packages = state.data ?? [];
                            // return NewPackgeItems(
                            //   package: packages[1],
                            // );
                            return Row(
                              spacing: 8,
                              children: [
                                ...List.generate(packages.length, (index) {
                                  final package = packages[index];
                                  return Flexible(
                                    child: NewPackgeItems(
                                      isSelected:
                                          package.id == selectedPackage?.id,
                                      package: package,
                                      onTap: (package) {
                                        setState(() {
                                          selectedPackage = package;
                                        });
                                      },
                                    ),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      AppButton(
                          text: "Activate plan",
                          onPressed: () {
                            if (selectedPackage == null) {
                              VAppAlert.showErrorSnackBar(
                                  context: context,
                                  message: "You must select one package");
                              return;
                            }
                            context
                                .toPage(PaymentPage(package: selectedPackage!));
                          })
                    ],
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

class BadgeWidget extends StatelessWidget {
  final String title;
  const BadgeWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.string(
          badgeIcon,
          height: 40,
          width: 40,
          colorFilter: ColorFilter.mode(AppTheme.primaryGreen, BlendMode.srcIn),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

const String badgeIcon =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 24 24"><path fill="currentColor" d="M12.65 3.797c.487.131.908.458 1.42.854l.297.23c.243.187.301.23.359.261a1 1 0 0 0 .196.081c.063.019.134.03.438.07l.373.047c.642.082 1.17.149 1.607.4c.383.22.7.537.92.92c.251.436.318.965.4 1.607l.048.373c.039.304.05.375.069.438q.03.102.08.196c.032.058.075.116.262.359l.23.297c.396.512.723.933.854 1.42a2.5 2.5 0 0 1 0 1.3c-.131.487-.458.908-.854 1.42l-.23.297c-.187.243-.23.301-.261.359q-.051.094-.081.196c-.019.063-.03.134-.07.438l-.047.373c-.082.642-.149 1.17-.4 1.607a2.5 2.5 0 0 1-.92.92c-.436.251-.965.318-1.607.4l-.373.048c-.304.039-.375.05-.438.069q-.102.03-.196.08c-.058.032-.116.075-.359.262l-.297.23c-.512.396-.933.723-1.42.854a2.5 2.5 0 0 1-1.3 0c-.487-.131-.908-.458-1.42-.854l-.297-.23c-.243-.187-.301-.23-.359-.261a1 1 0 0 0-.196-.081c-.063-.019-.134-.03-.438-.07l-.373-.047c-.642-.082-1.17-.149-1.607-.4a2.5 2.5 0 0 1-.92-.92c-.251-.436-.318-.965-.4-1.607l-.048-.373c-.039-.304-.05-.375-.069-.438a1 1 0 0 0-.08-.196c-.032-.058-.075-.116-.262-.359l-.23-.297c-.396-.512-.723-.933-.854-1.42a2.5 2.5 0 0 1 0-1.3c.131-.487.458-.908.854-1.42l.23-.297c.187-.243.23-.301.261-.359a1 1 0 0 0 .081-.196c.019-.063.03-.134.07-.438l.047-.373c.082-.642.149-1.17.4-1.607a2.5 2.5 0 0 1 .92-.92c.436-.251.965-.318 1.607-.4l.373-.048c.304-.039.375-.05.438-.069a1 1 0 0 0 .196-.08c.058-.032.116-.075.359-.262l.297-.23c.512-.396.933-.723 1.42-.854a2.5 2.5 0 0 1 1.3 0m3.057 5.496a1 1 0 0 0-1.414 0L11 12.586l-1.293-1.293a1 1 0 0 0-1.414 1.414l2 2a1 1 0 0 0 1.414 0l4-4a1 1 0 0 0 0-1.414" stroke-width="0.1" stroke="currentColor"/></svg>';
