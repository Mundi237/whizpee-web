import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/credi_wallet.dart';
import 'package:super_up/app/modules/annonces/datas/models/package_transaction.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/annonces/presentation/credit_pay_bottom_sheet.dart';
import 'package:super_up/app/modules/annonces/presentation/wallet_transactions/packages_screen.dart';
import 'package:super_up/app/modules/annonces/presentation/wallet_transactions/recap_page.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:super_up/app/modules/home/home_wide_modules/home/controller/home_wide_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CreditProvider controller = GetIt.I<CreditProvider>();
      controller.fetchTransactions();
      if (controller.wallet.value.data == null) {
        controller.getWallet();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CreditProvider controller = GetIt.I.get<CreditProvider>();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Portefeuille',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   elevation: 0,
      //   centerTitle: false,
      //   // leading: SizedBox.shrink(),
      //   // leadingWidth: 0,
      //   backgroundColor: Colors.transparent,
      //   surfaceTintColor: Colors.transparent,
      // ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                VCircleAvatar(
                  radius: 30,
                  vFileSource: VPlatformFile.fromUrl(
                    networkUrl: AppAuth.myProfile.baseUser.userImage,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full name",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppAuth.myProfile.baseUser.fullName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.string(
                    notificationIcon,
                    height: 30,
                    width: 30,
                    colorFilter: ColorFilter.mode(
                      context.iconsColors!,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            WalletComponent(),
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoxButton(
                      title: "Scanner",
                      icone: scanIcon,
                      onTap: () {},
                    ),
                    BoxButton(
                      title: "Packages",
                      icone: addIcons,
                      onTap: () {
                        if (GetIt.I.get<AppSizeHelper>().isWide(context)) {
                          GetIt.I
                              .get<HomeWideController>()
                              .openDetail(PackagesScreen());
                        } else {
                          context.toPage(PackagesScreen());
                        }
                      },
                    ),
                    BoxButton(
                      title: "Booster",
                      icone: receive,
                      onTap: () {},
                    ),
                    BoxButton(
                      title: "Retirer",
                      icone: send,
                      onTap: () {
                        if (GetIt.I.get<AppSizeHelper>().isWide(context)) {
                          GetIt.I
                              .get<HomeWideController>()
                              .openDetail(RecapPage(
                                data: {'title': "Credit withdrawal"},
                              ));
                        } else {
                          context.toPage(RecapPage(
                            data: {'title': "Credit withdrawal"},
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Histoire",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<AppState<List<PackageTransaction>>>(
                  valueListenable:
                      GetIt.I<CreditProvider>().packageTransactionsList,
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (value.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                value.errorModel!.error,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade500, fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.fetchTransactions();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  size: 30,
                                ))
                          ],
                        ),
                      );
                    }
                    if ((value.data ?? []).isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Column(
                            children: [
                              Text(
                                'Aucune annonce ne correspond à vos filtres.',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.fetchTransactions();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                      );
                    }
                    final List<PackageTransaction> transactions =
                        value.data ?? [];
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return TransactionHistoryComponent(
                            transaction: transaction);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  // Refil credit
  void _refillCredit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CreditPayBottomSheet(),
      ),
    );
  }
}

class BoxButton extends StatelessWidget {
  final String icone;
  final String title;
  final VoidCallback? onTap;
  const BoxButton(
      {super.key, required this.icone, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgPicture.string(
                icone,
                height: 25,
                width: 25,
                colorFilter: ColorFilter.mode(
                  context.iconsColors!,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 3),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class TransactionHistoryComponent extends StatelessWidget {
  const TransactionHistoryComponent({
    super.key,
    required this.transaction,
  });

  final PackageTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Image.asset(
            transaction.isDeposit
                ? "assets/trx-credit.png"
                : "assets/trx-debit.png",
            width: 40,
            height: 40,
          ),
          title: Text(
            "Achat de ${transaction.credits} crédits",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            DateFormat('dd MMM yyyy – kk:mm')
                .format(transaction.createdAt ?? DateTime.now()),
          ),
          trailing: Column(
            children: [
              Text(
                "${transaction.isDeposit ? "+ " : "- "}${transaction.amount} FCFA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color:
                      transaction.status == TransactionStatus.success.value &&
                              transaction.isDeposit
                          ? null
                          : Colors.red,
                ),
              ),
              Text(
                transaction.status.capitilizeFirstLetter(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Divider(
            color: Colors.grey.shade600,
            thickness: 0.5,
            radius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class WalletComponent extends StatefulWidget {
  const WalletComponent({super.key});

  @override
  State<WalletComponent> createState() => _WalletComponentState();
}

class _WalletComponentState extends State<WalletComponent> {
  bool isBalanceVisible = true;
  @override
  Widget build(BuildContext context) {
    CreditProvider controller = GetIt.I.get<CreditProvider>();
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/wallet-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ValueListenableBuilder<AppState<CrediWallet>>(
              valueListenable: controller.wallet,
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/wallet.item.png",
                            width: 40, height: 40),
                        SizedBox(width: 1),
                        Text(
                          "CrediFlow",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/wallet.item.png",
                            width: 40, height: 40),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "My Balance",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isBalanceVisible = !isBalanceVisible;
                            });
                          },
                          child: Icon(
                            !isBalanceVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    if (value.isLoading)
                      CircularProgressIndicator(
                        color: Colors.white,
                      )
                    else if (value.hasNotNullData)
                      Text(
                        isBalanceVisible
                            ? "${value.data?.credits.toInt() ?? 0} U"
                            : "ººººººº",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    else if (value.hasError)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            "Erreur de chargement",
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              controller.getWallet();
                            },
                            icon: Icon(Icons.refresh, color: Colors.red),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Rafraîchir le solde",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              controller.getWallet();
                            },
                            icon: Icon(Icons.refresh, color: Colors.white),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                  ],
                );
              }),
        ),
        // Positioned(
        //   right: 20,
        //   bottom: 20,
        //   child: OutlinedButton(
        //     onPressed: onRefillWalletPressed,
        //     style: OutlinedButton.styleFrom(
        //       side: BorderSide(color: Colors.white),
        //       foregroundColor: Colors.white,
        //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Image.asset("assets/wallet.item.png", width: 20, height: 20),
        //         SizedBox(width: 5),
        //         Text("Acheter des crédits"),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}

const String notificationIcon =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 14 14"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" d="M5.677 12.458a1.5 1.5 0 0 0 2.646 0M4.262 1.884a3.872 3.872 0 0 1 6.61 2.738c0 .604.1 1.171.25 1.752q.063.198.137.373c.232.545.871.732 1.348 1.084c.711.527.574 1.654-.018 2.092c0 0-.955.827-5.589.827s-5.589-.827-5.589-.827c-.592-.438-.73-1.565-.018-2.092c.477-.352 1.116-.539 1.348-1.084c.231-.544.387-1.24.387-2.125c0-1.027.408-2.012 1.134-2.738" stroke-width="1"/></svg>';
const String scanIcon =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.1" d="M4 7V6a2 2 0 0 1 2-2h2M4 17v1a2 2 0 0 0 2 2h2m8-16h2a2 2 0 0 1 2 2v1m-4 13h2a2 2 0 0 0 2-2v-1M5 12h14"/></svg>';
const String addIcons =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 24 24"><g fill="none"><path d="m12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.018-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z"/><path fill="currentColor" d="M10.5 20a1.5 1.5 0 0 0 3 0v-6.5H20a1.5 1.5 0 0 0 0-3h-6.5V4a1.5 1.5 0 0 0-3 0v6.5H4a1.5 1.5 0 0 0 0 3h6.5z" stroke-width="0.1" stroke="currentColor"/></g></svg>';
const String send =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 16 16"><g fill="currentColor" fill-rule="evenodd" stroke-width="0.1" stroke="currentColor"><path d="M6.364 13.5a.5.5 0 0 0 .5.5H13.5a1.5 1.5 0 0 0 1.5-1.5v-10A1.5 1.5 0 0 0 13.5 1h-10A1.5 1.5 0 0 0 2 2.5v6.636a.5.5 0 1 0 1 0V2.5a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 .5.5v10a.5.5 0 0 1-.5.5H6.864a.5.5 0 0 0-.5.5"/><path d="M11 5.5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h3.793l-8.147 8.146a.5.5 0 0 0 .708.708L10 6.707V10.5a.5.5 0 0 0 1 0z"/></g></svg>';
const String receive =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 16 16"><g fill="currentColor" fill-rule="evenodd" stroke-width="0.1" stroke="currentColor"><path d="M9.636 2.5a.5.5 0 0 0-.5-.5H2.5A1.5 1.5 0 0 0 1 3.5v10A1.5 1.5 0 0 0 2.5 15h10a1.5 1.5 0 0 0 1.5-1.5V6.864a.5.5 0 0 0-1 0V13.5a.5.5 0 0 1-.5.5h-10a.5.5 0 0 1-.5-.5v-10a.5.5 0 0 1 .5-.5h6.636a.5.5 0 0 0 .5-.5"/><path d="M5 10.5a.5.5 0 0 0 .5.5h5a.5.5 0 0 0 0-1H6.707l8.147-8.146a.5.5 0 0 0-.708-.708L6 9.293V5.5a.5.5 0 0 0-1 0z"/></g></svg>';
