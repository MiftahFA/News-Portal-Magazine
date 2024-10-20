<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\AdminCategoryCreateRequest;
use App\Http\Requests\AdminCategoryUpdateRequest;
use App\Models\Category;
use App\Models\Language;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class CategoryController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:category index,admin'])->only('index');
        $this->middleware(['permission:category create,admin'])->only(['create', 'store']);
        $this->middleware(['permission:category update,admin'])->only(['edit', 'update']);
        $this->middleware(['permission:category delete,admin'])->only('delete');
    }

    public function index()
    {
        $languages = Language::all();
        return view('admin.category.index', compact('languages'));
    }

    public function create()
    {
        $languages = Language::all();
        return view('admin.category.create', compact('languages'));
    }

    public function store(AdminCategoryCreateRequest $request)
    {
        $category = new Category();
        $category->name = $request->name;
        $category->slug = Str::slug($request->name);
        $category->language = $request->language;
        $category->show_at_nav = $request->show_at_nav;
        $category->status = $request->status;
        $category->save();

        toast(__('Created Successfully'), 'success')->width('350');
        return redirect()->route('admin.category.index');
    }

    public function edit(string $id)
    {
        $languages = Language::all();
        $category = Category::findOrFail($id);
        return view('admin.category.edit', compact('languages', 'category'));
    }

    public function update(AdminCategoryUpdateRequest $request, string $id)
    {
        $category = Category::findOrFail($id);
        $category->name = $request->name;
        $category->slug = Str::slug($request->name);
        $category->language = $request->language;
        $category->show_at_nav = $request->show_at_nav;
        $category->status = $request->status;
        $category->save();

        toast(__('Update Successfully'), 'success')->width('350');
        return redirect()->route('admin.category.index');
    }

    public function destroy(string $id)
    {
        try {
            $category = Category::findOrFail($id);
            // $news = News::where('category_id', $category->id)->get();
            // foreach ($news as $item) {
            //     $item->tags()->delete();
            // }
            $category->delete();
            return response(['status' => 'success', 'message' => __('Deleted Successfully!')]);
        } catch (\Throwable $th) {
            return response(['status' => 'error', 'message' => __('Someting went wrong!')]);
        }
    }
}
