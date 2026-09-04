    import 'package:flutter/material.dart';
    import 'package:shared_preferences/shared_preferences.dart';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      final prefs = await SharedPreferences.getInstance();
      runApp(InfinitePuzzleApp(prefs: prefs));
    }

    class InfinitePuzzleApp extends StatelessWidget {
      final SharedPreferences prefs;
      const InfinitePuzzleApp({super.key, required this.prefs});
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Infinite Puzzle',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: HomeScreen(prefs: prefs),
        );
      }
    }

    class ProfileAvatar {
      final String id; final String name; final IconData icon; final int price; final Color color;
      ProfileAvatar({required this.id, required this.name, required this.icon, required this.price, required this.color});
    }

    List<ProfileAvatar> generateAvatars() {
      final icons = [Icons.person, Icons.face, Icons.star, Icons.local_fire_department, Icons.flash_on, Icons.shield, Icons.diamond, Icons.rocket_launch, Icons.pets, Icons.psychology];
      final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
      final names = ['Воин', 'Лицо', 'Звезда', 'Огонь', 'Молния', 'Щит', 'Алмаз', 'Ракета', 'Питомец', 'Гений'];
      List<ProfileAvatar> avatars = []; int id = 0;
      for (var icon in icons) {for (var color in colors) {for (var name in names) {avatars.add(ProfileAvatar(id: 'avatar_$id', name: name, icon: icon, price: 50 + (id % 10) * 25, color: color));id++;}}}
      return avatars;
    }

    class HomeScreen extends StatelessWidget {
      final SharedPreferences prefs; const HomeScreen({super.key, required this.prefs});
      @override
      Widget build(BuildContext context) {
        int coins = prefs.getInt('coins')?? 1000;
        return Scaffold(appBar: AppBar(title: const Text('Infinite Puzzle')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Монеты: $coins', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), const SizedBox(height: 30), ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>AvatarShop(prefs: prefs)));}, child: const Text('Магазин Аватаров'))])));
      }
    }

    class AvatarShop extends StatefulWidget {
      final SharedPreferences prefs; const AvatarShop({super.key, required this.prefs});
      @override
      State<AvatarShop> createState() => _AvatarShopState();
    }

    class _AvatarShopState extends State<AvatarShop> {
      late List<ProfileAvatar> avatars; String? selectedAvatarId; int coins = 1000;
      @override
      void initState() {super.initState();avatars = generateAvatars();selectedAvatarId = widget.prefs.getString('selected_avatar');coins = widget.prefs.getInt('coins')?? 1000;}
      void _buyAvatar(ProfileAvatar avatar) {
        if (selectedAvatarId == avatar.id) {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Уже выбран')));return;}
        if (coins >= avatar.price) {setState(() {coins -= avatar.price;selectedAvatarId = avatar.id;});widget.prefs.setInt('coins', coins);widget.prefs.setString('selected_avatar', avatar.id);} 
        else {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не хватает монет')));}
      }
      @override
      Widget build(BuildContext context) {
        return Scaffold(appBar: AppBar(title: Text('Магазин: $coins монет')), body: GridView.builder(padding: const EdgeInsets.all(12), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: avatars.length, itemBuilder: (context, index) {final avatar = avatars[index];final isSelected = avatar.id == selectedAvatarId;return GestureDetector(onTap: ()=>_buyAvatar(avatar),child: Container(decoration: BoxDecoration(color: isSelected? avatar.color.withOpacity(0.2) : Colors.grey[100],border: Border.all(color: isSelected? avatar.color : Colors.grey[300]!, width: 2.5),borderRadius: BorderRadius.circular(16)),child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(avatar.icon, size: 40, color: avatar.color),const SizedBox(height: 8),Text(avatar.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),const SizedBox(height: 6),Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),child: Text('${avatar.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),])));}));
      }
    }
