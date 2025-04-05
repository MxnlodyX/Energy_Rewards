import 'package:flutter/material.dart';
import 'package:clean_energy_rewards/pages/components/sideBar.dart';
import 'package:clean_energy_rewards/pages/components/navBar.dart';
import 'package:clean_energy_rewards/pages/components/appBar.dart';
import 'package:clean_energy_rewards/pages/model_for_test/reward_model.dart';

class RewardHistory extends StatefulWidget {
  const RewardHistory({super.key});

  @override
  State<RewardHistory> createState() => _RewardHistoryState();
}

class _RewardHistoryState extends State<RewardHistory> {
  List<RewardModel> allRewards = [];
  List<RewardModel> displayedRewards = [];
  int currentPage = 1;
  final int itemsPerPage = 4;
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  void _loadRewards() {
    setState(() => isLoading = true);

    Future.delayed(Duration(milliseconds: 500), () {
      final loadedRewards = RewardModel.getRewards();
      setState(() {
        allRewards = loadedRewards;
        isLoading = false;
        _applyFilters();
      });
    });
  }

  void _applyFilters() {
    List<RewardModel> filtered =
        allRewards.where((reward) {
          return searchQuery.isEmpty ||
              reward.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              reward.total_point.toString().contains(searchQuery);
        }).toList();

    final startIndex = (currentPage - 1) * itemsPerPage;
    var endIndex = startIndex + itemsPerPage;
    if (endIndex > filtered.length) endIndex = filtered.length;

    setState(() {
      displayedRewards = filtered.sublist(
        startIndex.clamp(0, filtered.length),
        endIndex.clamp(0, filtered.length),
      );
    });
  }

  void _goToPage(int page) {
    if (page < 1 || page > _totalPages) return;
    setState(() {
      currentPage = page;
      _applyFilters();
    });
  }

  int get _totalPages {
    final filteredCount =
        allRewards.where((reward) {
          return searchQuery.isEmpty ||
              reward.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              reward.total_point.toString().contains(searchQuery);
        }).length;
    return (filteredCount / itemsPerPage).ceil();
  }

  int get _filteredCount {
    return allRewards.where((reward) {
      return searchQuery.isEmpty ||
          reward.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          reward.total_point.toString().contains(searchQuery);
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: menuDrawer(),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : allRewards.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Rewards History",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 82, 49, 31),
                            ),
                          ),
                        ],
                      ),

                      // Item count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Showing ${displayedRewards.length} of $_filteredCount rewards',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Search field
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                              currentPage = 1;
                              _applyFilters();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search rewards...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 142, 180, 134),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Reward cards or empty state
                      displayedRewards.isEmpty
                          ? _buildNoResultsFound()
                          : Column(
                            children:
                                displayedRewards
                                    .map((reward) => _buildRewardCard(reward))
                                    .toList(),
                          ),

                      // Pagination controls
                      if (_totalPages > 1) _buildPaginationControls(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: null,
        onItemTapped: null,
      ),
    );
  }

  Widget _buildRewardCard(RewardModel reward) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(reward.iconPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: 2025-5-4',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 27, 23, 23),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Track Number: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 27, 23, 23),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'TH12334567XB',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 106, 133, 57),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Transportation: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 27, 23, 23),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: 'Flash',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 106, 133, 57),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/Energy_Coin.png',
                              width: 30,
                              height: 30,
                            ),
                            Text(
                              "Points: ${reward.total_point}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous page button
          IconButton(
            icon: Icon(Icons.chevron_left),
            color: currentPage > 1 ? Colors.black : Colors.grey,
            onPressed:
                currentPage > 1 ? () => _goToPage(currentPage - 1) : null,
          ),

          // Page numbers
          for (int i = 1; i <= _totalPages; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Material(
                color:
                    i == currentPage
                        ? Color.fromARGB(255, 142, 180, 134)
                        : Colors.transparent,
                shape: CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _goToPage(i),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      '$i',
                      style: TextStyle(
                        color: i == currentPage ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Next page button
          IconButton(
            icon: Icon(Icons.chevron_right),
            color: currentPage < _totalPages ? Colors.black : Colors.grey,
            onPressed:
                currentPage < _totalPages
                    ? () => _goToPage(currentPage + 1)
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No rewards available',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _loadRewards, child: const Text('Refresh')),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No rewards match your search',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                searchQuery = '';
                currentPage = 1;
                _applyFilters();
              });
            },
            child: const Text('Clear search'),
          ),
        ],
      ),
    );
  }
}
