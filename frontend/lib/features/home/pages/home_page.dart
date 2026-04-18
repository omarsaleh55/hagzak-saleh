import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/inputs/search_field.dart';
import '../models/sport_model.dart';
import '../models/venue_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/featured_venues_section.dart';
import '../widgets/home_header.dart';
import '../widgets/nearby_venues_section.dart';
import '../widgets/sports_filter_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;
  String _selectedSportId = 'all';
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  List<VenueModel> get _featured =>
      VenueModel.mockData.where((v) => v.isFeatured).toList();

  List<VenueModel> get _nearby {
    final query = _searchController.text.toLowerCase();
    return VenueModel.mockData.where((v) {
      final matchesSport =
          _selectedSportId == 'all' ||
          v.sport.toLowerCase() == _selectedSportId;
      final matchesQuery =
          query.isEmpty ||
          v.name.toLowerCase().contains(query) ||
          v.city.toLowerCase().contains(query);
      return matchesSport && matchesQuery;
    }).toList()..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  void _onSportSelected(String id) {
    setState(() => _selectedSportId = id);
  }

  void _onSearchChanged(String _) {
    setState(() {});
  }

  void _onVenueTap(VenueModel venue) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opening ${venue.name}...')));
  }

  void _onBookTap(VenueModel venue) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Booking ${venue.name}...')));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => _isLoading = true);
            await Future.delayed(const Duration(seconds: 1));
            setState(() => _isLoading = false);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.pagePaddingH,
                    AppDimensions.pagePaddingV,
                    AppDimensions.pagePaddingH,
                    AppDimensions.base,
                  ),
                  child: HomeHeader(
                    userName: 'Mohamed',
                    notificationCount: 3,
                    onNotificationTap: () {},
                    onAvatarTap: () {},
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.pagePaddingH,
                  ),
                  child: SearchField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.base),
              ),

              SliverToBoxAdapter(
                child: SportsFilterRow(
                  sports: SportModel.defaults,
                  selectedId: _selectedSportId,
                  onSelected: _onSportSelected,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.xl),
              ),

              SliverToBoxAdapter(
                child: FeaturedVenuesSection(
                  venues: _featured,
                  isLoading: _isLoading,
                  onVenueTap: _onVenueTap,
                  onBookTap: _onBookTap,
                  onSeeAll: () {},
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.xl),
              ),

              SliverToBoxAdapter(
                child: NearbyVenuesSection(
                  venues: _nearby,
                  onVenueTap: _onVenueTap,
                  onSeeAll: () {},
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
