<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\AdminRolePermissionCreateRequest;
use App\Http\Requests\AdminRolePermissionUpdateRequest;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class RolePermissionController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:access management index,admin'])->only(['index']);
        $this->middleware(['permission:access management create,admin'])->only(['create', 'store']);
        $this->middleware(['permission:access management update,admin'])->only(['edit', 'update']);
        $this->middleware(['permission:access management destroy,admin'])->only(['destroy']);
    }

    public function index()
    {
        $roles = Role::all();
        return view('admin.role.index', compact('roles'));
    }

    public function create()
    {
        $permissions = Permission::all()->groupBy('group_name');
        return view('admin.role.create', compact('permissions'));
    }

    public function store(AdminRolePermissionCreateRequest $request)
    {
        /** create the role */
        $role = Role::create(['guard_name' => 'admin', 'name' => $request->role]);

        /** assgin permissions to the role */
        $role->syncPermissions($request->permissions);

        toast(__('Created Successfully'), 'success');
        return redirect()->route('admin.role.index');
    }

    public function edit(string $id)
    {
        $permissions = Permission::all()->groupBy('group_name');
        $role = Role::findOrFail($id);
        $rolesPermissions = $role->permissions->pluck('name')->toArray();
        return view('admin.role.edit', compact('permissions', 'role', 'rolesPermissions'));
    }

    public function update(AdminRolePermissionUpdateRequest $request, string $id)
    {
        /** create the role */
        $role = Role::findOrFail($id);
        $role->update(['guard_name' => 'admin', 'name' => $request->role]);

        /** assgin permissions to the role */
        $role->syncPermissions($request->permissions);

        toast(__('Update Successfully'), 'success');
        return redirect()->route('admin.role.index');
    }

    public function destroy(Request $request)
    {
        $role = Role::findOrFail($request->id);
        if ($role->name === 'Super Admin') {
            return response(['status' => 'error', 'message' => __('Can\'t Delete the Super Admin')]);
        }

        $role->delete();
        return response(['status' => 'success', 'message' => __('Deleted Successfully')]);
    }
}
