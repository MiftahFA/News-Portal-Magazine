<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\AdminProfileUpdateRequest;
use App\Http\Requests\AdminUpdatePasswordRequest;
use App\Models\Admin;
use App\Traits\FileUploadTrait;
use Illuminate\Support\Facades\Auth;

class ProfileController extends Controller
{
    use FileUploadTrait;

    public function index()
    {
        $user = Auth::guard('admin')->user();
        return view('admin.profile.index', compact('user'));
    }

    public function update(AdminProfileUpdateRequest $request, string $id)
    {
        $imagePath = $this->handleFileUpload($request, 'image', $request->old_image);
        $admin = Admin::findOrFail($id);
        $admin->image = !empty($imagePath) ? $imagePath : $request->old_image;
        $admin->name = $request->name;
        $admin->email = $request->email;
        $admin->save();
        toast(__('Updated Succesfully'), 'success')->width('400');
        return redirect()->back();
    }

    public function passwordUpdate(AdminUpdatePasswordRequest $request, string $id)
    {
        $admin = Admin::findOrFail($id);
        $admin->password = bcrypt($request->password);
        $admin->save();

        toast(__('Updated Succesfully'), 'success')->width('400');
        return redirect()->back();
    }
}
