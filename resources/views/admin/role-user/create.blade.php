@extends('admin.layouts.master')
<link rel="stylesheet" href="{{ asset('admin/assets/modules/select2/dist/css/select2.min.css') }}">
@section('content')
    <section class="section">
        <div class="section-header">
            <h1>{{ __('Role User') }}</h1>
        </div>
        <div class="card card-primary">
            <div class="card-header">
                <h4>{{ __('Create User with Role') }}</h4>
            </div>
            <div class="card-body">
                <form action="{{ route('admin.role-users.store') }}" method="POST">
                    @csrf
                    <div class="form-group">
                        <label for="">{{ __('User Name') }}</label>
                        <input type="text" class="form-control" name="name">
                        @error('name')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <div class="form-group">
                        <label for="">{{ __('Email') }}</label>
                        <input type="text" class="form-control" name="email">
                        @error('email')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <div class="form-group">
                        <label for="">{{ __('Password') }}</label>
                        <input type="password" class="form-control" name="password">
                        @error('password')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <div class="form-group">
                        <label for="">{{ __(' Confirm Password') }}</label>
                        <input type="password" class="form-control" name="password_confirmation">
                        @error('password_confirmation')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <div class="form-group">
                        <label for="">{{ __('Role') }}</label>
                        <select name="role" id="" class="select2 form-control">
                            <option value="">{{ __('--Select--') }}</option>
                            @foreach ($roles as $role)
                                <option value="{{ $role->name }}">{{ $role->name }}</option>
                            @endforeach
                        </select>
                        @error('role')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <button type="submit" class="btn btn-primary">{{ __('Create') }}</button>
                </form>
            </div>
        </div>
    </section>
@endsection

@push('scripts')
    <script src="{{ asset('admin/assets/modules/select2/dist/js/select2.full.min.js') }}"></script>
@endpush
