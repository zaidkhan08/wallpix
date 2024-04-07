import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class cardForm extends StatefulWidget {
  const cardForm({super.key});

  @override
  State<cardForm> createState() => _cardFormState();
}

class _cardFormState extends State<cardForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,), onTap: (){ Navigator.pop(context); },),
          centerTitle: true,
          title: const Text("Pay with Credit Card"),
          backgroundColor: Color(0xFF03033F),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'Card Form',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20,),
              CardFormField(
                controller: CardFormEditController(),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){},
                child: const Text('Pay'),)

            ],
          ),
        )
    );
  }
}
