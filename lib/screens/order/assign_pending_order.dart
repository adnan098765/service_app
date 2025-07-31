import 'package:flutter/material.dart';

class AssignPendingScreen extends StatefulWidget {
  const AssignPendingScreen({super.key});

  @override
  _AssignPendingScreenState createState() => _AssignPendingScreenState();
}

class _AssignPendingScreenState extends State<AssignPendingScreen> {
  int _selectedTab = 0;

  final List<Order> pendingOrders = [
    Order(title: "Plumber needed for plumbing", status: "Pending"),
    Order(
      title: "Machine filter needed. Moderne filter needed.",
      status: "Pending",
    ),
    Order(title: "Plumber needed for plumbing", status: "Pending"),
    Order(title: "Plumbing Services", status: "Assigned"),
    Order(title: "Plumbing Services", status: "Accepted"),
  ];

  final List<Order> historyOrders = [
    Order(
      title: "Machine filter needed.",
      status: "Confirmed",
      time: "2 hrs ago",
    ),
    Order(
      title: "Machine filter needed. Moderne filter needed.",
      time: "2 hrs ago",
    ),
    Order(
      title: "Machine filter needed. Moderne filter needed.",
      time: "2 hrs ago",
    ),
    Order(
      title: "Machine filter needed. Moderne filter needed.",
      time: "2 hrs ago",
    ),
    Order(
      title: "Machine filter needed. Moderne filter needed.",
      time: "2 hrs ago",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [_buildTab(0, 'Pending'), _buildTab(1, 'History')],
            ),
          ),

          // Content Area
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildOrderList(pendingOrders),
                _buildOrderList(historyOrders),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _selectedTab == index ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _selectedTab == index ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderItem(order: orders[index]);
      },
    );
  }
}

// Order Model
class Order {
  final String title;
  final String status;
  final String time;

  Order({required this.title, this.status = "Unknown", this.time = ""});

  bool get isHighlighted =>
      title.toLowerCase().contains("plumber") ||
      title.toLowerCase().contains("machine filter");
}

// Order Item Widget
class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Highlighted Title
          Text(
            order.title,
            style: TextStyle(
              fontWeight:
                  order.isHighlighted ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),

          SizedBox(height: 8),

          // Status & Time Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              if (order.time.isNotEmpty) ...[
                SizedBox(width: 8),
                Text(
                  order.time,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.green;
      case 'Assigned':
        return Colors.blue;
      case 'Accepted':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
