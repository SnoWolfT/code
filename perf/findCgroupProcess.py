import os

def find_and_display_nonempty_cgroup_procs_files(directory):
    cgroup_procs_files = []
    for root, _, files in os.walk(directory):
        for filename in files:
            if filename == "cgroup.procs":
                file_path = os.path.abspath(os.path.join(root, filename))
                cgroup_procs_files.append(file_path)

    if not cgroup_procs_files:
        print("No cgroup.procs files found in the directory.")
        return

    print("Found non-empty cgroup.procs files:")
    for file_path in cgroup_procs_files:
        with open(file_path, "r") as file:
            content = file.read().strip()
            if content:
                print("File:", file_path)
                print("Content:")
                print(content)
                print("-" * 30)

if __name__ == "__main__":
    target_directory = "/sys/fs/cgroup"
    find_and_display_nonempty_cgroup_procs_files(target_directory)
