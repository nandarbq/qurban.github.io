import 'dart:io';

class QurbanResult {
  String recipientName;
  String animalType;  
  double weight;

  QurbanResult(this.recipientName, this.animalType, this.weight);
}

class Queue {
  int front;
  int rear;
  int maxQueue;
  List<QurbanResult?> list;

  Queue(this.maxQueue)
      : front = -1,
        rear = -1,
        list = List<QurbanResult?>.filled(maxQueue, null, growable: false);

  bool isFull() {
    return (rear + 1) % maxQueue == front;
  }

  bool isEmpty() {
    return front == -1;
  }

  void enqueue(QurbanResult result) {
    if (isFull()) {
      print('Antrian telah penuh, tidak dapat menambahkan penerima hasil qurban.');
      return;
    }
    if (isEmpty()) {
      front = 0;
    }
    rear = (rear + 1) % maxQueue;
    list[rear] = result;
    print('Penerima hasil qurban berhasil ditambahkan!');
  }

  QurbanResult? dequeue() {
    if (isEmpty()) {
      print('Antrian kosong, mengembalikan null.');
      return null;
    }
    var result = list[front];
    if (front == rear) {
      front = rear = -1;
    } else {
      front = (front + 1) % maxQueue;
    }
    return result;
  }

  List<QurbanResult> getResults() {
    if (isEmpty()) {
      return [];
    }
    List<QurbanResult> results = [];
    int i = front;
    while (true) {
      results.add(list[i]!);
      if (i == rear) break;
      i = (i + 1) % maxQueue;
    }
    return results;
  }
}

class QurbanManager {
  Queue queue = Queue(10); // maxQueue sesuai kebutuhan

  void addResult(String recipientName, String animalType, double weight) {
    queue.enqueue(QurbanResult(recipientName, animalType, weight));
  }

  void listResults() {
    var results = queue.getResults();
    if (results.isEmpty) {
      print('Tidak ada penerima hasil qurban yang terdata ');
    } else {
      print('Daftar Penerima Hasil Qurban:');
      for (var i = 0; i < results.length; i++) {
        print(
            '${i + 1}. Penerima: ${results[i].recipientName}, Jenis Hewan: ${results[i].animalType}, Berat: ${results[i].weight} kg');
      }
    }
  }

  void removeResult() {
    var removedResult = queue.dequeue();
    if (removedResult != null) {
      print(
          'Hasil qurban untuk penerima ${removedResult.recipientName} berhasil dihapus');
    }
  }

  void searchResult(String recipientName) {
    var results = queue.getResults();
    results.sort((a, b) => a.recipientName.compareTo(b.recipientName));
    int index = binarySearch(results, recipientName);
    if (index != -1) {
      var result = results[index];
      print(
          'Hasil ditemukan: Penerima: ${result.recipientName}, Jenis Hewan: ${result.animalType}, Berat: ${result.weight} kg');
    } else {
      print('Hasil untuk penerima $recipientName tidak ditemukan');
    }
  }

  int binarySearch(List<QurbanResult> results, String recipientName) {
    int left = 0;
    int right = results.length - 1;

    while (left <= right) {
      int middle = left + (right - left) ~/ 2;
      int comparison = results[middle].recipientName.compareTo(recipientName);

      if (comparison == 0) {
        return middle;
      } else if (comparison < 0) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }
    return -1; // not found
  }
}

void main() {
  var manager = QurbanManager();
  bool running = true;

  while (running) {
    print('\nOpsi:');
    print('1. Tambah Penerima Hasil Qurban');
    print('2. Lihat Penerima Hasil Qurban');
    print('3. Hapus Penerima Hasil Qurban');
    print('4. Cari Penerima Hasil Qurban');
    print('5. Keluar');
    stdout.write('Pilih opsi: ');
    var choice = int.tryParse(stdin.readLineSync() ?? '');

    switch (choice) {
      case 1:
        stdout.write('Nama Penerima: ');
        var recipientName = stdin.readLineSync() ?? '';
        stdout.write('Jenis Hewan: ');
        var animalType = stdin.readLineSync() ?? '';
        stdout.write('Berat (kg): ');
        var weight = double.tryParse(stdin.readLineSync() ?? '');
        if (weight != null) {
          manager.addResult(recipientName, animalType, weight);
        } else {
          print('Data tidak valid');
        }
        break;
      case 2:
        manager.listResults();
        break;
      case 3:
        manager.removeResult();
        break;
      case 4:
        stdout.write('Nama Penerima yang dicari: ');
        var recipientName = stdin.readLineSync() ?? '';
        manager.searchResult(recipientName);
        break;
      case 5:
        running = false;
        print('Terima kasih telah menggunakan sistem manajemen hasil qurban!');
        break;
      default:
        print('Opsi tidak valid');
        break;
    }
  }
}
