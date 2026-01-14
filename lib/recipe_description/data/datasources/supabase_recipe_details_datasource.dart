import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/recipe_details_request.dart';
import '../models/recipe_details_model.dart';
import 'recipe_details_remote_datasource.dart';

class SupabaseRecipeDetailsDataSource implements RecipeDetailsRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseRecipeDetailsDataSource(this.supabaseClient);

  @override
  Future<RecipeDetailsModel> getDetails(RecipeDetailsRequest req) async {
    try {
      final data = await supabaseClient
          .from('recipes')
          .select()
          .eq('id', req.id)
          .single();
      
      return RecipeDetailsModel.fromSupabase(data);
    } catch (e) {
      throw Exception('Failed to load Supabase recipe: $e');
    }
  }
}
