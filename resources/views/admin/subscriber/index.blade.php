@extends('admin.layouts.master')
<link rel="stylesheet" href="{{ asset('admin/assets/modules/datatables/datatables.min.css') }}">
<link rel="stylesheet"
    href="{{ asset('admin/assets/modules/datatables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css') }}">
@section('content')
    <section class="section">
        <div class="section-header">
            <h1>{{ __('Subscribers') }}</h1>
        </div>
        <div class="card card-primary">
            <div class="card-header">
                <h4>{{ __('Send Mail To Subscribers') }}</h4>

            </div>
            <div class="card-body">
                <form action="{{ route('admin.subscribers.store') }}" method="POST">
                    @csrf
                    <div class="form-group">
                        <label for="">{{ __('Subject') }}</label>
                        <input type="text" class="form-control" name="subject">
                        @error('subject')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <div class="form-group">
                        <label for="">{{ __('Message') }}</label>
                        <textarea name="message" class="summernote" id="" cols="30" rows="10"></textarea>
                        @error('message')
                            <p class="text-danger">{{ $message }}</p>
                        @enderror
                    </div>
                    <button type="submit" class="btn btn-primary">{{ __('Send') }}</button>
                </form>
            </div>
        </div>
    </section>
    <section class="section">
        <div class="card card-primary">
            <div class="card-header">
                <h4>{{ __('All Subscribers') }}</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="table-sub">
                        <thead>
                            <tr>
                                <th class="text-center">
                                    #
                                </th>
                                <th>{{ __('Email') }}</th>
                                <th>{{ __('Action') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($subs as $sub)
                                <tr>
                                    <td class="text-center">{{ $loop->iteration }}</td>
                                    <td>{{ $sub->email }}</td>
                                    <td>
                                        <a href="{{ route('admin.subscribers.destroy', $sub->id) }}"
                                            class="btn btn-danger delete-item"><i class="fas fa-trash-alt"></i></a>
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
            $("#table-sub").dataTable({
                "columnDefs": [{
                    "sortable": false,
                    "targets": [1]
                }]
            });

            $('.delete-item').on('click', function(e) {
                e.preventDefault();
                swal({
                        title: 'Are you sure?',
                        text: "You won't be able to revert this!",
                        icon: 'warning',
                        buttons: true,
                        dangerMode: true,
                    })
                    .then((willDelete) => {
                        if (willDelete) {
                            let url = $(this).attr('href');
                            $.ajax({
                                method: 'DELETE',
                                url: url,
                                success: function(data) {
                                    if (data.status === 'success') {
                                        swal({
                                            title: data.message,
                                            icon: 'success',
                                        }).then(() => {
                                            location.reload();
                                        });
                                    } else if (data.status === 'error') {
                                        swal({
                                            title: data.message,
                                            icon: 'error',
                                        });
                                    }
                                },
                                error: function(xhr, status, error) {
                                    console.error(error);
                                }
                            });
                        }
                    });
            });
        })
    </script>
@endpush
