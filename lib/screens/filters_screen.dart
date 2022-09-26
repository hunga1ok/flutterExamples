import 'package:flutter/material.dart';
import 'package:meal_app/widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _lactoseFree = false;

  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    void Function(bool) updateValue,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      value: currentValue,
      subtitle: Text(description),
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              _buildSwitchListTile(
                'Gluten-free',
                'Only include gluten-free meals.',
                _glutenFree,
                (newValue) {
                  setState(() {
                    _glutenFree = newValue;
                  });
                },
              ),
              _buildSwitchListTile(
                'Lactose-free',
                'Only include lactose-free meals',
                _lactoseFree,
                (newValue) {
                  setState(() {
                    _lactoseFree = newValue;
                  });
                },
              ),
              _buildSwitchListTile(
                'Vegetarian',
                'Only include vegetarian meals',
                _vegetarian,
                (newValue) {
                  setState(() {
                    _vegetarian = newValue;
                  });
                },
              ),
              _buildSwitchListTile(
                'Vegan',
                'Only include vegan meals',
                _vegan,
                (newValue) {
                  setState(() {
                    _vegan = newValue;
                  });
                },
              )
            ],
          ))
        ],
      ),
    );
  }
}
