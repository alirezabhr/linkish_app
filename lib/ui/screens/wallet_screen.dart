import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final List list = [];

    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              height: height * 0.4,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
              ),
              child: Column(
                children: [
                  Container(
                    height: height * 0.28,
                    width: double.maxFinite,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.lightBlueAccent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.wallet_giftcard),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("کیف پول لینکیش", style: TextStyle(fontSize: 20),),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text("0 ریال", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.arrow_circle_up),
                      onPressed: () {},
                      label: Text("برداشت از کیف"),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.red,
              child: Column(
                children: List.generate(list.length, (index) => Text("1")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
