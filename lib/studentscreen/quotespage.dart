import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotesPage extends StatelessWidget {
  // List of quotes with authors
  final List<Map<String, String>> quotes = [
    {
      'quote':
          'The greatest glory in living lies not in never falling, but in rising every time we fall.',
      'author': 'Nelson Mandela'
    },
    {
      'quote': 'The way to get started is to quit talking and begin doing.',
      'author': 'Walt Disney'
    },
    {
      'quote': 'Life is what happens when you’re busy making other plans.',
      'author': 'John Lennon'
    },
    {
      'quote':
          'The future belongs to those who believe in the beauty of their dreams.',
      'author': 'Eleanor Roosevelt'
    },
    {
      'quote':
          'In the end, we will remember not the words of our enemies, but the silence of our friends.',
      'author': 'Martin Luther King Jr.'
    },
    {
      'quote':
          'To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.',
      'author': 'Ralph Waldo Emerson'
    },
    {
      'quote': 'You only live once, but if you do it right, once is enough.',
      'author': 'Mae West'
    },
    {
      'quote': 'The purpose of our lives is to be happy.',
      'author': 'Dalai Lama'
    },
    {
      'quote': 'Life is either a daring adventure or nothing at all.',
      'author': 'Helen Keller'
    },
    {
      'quote':
          'You have within you right now, everything you need to deal with whatever the world can throw at you.',
      'author': 'Brian Tracy'
    },
    {
      'quote': 'Believe you can and you’re halfway there.',
      'author': 'Theodore Roosevelt'
    },
    {
      'quote': 'It does not do to dwell on dreams and forget to live.',
      'author': 'J.K. Rowling'
    },
    {
      'quote': 'You must be the change you wish to see in the world.',
      'author': 'Mahatma Gandhi'
    },
    {
      'quote':
          'Do not go where the path may lead, go instead where there is no path and leave a trail.',
      'author': 'Ralph Waldo Emerson'
    },
    {
      'quote':
          'Success usually comes to those who are too busy to be looking for it.',
      'author': 'Henry David Thoreau'
    },
    {
      'quote':
          'The best time to plant a tree was 20 years ago. The second best time is now.',
      'author': 'Chinese Proverb'
    },
    {
      'quote': 'The only impossible journey is the one you never begin.',
      'author': 'Tony Robbins'
    },
    {
      'quote': 'Act as if what you do makes a difference. It does.',
      'author': 'William James'
    },
    {
      'quote':
          'To live is the rarest thing in the world. Most people exist, that is all.',
      'author': 'Oscar Wilde'
    },
    {
      'quote': 'Everything you’ve ever wanted is on the other side of fear.',
      'author': 'George Addair'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Famous Quotes',
          style: GoogleFonts.openSans(),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index]['quote']!;
          final author = quotes[index]['author']!;

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                quote,
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '- $author',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
              tileColor: Colors.teal[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
