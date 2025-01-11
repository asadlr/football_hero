import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({required this.userId});

  Future<Map<String, dynamic>> _fetchUserData() async {
    final supabase = Supabase.instance.client;

    try {
      // Get current user's data from auth
      final currentUser = supabase.auth.currentUser;
      final userEmail = currentUser?.email ?? '';

      // Fetch user details from users table - get the first record if multiple exist
      final List<dynamic> userResponse = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .limit(1);  // Limit to 1 record instead of using single()
      
      final userDetails = userResponse.isNotEmpty ? userResponse.first : {};

      // Fetch user favorite clubs and join with football_clubs to get names
      final clubsResponse = await supabase
          .from('user_favourite_clubs')
          .select('football_clubs(name)')
          .eq('user_id', userId);
      
      final favoriteClubs = clubsResponse
          .map((club) => club['football_clubs']['name'].toString())
          .toList();

      // Fetch player details - get the first record if multiple exist
      final List<dynamic> playerResponse = await supabase
          .from('players')
          .select()
          .eq('user_id', userId)
          .limit(1);  // Limit to 1 record instead of using single()

      final playerDetails = playerResponse.isNotEmpty ? playerResponse.first : {};

      // Combine all data into a single map
      return {
        'email': userEmail,
        'userDetails': userDetails,
        'favoriteClubs': favoriteClubs,
        'playerDetails': playerDetails,
      };
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            final userDetails = data['userDetails'] as Map<String, dynamic>;
            final playerDetails = data['playerDetails'] as Map<String, dynamic>;
            
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${data['email']}'),
                  SizedBox(height: 10),
                  if (userDetails['name'] != null) Text('Name: ${userDetails['name']}'),
                  if (userDetails['dob'] != null) Text('Date of Birth: ${userDetails['dob']}'),
                  if (userDetails['role'] != null) Text('Role: ${userDetails['role']}'),
                  if (userDetails['age'] != null) Text('Age: ${userDetails['age']}'),
                  if (userDetails['is_role_valid'] != null) Text('Is Role Valid: ${userDetails['is_role_valid']}'),
                  if (userDetails['address'] != null) Text('Address: ${userDetails['address']}'),
                  if (userDetails['city'] != null) Text('City: ${userDetails['city']}'),
                  SizedBox(height: 20),
                  Text('Favorite Clubs:'),
                  ...data['favoriteClubs'].map((club) => Text(club.toString())),
                  SizedBox(height: 20),
                  Text('Player Details:'),
                  if (playerDetails['team_id'] != null) Text('Team ID: ${playerDetails['team_id']}'),
                  if (playerDetails['height'] != null) Text('Height: ${playerDetails['height']}'),
                  if (playerDetails['weight'] != null) Text('Weight: ${playerDetails['weight']}'),
                  if (playerDetails['positions'] != null) Text('Positions: ${playerDetails['positions']}'),
                  if (playerDetails['strong_leg'] != null) Text('Strong Leg: ${playerDetails['strong_leg']}'),
                  if (playerDetails['skills'] != null) Text('Skills: ${playerDetails['skills']}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
