import 'dart:io';

void main() {
  // Initialize theater seats (5x5)
  List<List<String>> seats = [
    ['E', 'E', 'E', 'E', 'E'],
    ['E', 'E', 'E', 'E', 'E'],
    ['E', 'E', 'E', 'E', 'E'],
    ['E', 'E', 'E', 'E', 'E'],
    ['E', 'E', 'E', 'E', 'E'],
  ];

  // Map to store booking details
  Map<String, Map<String, String>> bookings = {};

  bool running = true;

  print('"Welcome To Our Theater"\n');

  while (running) {
    print('press 1 to book new seat');
    print('press 2 to show the theater seats');
    print('press 3 to show users data');
    print('press 4 to exit');
    stdout.write('input=>');
    String? choice = stdin.readLineSync();

    if (choice == '1') {
      // Book a new seat
      stdout.write('Enter row (1-5) or "exit" to quit: \ninput=>');
      String? rowInput = stdin.readLineSync();

      if (rowInput == 'exit') {
        continue;
      }

      int row = int.tryParse(rowInput ?? '0') ?? 0;
      if (row < 1 || row > 5) {
        print('Invalid row! Please enter a number between 1 and 5.');
        continue;
      }

      stdout.write('Enter column (1-5): \ninput=>');
      String? colInput = stdin.readLineSync();
      int col = int.tryParse(colInput ?? '0') ?? 0;
      if (col < 1 || col > 5) {
        print('Invalid column! Please enter a number between 1 and 5.');
        continue;
      }

      // Check if seat is available
      if (seats[row - 1][col - 1] == 'B') {
        print('Seat is already booked!');
        continue;
      }

      // Get user details
      stdout.write('Enter your name: \ninput=>');
      String? name = stdin.readLineSync();

      stdout.write('Enter your phone number: \ninput=>');
      String? phone = stdin.readLineSync();

      // Book the seat
      seats[row - 1][col - 1] = 'B';

      // Store booking details
      String seatPosition = '$row,$col';
      bookings[seatPosition] = {'name': name ?? '', 'phone': phone ?? ''};

      print('Seat booked successfully!\n');
    } else if (choice == '2') {
      // Show theater seats
      print('Theater Seats:');
      for (int i = 0; i < 5; i++) {
        print(
          '${seats[i][0]} ${seats[i][1]} ${seats[i][2]} ${seats[i][3]} ${seats[i][4]}',
        );
      }
      print('');
    } else if (choice == '3') {
      // Show users data
      print('\nUsers Booking Details:');
      if (bookings.isEmpty) {
        print('No bookings yet.');
      } else {
        for (var seat in bookings.keys) {
          print(
            'Seat $seat: ${bookings[seat]!['name']} - ${bookings[seat]!['phone']}',
          );
        }
      }
      print('');
    } else if (choice == '4') {
      // Exit the program
      running = false;
      print('\n"See You Back"');
    } else {
      print('Invalid choice! Please enter 1, 2, 3, or 4.\n');
    }
  }
}