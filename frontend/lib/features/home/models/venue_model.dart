class VenueModel {
  const VenueModel({
    required this.id,
    required this.name,
    required this.city,
    required this.sport,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.pricePerHour,
    required this.imageUrl,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String city;
  final String sport;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final double pricePerHour;
  final String imageUrl;
  final bool isFeatured;

  static final List<VenueModel> mockData = [
    const VenueModel(
      id: '1',
      name: 'Elite Sports Club',
      city: 'New Cairo',
      sport: 'Football',
      rating: 4.8,
      reviewCount: 124,
      distanceKm: 1.2,
      pricePerHour: 250,
      imageUrl:
          'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=400',
      isFeatured: true,
    ),
    const VenueModel(
      id: '2',
      name: 'Padel Arena Cairo',
      city: 'Maadi',
      sport: 'Padel',
      rating: 4.6,
      reviewCount: 89,
      distanceKm: 2.5,
      pricePerHour: 350,
      imageUrl:
          'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400',
      isFeatured: true,
    ),
    const VenueModel(
      id: '3',
      name: 'Grand Tennis Club',
      city: 'Zamalek',
      sport: 'Tennis',
      rating: 4.9,
      reviewCount: 210,
      distanceKm: 3.8,
      pricePerHour: 400,
      imageUrl:
          'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?w=400',
      isFeatured: true,
    ),
    const VenueModel(
      id: '4',
      name: 'Hoop Dreams',
      city: 'Heliopolis',
      sport: 'Basketball',
      rating: 4.5,
      reviewCount: 67,
      distanceKm: 4.1,
      pricePerHour: 200,
      imageUrl:
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
    ),
    const VenueModel(
      id: '5',
      name: 'Cairo Football Hub',
      city: 'Nasr City',
      sport: 'Football',
      rating: 4.3,
      reviewCount: 152,
      distanceKm: 5.0,
      pricePerHour: 180,
      imageUrl:
          'https://images.unsplash.com/photo-1459865264687-595d652de67e?w=400',
    ),
    const VenueModel(
      id: '6',
      name: 'Ace Tennis Academy',
      city: 'Sheikh Zayed',
      sport: 'Tennis',
      rating: 4.7,
      reviewCount: 94,
      distanceKm: 6.3,
      pricePerHour: 380,
      imageUrl:
          'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=400',
    ),
  ];
}
