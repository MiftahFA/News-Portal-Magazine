@extends('admin.layouts.master')
<link rel="stylesheet" href="{{ asset('admin/assets/modules/select2/dist/css/select2.min.css') }}">
<link rel="stylesheet" href="{{ asset('admin/assets/css/bootstrap-iconpicker.min.css') }}">
@section('content')
    <section class="section">
        <div class="section-header">
            <h1>{{ __('Social Links') }}</h1>
        </div>
        <div class="card card-primary">
            <div class="card-header">
                <h4>{{ __('Update Social Link') }}</h4>
            </div>
            <div class="card-body">
                <form action="{{ route('admin.social-link.update', $socialLink->id) }}" method="POST">
                    @csrf
                    @method('PUT')
                    <div class="form-group">
                        <label for="">{{ __('Icon') }}</label>
                        <br>
                        <button class="btn btn-primary" name="icon" data-icon="{{ $socialLink->icon }}" role="iconpicker"
                            data-search="true" data-search-text="Search..." style="height: 40px"></button>
                        @error('icon')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <div class="form-group">
                        <label for="">{{ __('Url') }}</label>
                        <input name="url" type="text" class="form-control" id="name"
                            value="{{ $socialLink->url }}">
                        @error('url')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <div class="form-group">
                        <label for="">{{ __('Status') }}</label>
                        <select name="status" id="" class="form-control">
                            <option {{ $socialLink->status == 1 ? 'selected' : '' }} value="1">
                                {{ __('Active') }}</option>
                            <option {{ $socialLink->status == 0 ? 'selected' : '' }} value="0">
                                {{ __('Inactive') }}</option>
                        </select>
                        @error('status')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <button type="submit" class="btn btn-primary">{{ __('Update') }}</button>
                </form>
            </div>
        </div>
    </section>
@endsection
@push('scripts')
    <script src="{{ asset('admin/assets/modules/select2/dist/js/select2.full.min.js') }}"></script>
    <script src="{{ asset('admin/assets/js/bootstrap-iconpicker.bundle.min.js') }}"></script>
@endpush
