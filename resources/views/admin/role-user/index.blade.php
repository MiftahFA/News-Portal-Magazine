@extends('admin.layouts.master')
<link rel="stylesheet" href="{{ asset('admin/assets/modules/datatables/datatables.min.css') }}">
<link rel="stylesheet"
    href="{{ asset('admin/assets/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css') }}">
@section('content')
    <section class="section">
        <div class="section-header">
            <h1>{{ __('Roles Users') }}</h1>
        </div>

        <div class="card card-primary">
            <div class="card-header">
                <h4>{{ __('All Role Users') }}</h4>
                <div class="card-header-action">
                    <a href="{{ route('admin.role-users.create') }}" class="btn btn-primary">
                        <i class="fas fa-plus"></i> {{ __('Create new') }}
                    </a>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="table">
                        <thead>
                            <tr>
                                <th class="text-center">
                                    #
                                </th>
                                <th>{{ __('Name') }}</th>
                                <th>{{ __('Email') }}</th>
                                <th>{{ __('Role') }}</th>
                                <th>{{ __('Action') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($admins as $admin)
                                <tr>
                                    <td class="text-center">{{ $loop->iteration }}</td>
                                    <td>{{ $admin->name }}</td>
                                    <td>{{ $admin->email }}</td>
                                    <td><span
                                            class="badge bg-primary text-light">{{ $admin->getRoleNames()->first() }}</span>
                                    </td>
                                    <td>
                                        @if ($admin->getRoleNames()->first() != 'Super Admin')
                                            <a href="{{ route('admin.role-users.edit', $admin->id) }}"
                                                class="btn btn-primary"><i class="fas fa-edit"></i></a>
                                            <a href="{{ route('admin.role-users.destroy', $admin->id) }}"
                                                class="btn btn-danger delete-item"><i class="fas fa-trash-alt"></i></a>
                                        @endif
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
@endsection

@push('scripts')
    <script src="{{ asset('admin/assets/modules/datatables/datatables.min.js') }}"></script>
    <script src="{{ asset('admin/assets/modules/datatables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js') }}">
    </script>
    <script src="{{ asset('admin/assets/modules/sweetalert/sweetalert.min.js') }}"></script>
    <script>
        $("#table").dataTable({
            "columnDefs": [{
                "sortable": false,
                "targets": [4]
            }]
        });
    </script>
@endpush
