<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\AdminLanguageStoreRequest;
use App\Http\Requests\AdminLanguageUpdateRequest;
use App\Models\Language;

class LanguageController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:languages index,admin'])->only(['index']);
        $this->middleware(['permission:languages create,admin'])->only(['create']);
        $this->middleware(['permission:languages update,admin'])->only(['update']);
        $this->middleware(['permission:languages delete,admin'])->only(['destroy']);
    }

    public function index()
    {
        $languages = Language::all();
        return view('admin.language.index', compact('languages'));
    }

    public function create()
    {
        return view('admin.language.create');
    }

    public function store(AdminLanguageStoreRequest $request)
    {
        $language = new Language();
        $language->name = $request->name;
        $language->lang = $request->lang;
        $language->slug = $request->slug;
        $language->default = $request->default;
        $language->status = $request->status;
        $language->save();

        toast(__('Created Successfully'), 'success')->width('350');
        return redirect()->route('admin.language.index');
    }

    public function edit(string $id)
    {
        $language = Language::findOrFail($id);
        return view('admin.language.edit', compact('language'));
    }

    public function update(AdminLanguageUpdateRequest $request, string $id)
    {
        $language = Language::findOrFail($id);
        $language->name = $request->name;
        $language->lang = $request->lang;
        $language->slug = $request->slug;
        $language->default = $request->default;
        $language->status = $request->status;
        $language->save();

        toast(__('Updated Successfully'), 'success')->width('350');
        return redirect()->route('admin.language.index');
    }

    public function destroy(string $id)
    {
        try {
            $language = Language::findOrFail($id);
            if ($language->lang === 'en') {
                return response(['status' => 'error', 'message' => __('Can\'t Delete This One!')]);
            }
            $language->delete();
            return response(['status' => 'success', 'message' => __('Deleted Successfully!')]);
        } catch (\Throwable $th) {
            return response(['status' => 'error', 'message' => __('something went wrong!')]);
        }
    }
}
