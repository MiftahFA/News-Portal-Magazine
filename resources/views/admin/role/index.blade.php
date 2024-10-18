@extends('admin.layouts.master')
<link rel="stylesheet" href="{{ asset('admin/assets/modules/datatables/datatables.min.css') }}">
<link rel="stylesheet"
    href="{{ asset('admin/assets/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css') }}">
@section('content')
    <section class="section">
        <div class="section-header">
            <h1>{{ __('Roles and Permission') }}</h1>
        </div>

        <div class="card card-primary">
            <div class="card-header">
                <h4>{{ __('Roles and Permission') }}</h4>
                <div class="card-header-action">
                    <a href="{{ route('admin.role.create') }}" class="btn btn-primary">
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
                                <th>{{ __('Role Name') }}</th>
                                <th>{{ __('Permissions') }}</th>
                                <th>{{ __('Action') }}</th>

                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($roles as $role)
                                <tr>
                                    <td class="text-center">{{ $loop->iteration }}</td>
                                    <td>{{ $role->name }}</td>
                                    <td>
                                        @foreach ($role->permissions as $permission)
                                            <span class="badge bg-primary text-light">{{ $permission->name }}</span>
                                        @endforeach
                                        @if ($role->name === 'Super Admin')
                                            <span class="badge bg-danger text-light">{{ __('All Permissions') }}
                                                *</span>
                                        @endif
                                    </td>
                                    <td>
                                        @if ($role->name != 'Super Admin')
                                            <a href="{{ route('admin.role.edit', $role->id) }}" class="btn btn-primary"><i
                                                    class="fas fa-edit"></i></a>
                                            <a href="javascript:void(0);" class="btn btn-danger delete-item"
                                                data-id="{{ $role->id }}"><i class="fas fa-trash-alt"></i></a>
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
        $(document).ready(function() {
            $("#table").dataTable({
                "columnDefs": [{
                    "sortable": false,
                    "targets": [2, 3]
                }]
            });

            $('.delete-item').on('click', function(e) {
                e.preventDefault();
                let id = $(this).data('id');
                swal({
                    title: '{{ __('Are you sure?') }}',
                    text: "{!! __("You won't be able to revert this!") !!}",
                    icon: 'warning',
                    buttons: {
                        confirm: {
                            text: '{{ __('Yes, delete it!') }}',
                            confirmButtonColor: '#3085d6'
                        },
                        cancel: {
                            text: '{{ __('No, cancel!') }}',
                            visible: true,
                            cancelButtonColor: '#d33'
                        }
                    },
                    dangerMode: true
                }).then((willDelete) => {
                    if (willDelete) {
                        $.ajax({
                            method: 'DELETE',
                            url: "{{ route('admin.role.destroy') }}",
                            data: {
                                id: id
                            },
                            success: function(data) {
                                if (data.status === 'success') {
                                    swal({
                                        title: data.message,
                                        icon: 'success',
                                    }).then(() => {
                                        location.reload();
                                    });
                                } else if (data.status === 'error') {
                                    swal(data.message, {
                                        icon: 'error',
                                    });
                                }
                            },
                            error: function(xhr, status, error) {
                                console.error(error);
                            }
                        });
                    }
                })
            })
        });
    </script>
@endpush
