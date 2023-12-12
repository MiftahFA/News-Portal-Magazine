<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\AdminSocialCountStoreRequest;
use App\Http\Requests\AdminSocialCountUpdateRequest;
use App\Models\Language;
use App\Models\SocialCount;

class SocialCountController extends Controller
{

    public function index()
    {
        $languages = Language::all();
        return view('admin.social-count.index', compact('languages'));
    }

    public function create()
    {
        $languages = Language::all();
        return view('admin.social-count.create', compact('languages'));
    }

    public function store(AdminSocialCountStoreRequest $request)
    {
        $socialCount = new SocialCount();
        $socialCount->language = $request->language;
        $socialCount->icon = $request->icon;
        $socialCount->url = $request->url;
        $socialCount->fan_count = $request->fan_count;
        $socialCount->fan_type = $request->fan_type;
        $socialCount->button_text = $request->button_text;
        $socialCount->color = $request->color;
        $socialCount->status = $request->status;
        $socialCount->save();

        toast(__('Created Successfully!'), 'success');
        return redirect()->route('admin.social-count.index');
    }

    public function edit(string $id)
    {
        $languages = Language::all();
        $socialCount = SocialCount::findOrFail($id);
        return view('admin.social-count.edit', compact('languages', 'socialCount'));
    }

    public function update(AdminSocialCountUpdateRequest $request, string $id)
    {
        $socialCount = SocialCount::findOrFail($id);
        $socialCount->language = $request->language;
        $socialCount->icon = $request->icon;
        $socialCount->url = $request->url;
        $socialCount->fan_count = $request->fan_count;
        $socialCount->fan_type = $request->fan_type;
        $socialCount->button_text = $request->button_text;
        $socialCount->color = $request->color;
        $socialCount->status = $request->status;
        $socialCount->save();

        toast(__('Update Successfully!'), 'success');
        return redirect()->route('admin.social-count.index');
    }

    public function destroy(string $id)
    {
        $socialCount = SocialCount::findOrFail($id);
        $socialCount->delete();
        return response(['status' => 'success', 'message' => __('Deleted Successfully!')]);
    }
}
