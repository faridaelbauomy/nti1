import 'dart:io';

// Singleton class to manage theater state
class TheaterManager {
  static final TheaterManager _instance = TheaterManager._internal();
  late List<Seat> seats;
  Map<String, Booking> bookings = {};

  factory TheaterManager() => _instance;

  TheaterManager._internal() {
    // Initialize 5x5 theater seats
    seats = List.generate(
      25,
      (index) => Seat(row: (index ~/ 5) + 1, column: (index % 5) + 1),
    );
  }

  void displayLayout() {
    print("\n=== Theater Layout ===");
    print("E = Empty seat, B = Booked seat");
    print("------------------------");
    print("   1  2  3  4  5");

    for (int i = 0; i < 5; i++) {
      stdout.write("${i + 1} |");
      for (int j = 0; j < 5; j++) {
        stdout.write(" ${seats[i * 5 + j].isBooked ? 'B' : 'E'} ");
      }
      print("");
    }
    print("------------------------");
  }

  void displayBookings() {
    print("\n=== Booking Details ===");
    if (bookings.isEmpty) {
      print("No seats have been booked yet!");
    } else {
      bookings.forEach((seat, booking) {
        print("Seat ${booking.seat.position}: "
            "${booking.name} - ${booking.phone}");
      });
    }
    print("=====================");
  }
}

// Seat class to represent individual seats
class Seat {
  final int row;
  final int column;
  bool isBooked = false;

  Seat({required this.row, required this.column});

  String get position => "$row,$column";

  @override
  String toString() => "Row $row, Column $column";
}

// Booking class to store booking details
class Booking {
  final String name;
  final String phone;
  final Seat seat;

  Booking({required this.name, required this.phone, required this.seat});
}

class BookingSystem {
  final TheaterManager theater = TheaterManager();

  void run() {
    print("\n=== Welcome to the Simple Theater Booking System ===");
    print("This system helps you book seats in our 5x5 theater.");
    print("================================================");

    while (true) {
      _displayMenu();
      String? choice = _getInput("\nEnter your choice (1-4): ");

      switch (choice?.trim()) {
        case '1':
          _bookSeat();
          break;
        case '2':
          theater.displayLayout();
          break;
        case '3':
          theater.displayBookings();
          break;
        case '4':
          print("\nThank you for using our Theater Booking System!");
          print("Goodbye! 👋");
          return;
        default:
          print("\n❌ Invalid choice! Please enter a number between 1 and 4.");
      }
    }
  }

  void _displayMenu() {
    print("\n=== Main Menu ===");
    print("1. Book a new seat");
    print("2. View theater layout");
    print("3. View booking details");
    print("4. Exit program");
    print("=================");
  }

  String? _getInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync();
  }

  void _bookSeat() {
    print("\n=== Book a Seat ===");
    print("Enter 'back' at any time to return to main menu");

    while (true) {
      try {
        // Get row
        String? rowChoice = _getInput("\nEnter row number (1-5): ");
        if (_isBack(rowChoice)) return;
        int row = _parseInput(rowChoice, "row");

        // Get column
        String? colChoice = _getInput("Enter column number (1-5): ");
        if (_isBack(colChoice)) return;
        int col = _parseInput(colChoice, "column");

        // Validate seat coordinates
        if (!_isValidCoordinate(row) || !_isValidCoordinate(col)) {
          print("❌ Error: Row and column must be between 1 and 5!");
          continue;
        }

        // Check seat availability
        Seat seat = theater.seats[(row - 1) * 5 + (col - 1)];
        if (seat.isBooked) {
          print("❌ Sorry, this seat is already booked!");
          continue;
        }

        // Get customer details
        String? name = _getInput("\nEnter your name: ");
        if (_isBack(name)) return;
        if (name == null || name.trim().isEmpty) {
          print("❌ Error: Name cannot be empty!");
          continue;
        }

        String? phone = _getInput("Enter your phone number: ");
        if (_isBack(phone)) return;
        if (phone == null || phone.trim().isEmpty) {
          print("❌ Error: Phone number cannot be empty!");
          continue;
        }

        // Book the seat
        seat.isBooked = true;
        theater.bookings[seat.position] = Booking(
          name: name.trim(),
          phone: phone.trim(),
          seat: seat,
        );

        print("\n✅ Success! Your seat has been booked!");
        print("Seat: ${seat.toString()}");
        print("Name: ${name.trim()}");
        print("Phone: ${phone.trim()}");
        return;

      } on FormatException {
        print("\n❌ Error: Please enter a valid number!");
      } catch (e) {
        print("\n❌ Error: An unexpected error occurred: $e");
      }
    }
  }

  bool _isBack(String? input) => input?.toLowerCase().trim() == 'back';

  int _parseInput(String? input, String fieldName) {
    if (input == null || input.trim().isEmpty) {
      throw FormatException("$fieldName cannot be empty");
    }
    return int.parse(input.trim());
  }

  bool _isValidCoordinate(int value) => value >= 1 && value <= 5;
}

void main() {
  BookingSystem system = BookingSystem();
  system.run();
}