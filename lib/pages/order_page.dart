import 'package:flutter/material.dart';
import '../models/instrument_item.dart';
import '../widgets/quantity_stepper.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // STATE: quantity ordered for each instrument index
  final Map<int, int> _qty = {};

  // SEARCH CONTROLLER + TEXT
  late TextEditingController _searchController;
  String _searchText = '';

  // CALCULATE TOTAL PRICE
  double get _total {
    var sum = 0.0;
    _qty.forEach((i, q) => sum += instruments[i].price * q);
    return sum;
  }

  // CALCULATE TOTAL ITEM COUNT
  int get _itemCount => _qty.values.fold(0, (a, b) => a + b);

  // CHANGE ORDER QUANTITY
  void _change(int index, int delta) {
    setState(() {
      final next = (_qty[index] ?? 0) + delta;
      if (next <= 0) {
        _qty.remove(index);
      } else {
        _qty[index] = next;
      }
    });
  }

  // CLEAR ORDER with SnackBar feedback
  Future<void> _clearOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear order?'),
        content: const Text('All quantities will reset to zero.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => _qty.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order cleared'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FILTERED INSTRUMENTS based on search text
    final filteredInstruments = instruments.where((item) {
      return item.name.toLowerCase().contains(_searchText);
    }).toList();

    return Scaffold(
      // APP BAR with badge + clear button
      appBar: AppBar(
        title: const Text('Musicians’ Corner — Order'),
        actions: [
          // ✅ Order badge
          Badge(
            label: Text('$_itemCount'),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Your order',
              onPressed: () {
                // later: navigate to checkout
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear order',
            onPressed: _qty.isEmpty ? null : _clearOrder,
          ),
        ],
      ),

      // BODY: search + list
      body: Column(
        children: [
          // ✅ Search filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search instruments',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredInstruments.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final item = filteredInstruments[i];
                final index = instruments.indexOf(item);
                final q = _qty[index] ?? 0;

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('₵${item.price.toStringAsFixed(2)}'),
                  // ✅ Refactored QuantityStepper
                  trailing: QuantityStepper(
                    quantity: q,
                    onIncrement: () => _change(index, 1),
                    onDecrement: () => _change(index, -1),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // BOTTOM BAR
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '₵${_total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
