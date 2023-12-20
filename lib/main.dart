import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

enum Page {
  Welcome,
  Start,
  Vegetables,
  Fruits,
  Bill,
}

class Item {
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
      home: ShoppingPage(),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class WelcomePage extends StatelessWidget {
  final VoidCallback onNextPressed;

  WelcomePage({required this.onNextPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_checkout_rounded,
            size: 100.0,
            color: Colors.white,
          ),
          const SizedBox(height: 50.0),
          const Text(
            '           THE SHOPPING CART                                ',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: onNextPressed,
            child: const Text('Start Shopping!'),

          ),
        ],
      ),
    );
  }
}

class ItemListPage extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onItemSelected;
  final VoidCallback onNextPressed;
  final bool showBackButton;
  final Map<Item, int> frequencyMap;
  final Page currentPage;

  ItemListPage({
    required this.items,
    required this.onItemSelected,
    required this.onNextPressed,
    required this.showBackButton,
    required this.frequencyMap,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              int frequency = frequencyMap[item] ?? 0;
              bool isSelected = frequency > 0;

              return GestureDetector(
                onTap: () => onItemSelected(item),
                
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: isSelected ? Colors.deepPurpleAccent
                      : Colors.transparent,
                  child: ListTile(
                    title: Text('${item.name} - \₹${item.price}'),
                    subtitle: Text('QUANTITY: $frequency'),
                    onTap: () => onItemSelected(item),
                  ),
                ),
              );
            },
          ),
        ),
        if (currentPage != Page.Welcome && currentPage != Page.Bill )
          ElevatedButton(
            onPressed: onNextPressed,
            child: const Text('NEXT'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyanAccent), )

          ),
        if (currentPage == Page.Bill)
          ElevatedButton(
            onPressed: onNextPressed,
            child: const Text('PAY'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
            ),


          ),

        if (showBackButton)
          BackButton(
            onPressed: () {},
          ),
      ],
    );
  }
}

class _ShoppingPageState extends State<ShoppingPage> {
  final Map<Page, String> pageTitles = {
    Page.Welcome: 'WELCOME 🙏',
    Page.Start: 'DAIRY ITEMS 🐄',
    Page.Vegetables: 'VEGETABLES 🥕',
    Page.Fruits: 'FRUITS 🍓',
    Page.Bill: 'BILL 💵',
  };

  final Map<Page, List<Item>> pageItems = {
    Page.Welcome: [],
    Page.Start: [
      Item(name: 'Milk', price: 60.0),
      Item(name: 'Bread', price: 50.0),
      Item(name: 'Cottage Cheese', price: 300.0),
      Item(name: 'Butter', price: 200.0),
      Item(name: 'Whipped Cream(Amul)', price: 160.0),
      Item(name: 'Cheese Slices', price: 40.0),
      Item(name: 'Mozzarella Cheese', price: 100.0),
      Item(name: 'Desi Ghee', price: 550.0),
      Item(name: 'Ice-Cream', price: 100.0),
    ],
    Page.Vegetables: [
      Item(name: 'Carrot', price: 10.0),
      Item(name: 'Broccoli', price: 25.0),
      Item(name: 'Brinjal', price: 30.0),
      Item(name: 'Potato', price: 45.0),
      Item(name: 'Spinach', price: 15.0),
      Item(name: 'Onions', price: 25.0),
      Item(name: 'Capsicum', price: 50.0),
      Item(name: 'Tomato', price: 40.0),
      Item(name: 'Green Peas', price: 40.0),

    ],
    Page.Fruits: [
      Item(name: 'Apple', price: 150),
      Item(name: 'Banana', price: 40.0),
      Item(name: 'Pineapple', price: 60.0),
      Item(name: 'Orange', price: 40.0),
      Item(name: 'Papaya', price: 50.0),
      Item(name: 'Pomegranate', price: 110.0),
      Item(name: 'Strawberries', price: 100.0),
      Item(name: 'Guava', price: 60.0),
    ],
    Page.Bill: [],
  };

  Page currentPage = Page.Welcome;
  Map<Item, int> selectedItemsFrequency = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(pageTitles[currentPage]!),
        automaticallyImplyLeading: currentPage != Page.Welcome && currentPage != Page.Start,
        leading: (currentPage != Page.Welcome && currentPage != Page.Start)
            ? IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              navigateBack();
            });
          },
        )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: currentPage == Page.Welcome
                ? WelcomePage(
              onNextPressed: () {
                setState(() {
                  navigateForward();
                });
              },
            )
                : ItemListPage(
              items: pageItems[currentPage]!,
              onItemSelected: (item) {
                setState(() {
                  if (currentPage != Page.Welcome) {
                    pageItems[Page.Bill]!.add(item);

                    if (selectedItemsFrequency.containsKey(item)) {
                      selectedItemsFrequency[item] = selectedItemsFrequency[item]! + 1;
                    }
                    else {
                      selectedItemsFrequency[item] = 1;
                    }
                  }
                });
              },
              onNextPressed: () {
                setState(() {
                  navigateForward();
                });
              },
              showBackButton: currentPage != Page.Welcome && currentPage != Page.Start && currentPage != Page.Bill && currentPage != Page.Fruits &&  currentPage != Page.Vegetables,
              frequencyMap: selectedItemsFrequency,
              currentPage: currentPage,
            ),
          ),
          if (currentPage == Page.Bill)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(25.0),
                    ),


                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text('TOTAL PRICE: \₹${calculateTotalPrice()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ),

                      Text('       SELECTED ITEMS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      for (var entry in selectedItemsFrequency.entries)
                        Text('       ${entry.key.name}: ${entry.value}', style: TextStyle(fontSize: 15),),



                    ],
                  ),
                ),
              ),
            ),
          if (currentPage == Page.Bill)


            ElevatedButton(
              onPressed: () {
                setState(() {
                  resetCart();
                });
              },
              child: const Text('RESET CART'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), )

            ),
        ],
      ),
    );
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;

    for (var entry in selectedItemsFrequency.entries) {
      totalPrice += entry.key.price * entry.value;
    }

    return totalPrice;
  }

  void navigateForward() {
    switch (currentPage) {
      case Page.Welcome:
        currentPage = Page.Start;
        break;
      case Page.Start:
        currentPage = Page.Vegetables;
        break;
      case Page.Vegetables:
        currentPage = Page.Fruits;
        break;
      case Page.Fruits:
        currentPage = Page.Bill;
        break;
      case Page.Bill:
        break;
    }
  }

  void navigateBack() {
    switch (currentPage) {
      case Page.Welcome:
        break;
      case Page.Start:
        currentPage = Page.Welcome;
        break;
      case Page.Vegetables:
        currentPage = Page.Start;
        break;
      case Page.Fruits:
        currentPage = Page.Vegetables;
        break;
      case Page.Bill:
        currentPage = Page.Fruits;
        break;
    }
  }

  void resetCart() {
    setState(() {
      pageItems[Page.Bill]?.clear();
      selectedItemsFrequency.clear();
      currentPage = Page.Welcome;
    });
  }
}

