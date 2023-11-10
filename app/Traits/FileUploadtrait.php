<?php

namespace App\Traits;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;

trait FileUploadTrait
{
    public function handleFileUpload(Request $request, string $fieldName, ?string $oldPath = null, string $dir = "uploads"): ?string
    {
        // Check if the request has the file
        if (!$request->hasFile($fieldName)) {
            return null;
        }

        // Delete the existing file if it exists
        if ($oldPath && File::exists(public_path($oldPath))) {
            File::delete(public_path($oldPath));
        }

        $file = $request->file($fieldName);
        $extension = $file->getClientOriginalExtension();
        $uploadFileName = Str::random(30) . '.' . $extension;
        $file->move(public_path($dir), $uploadFileName);

        return $dir . '/' . $uploadFileName;
    }
}
