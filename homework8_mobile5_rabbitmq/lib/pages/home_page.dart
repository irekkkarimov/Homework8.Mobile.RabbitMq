import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> messages = [];
  Client? _client;

  @override
  void initState() {
    super.initState();
    _connectToRabbit();
  }

  void _connectToRabbit() async {
    final settings = ConnectionSettings(
      host: "192.168.0.105", // или IP backend-сервера
      port: 5672,
      authProvider: PlainAuthenticator("guest", "guest"),
    );

    _client = Client(settings: settings);
    final channel = await _client!.channel();
    final exchange = await channel.exchange(
        "Homework8.Mobile.RabbitMq.Models:NotificationMessage",
        ExchangeType.FANOUT,
        durable: true);
    final queue = await channel.queue(widget.username, durable: true);

    await queue.bind(exchange, "Homework8.Mobile.RabbitMq.Models:NotificationMessage");

    queue.consume().then((Consumer consumer) {
      consumer.listen((AmqpMessage message) {
        final msg = message.payloadAsString;
        setState(() {
          messages.add(msg);
        });
      });
    });
  }

  @override
  void dispose() {
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${widget.username}'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(messages[index]),
        ),
      ),
    );
  }
}