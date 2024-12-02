import 'package:flutter/material.dart';
import 'database_helper.dart';

class StatisticsPage extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchStatistics() async {
    final repairRequests = await DatabaseHelper().getRepairRequests();
    final paintingRequests = await DatabaseHelper().getPaintingRequests();

    int totalRepairRequests = repairRequests.length;
    int totalPaintingRequests = paintingRequests.length;

    int inProgressRepairs = repairRequests.where((request) => request['status'] == 'в работе').length;
    int completedRepairs = repairRequests.where((request) => request['status'] == 'выполнено').length;

    int inProgressPaintings = paintingRequests.where((request) => request['status'] == 'в работе').length;
    int completedPaintings = paintingRequests.where((request) => request['status'] == 'выполнено').length;

    return {
      'totalRepairRequests': totalRepairRequests,
      'inProgressRepairs': inProgressRepairs,
      'completedRepairs': completedRepairs,
      'totalPaintingRequests': totalPaintingRequests,
      'inProgressPaintings': inProgressPaintings,
      'completedPaintings': completedPaintings,
      'repairRequests': repairRequests,
      'paintingRequests': paintingRequests,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки статистики'));
          } else if (!snapshot.hasData ||
              (snapshot.data!['repairRequests'].isEmpty && snapshot.data!['paintingRequests'].isEmpty)) {
            return Center(child: Text('Нет данных для отображения'));
          } else {
            final stats = snapshot.data!;
            final repairRequests = stats['repairRequests'] as List<Map<String, dynamic>>;
            final paintingRequests = stats['paintingRequests'] as List<Map<String, dynamic>>;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Общее количество заявок на ремонт: ${stats['totalRepairRequests']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Заявки на ремонт в работе: ${stats['inProgressRepairs']}',
                          style: TextStyle(fontSize: 18, color: Colors.orange),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Заявки на ремонт выполнены: ${stats['completedRepairs']}',
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                        Divider(),
                        Text(
                          'Общее количество заявок на покраску: ${stats['totalPaintingRequests']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Заявки на покраску в работе: ${stats['inProgressPaintings']}',
                          style: TextStyle(fontSize: 18, color: Colors.orange),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Заявки на покраску выполнены: ${stats['completedPaintings']}',
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Заявки на ремонт',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: repairRequests.length,
                    itemBuilder: (context, index) {
                      final request = repairRequests[index];
                      final isCompleted = request['status'] == 'выполнено';
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(request['id'].toString()),
                          ),
                          title: Text(request['ownerName'] ?? 'Неизвестно'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Дата создания: ${request['date']}'),
                              Text('Время создания: ${request['time']}'),
                              if (isCompleted) ...[
                                Text(
                                  'Дата выполнения: ${request['completionDate'] ?? 'Нет данных'}',
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                  'Время выполнения: ${request['completionTime'] ?? 'Нет данных'}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ],
                          ),
                          trailing: Text(
                            request['status'] ?? 'Неизвестно',
                            style: TextStyle(
                              color: isCompleted ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Заявки на покраску',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: paintingRequests.length,
                    itemBuilder: (context, index) {
                      final request = paintingRequests[index];
                      final isCompleted = request['status'] == 'выполнено';
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(request['id'].toString()),
                          ),
                          title: Text(request['ownerName'] ?? 'Неизвестно'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Дата создания: ${request['date']}'),
                              Text('Цвет: ${request['color']}'),
                              if (isCompleted)
                                Text(
                                  'Статус: ${request['status']}',
                                  style: TextStyle(color: Colors.green),
                                ),
                            ],
                          ),
                          trailing: Text(
                            request['status'] ?? 'Неизвестно',
                            style: TextStyle(
                              color: isCompleted ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
