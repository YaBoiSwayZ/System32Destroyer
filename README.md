# File Corruption and Management Destruction

## Overview

This script is designed to recursively process all files in a specified directory and either corrupt, delete, or move them. The corruption process introduces significant errors into the files, making them largely unusable. The script operates without the need for elevated privileges (UAC) by leveraging Windows native tools like `certutil`, `icacls`, and `move`.

## Features

- **Recursive File Processing:** The script processes all files within a specified directory and its subdirectories.
- **File Corruption:** Files are corrupted by introducing random noise during a base64 encode-decode roundtrip.
- **File Deletion:** Instead of traditional deletion, the script denies all access permissions to files, rendering them inaccessible.
- **File Renaming and Moving:** Files can be renamed and moved with a specified prefix to a new location in the same directory.

## Usage
- FOR VIRTUAL MACHINE USAGE/EDUCATIONAL PURPOSES ONLY, OTHERWISE DO NOT USE IT.

### Prerequisites

- **Windows Operating System:** The script is designed to run on Windows.
- **Permissions:** The script requires that the user has write access to the files and directories being processed. (WORKING ON A BYPASS)

### Running the Script

1. **Download or Copy the Script:**
   - Save the script as a `.bat` file, for example, `Destroy.bat`.

2. **Edit the Script:**
   - Modify the `target_directory` variable to point to the directory you wish to process. Example:
     ```
     set "target_directory=C:\Windows\System32"
     ```

3. **Run the Script:**
   - Double-click the `.bat` file or run it from the command prompt. The script will begin processing all files within the specified directory.

### Example

If you set the `target_directory` to `C:\Windows\System32`, the script will:

- Traverse all files in `C:\Windows\System32` and its subdirectories/folders.
- Corrupt each file by modifying its contents during an encode-decode roundtrip.
- Randomly decide whether to either:
  - Deny all access permissions to the file (effectively deleting it without UAC).
  - Move the file within the same directory and rename it with an `evil_` prefix. (Update in the works for files to be forcefully moved to a random location on C:\ and removed from the file system index using `"..\%~n0" " "`)

## How It Works

### 1. Corrupting Files
The script uses `certutil` to encode the file into base64 and then deliberately introduces errors into the encoded content before decoding it back to the original format. This process results in a corrupted version of the original file.

### 2. Deleting Files
Instead of deleting files outright, the script uses `icacls` to remove all permissions from the file, making it inaccessible to any user, effectively "deleting" it without requiring elevated privileges.

### 3. Moving and Renaming Files
For files that are not "deleted," the script renames them with an `evil_` prefix and moves them to a new location within the same directory, ensuring they remain available but identifiable as processed.

## Important Notes

- **Data Loss:** Running this script will result in irreversible data corruption or loss. Ensure that you understand the consequences before executing it on important files.
- **No UAC Prompt:** The script is designed to operate without triggering User Account Control (UAC) prompts by using `icacls` instead of standard deletion commands.
- **Testing:** It is highly recommended to test the script in a controlled environment before using it on any critical data.

## Disclaimer

This script is provided "as is," without warranty of any kind. The author is not responsible for any damages or data loss that may occur from using this script. Use at your own risk.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
