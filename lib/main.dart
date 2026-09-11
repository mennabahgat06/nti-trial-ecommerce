import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'services/api_client.dart';
import 'services/api_services.dart';

void main() {
  runApp(const MannonaApp());
}

class MannonaApp extends StatelessWidget {
  const MannonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mannona E-Commerce Dio Tester',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserApiService _userService = UserApiService();
  final ProductApiService _productService = ProductApiService();
  final CategoryApiService _categoryService = CategoryApiService();
  final SliderApiService _sliderService = SliderApiService();
  final OrderApiService _orderService = OrderApiService();

  String _consoleOutput = 'جاهز للتجربة! اضغط على أي زر لتشغيل الـ Request.';
  bool _isLoading = false;

  final TextEditingController _urlController = TextEditingController(text: ApiClient.baseUrl);
  final TextEditingController _tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _executeRequest(String label, Future<Response> Function() action) async {
    setState(() {
      _isLoading = true;
      _consoleOutput = 'جاري تنفيذ: $label...';
    });

    try {
      final response = await action();
      final encoder = const JsonEncoder.withIndent('  ');
      final formattedData = response.data is Map || response.data is List
          ? encoder.convert(response.data)
          : response.data.toString();

      setState(() {
        _consoleOutput = '✅ نجاح [$label]\n'
            'Status: ${response.statusCode} ${response.statusMessage}\n'
            'Data:\n$formattedData';
      });
    } on DioException catch (e) {
      setState(() {
        _consoleOutput = '❌ خطأ في [$label]\n'
            'Error Type: ${e.type}\n'
            'Message: ${e.message}\n'
            'Response Status: ${e.response?.statusCode}\n'
            'Response Data: ${e.response?.data}';
      });
    } catch (e) {
      setState(() {
        _consoleOutput = '❌ خطأ غير متوقع: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shopping_bag_outlined),
            SizedBox(width: 8),
            Text('Mannona Try E-Commerce', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'إعدادات الـ Base URL والتوكن',
            onPressed: _showSettingsDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Users & Auth'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Products'),
            Tab(icon: Icon(Icons.category), text: 'Categories & Sliders'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Orders'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            flex: 5,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersTab(),
                _buildProductsTab(),
                _buildCategoriesSlidersTab(),
                _buildOrdersTab(),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 2),
          _buildConsoleSection(),
        ],
      ),
    );
  }

  Widget _buildConsoleSection() {
    return Container(
      height: 200,
      color: const Color(0xFF1E1E2E),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.terminal, color: Colors.greenAccent, size: 18),
                  SizedBox(width: 6),
                  Text('Response Console', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.clear_all, color: Colors.white70, size: 20),
                tooltip: 'مسح الكونسول',
                onPressed: () => setState(() => _consoleOutput = 'الكونسول نظيف ومستعد.'),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF14141E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _consoleOutput,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Users Tab
  Widget _buildUsersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActionCard(
          title: 'تسجيل الدخول (Login)',
          icon: Icons.login,
          color: Colors.blue,
          onPressed: () => _executeRequest('Login', () async {
            final res = await _userService.login(
              email: 'ahmed@gmail.com',
              password: 'password123',
            );
            if (res.data != null && res.data['access_token'] != null) {
              ApiClient.accessToken = res.data['access_token'];
              _tokenController.text = ApiClient.accessToken!;
            }
            return res;
          }),
        ),
        _buildActionCard(
          title: 'إنشاء حساب جديد (Register)',
          icon: Icons.person_add,
          color: Colors.green,
          onPressed: () => _executeRequest('Register', () => _userService.register(
            name: 'Ahmed Saber',
            email: 'ahmed${DateTime.now().millisecondsSinceEpoch}@gmail.com',
            password: 'password123',
            phone: '01004383942',
          )),
        ),
        _buildActionCard(
          title: 'جلب بيانات الحساب (Get User Data)',
          icon: Icons.badge,
          color: Colors.teal,
          onPressed: () => _executeRequest('Get User Data', () => _userService.getUserData()),
        ),
        _buildActionCard(
          title: 'تحديث الحساب (Update Profile)',
          icon: Icons.edit,
          color: Colors.orange,
          onPressed: () => _executeRequest('Update Profile', () => _userService.updateProfile(
            name: 'Ahmed Saber Updated',
            phone: '01099999999',
          )),
        ),
        _buildActionCard(
          title: 'تجديد التوكن (Refresh Token)',
          icon: Icons.refresh,
          color: Colors.indigo,
          onPressed: () => _executeRequest('Refresh Token', () => _userService.refreshToken(
            ApiClient.refreshToken ?? 'sample_refresh_token',
          )),
        ),
        _buildActionCard(
          title: 'حذف الحساب (Delete User)',
          icon: Icons.delete_forever,
          color: Colors.red,
          onPressed: () => _executeRequest('Delete User', () => _userService.deleteUser()),
        ),
      ],
    );
  }

  // Products Tab
  Widget _buildProductsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActionCard(
          title: 'جلب جميع المنتجات (Get Products)',
          icon: Icons.list_alt,
          color: Colors.purple,
          onPressed: () => _executeRequest('Get Products', () => _productService.getProducts()),
        ),
        _buildActionCard(
          title: 'بحث عن منتجات (Search: "p")',
          icon: Icons.search,
          color: Colors.deepPurple,
          onPressed: () => _executeRequest('Search Products', () => _productService.searchProducts('p')),
        ),
        _buildActionCard(
          title: 'المنتجات الأكثر مبيعاً (Best Sellers)',
          icon: Icons.local_fire_department,
          color: Colors.amber.shade800,
          onPressed: () => _executeRequest('Best Sellers', () => _productService.getBestSellers()),
        ),
        _buildActionCard(
          title: 'المنتجات الأعلى تقييماً (Top Rated)',
          icon: Icons.star,
          color: Colors.amber.shade700,
          onPressed: () => _executeRequest('Top Rated', () => _productService.getTopRated()),
        ),
        _buildActionCard(
          title: 'إضافة منتج جديد (New Product)',
          icon: Icons.add_business,
          color: Colors.green,
          onPressed: () => _executeRequest('New Product', () => _productService.addProduct(
            name: 'Sample Product 2026',
            description: 'Created from Mannona Flutter Dio tester',
            rating: '4.8',
            price: '99',
            categoryId: '1',
            isBestSeller: true,
          )),
        ),
        _buildActionCard(
          title: 'تعديل منتج رقم 3 (Edit Product)',
          icon: Icons.edit_note,
          color: Colors.orange,
          onPressed: () => _executeRequest('Edit Product', () => _productService.editProduct(
            id: '3',
            name: 'Updated Product 3',
            description: 'Updated Description',
            price: '75',
          )),
        ),
        _buildActionCard(
          title: 'إضافة للمفضلة (Add to Favorite)',
          icon: Icons.favorite,
          color: Colors.pink,
          onPressed: () => _executeRequest('Add to Favorite', () => _productService.addToFavorite('1')),
        ),
        _buildActionCard(
          title: 'حذف منتج رقم 3 (Delete Product)',
          icon: Icons.delete_outline,
          color: Colors.red,
          onPressed: () => _executeRequest('Delete Product', () => _productService.deleteProduct('3')),
        ),
      ],
    );
  }

  // Categories & Sliders Tab
  Widget _buildCategoriesSlidersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('الأقسام (Categories)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _buildActionCard(
          title: 'عرض الأقسام (Get Categories)',
          icon: Icons.category,
          color: Colors.cyan.shade700,
          onPressed: () => _executeRequest('Get Categories', () => _categoryService.getCategories()),
        ),
        _buildActionCard(
          title: 'إضافة قسم جديد (New Category)',
          icon: Icons.add_circle_outline,
          color: Colors.cyan,
          onPressed: () => _executeRequest('New Category', () => _categoryService.addCategory(
            title: 'Fashion & Clothes',
            description: 'Top trending styles',
          )),
        ),
        _buildActionCard(
          title: 'تعديل قسم رقم 2 (Edit Category)',
          icon: Icons.drive_file_rename_outline,
          color: Colors.orange,
          onPressed: () => _executeRequest('Edit Category', () => _categoryService.editCategory(
            id: '2',
            title: 'Updated Category',
            description: 'Updated description for cat 2',
          )),
        ),
        _buildActionCard(
          title: 'حذف قسم رقم 1 (Delete Category)',
          icon: Icons.delete,
          color: Colors.redAccent,
          onPressed: () => _executeRequest('Delete Category', () => _categoryService.deleteCategory('1')),
        ),
        const SizedBox(height: 16),
        const Text('السلايدرز (Sliders)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _buildActionCard(
          title: 'عرض السلايدرز (Get Sliders)',
          icon: Icons.view_carousel,
          color: Colors.blueGrey,
          onPressed: () => _executeRequest('Get Sliders', () => _sliderService.getSliders()),
        ),
        _buildActionCard(
          title: 'إضافة سلايدر جديد (New Slider)',
          icon: Icons.add_photo_alternate,
          color: Colors.blueGrey.shade700,
          onPressed: () => _executeRequest('New Slider', () => _sliderService.addSlider(
            title: 'Special 50% Off Offer',
            description: 'Summer season sale banner',
          )),
        ),
        _buildActionCard(
          title: 'تعديل سلايدر رقم 1 (Edit Slider)',
          icon: Icons.edit,
          color: Colors.orange,
          onPressed: () => _executeRequest('Edit Slider', () => _sliderService.editSlider(
            id: '1',
            title: 'Updated Slider 1',
            description: 'Updated banner description',
          )),
        ),
        _buildActionCard(
          title: 'حذف سلايدر رقم 1 (Delete Slider)',
          icon: Icons.delete_forever,
          color: Colors.redAccent,
          onPressed: () => _executeRequest('Delete Slider', () => _sliderService.deleteSlider('1')),
        ),
      ],
    );
  }

  // Orders Tab
  Widget _buildOrdersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActionCard(
          title: 'جلب الطلبات (Get Orders)',
          icon: Icons.list_alt,
          color: Colors.brown,
          onPressed: () => _executeRequest('Get Orders', () => _orderService.getOrders()),
        ),
        _buildActionCard(
          title: 'إنشاء طلب جديد (Place Order)',
          icon: Icons.add_shopping_cart,
          color: Colors.green,
          onPressed: () => _executeRequest('Place Order', () => _orderService.placeOrder(
            items: [
              {'product_id': 1, 'quantity': 2},
              {'product_id': 2, 'quantity': 1},
            ],
          )),
        ),
        _buildActionCard(
          title: 'إلغاء طلب رقم 1 (Cancel Order)',
          icon: Icons.cancel,
          color: Colors.orange.shade800,
          onPressed: () => _executeRequest('Cancel Order 1', () => _orderService.cancelOrder('1')),
        ),
        _buildActionCard(
          title: 'إتمام وتأكيد طلب رقم 3 (Complete Order)',
          icon: Icons.check_circle,
          color: Colors.teal,
          onPressed: () => _executeRequest('Complete Order 3', () => _orderService.completeOrder('3')),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: onPressed,
          child: const Text('Send'),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعدادات الاتصال (Config)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Base URL',
                hintText: 'https://example.com/api/',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Bearer Access Token (Manual)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ApiClient.baseUrl = _urlController.text.trim();
                ApiClient.accessToken = _tokenController.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
