import os
import subprocess

# ------------------------------
# User Configuration
# ------------------------------
output_dir = "sim_results"
merged_ucdb = os.path.join(output_dir, "merged.ucdb")
coverage_report_dir = os.path.join(output_dir, "coverage_report")

vcover_exec = "vcover"  # QuestaSim coverage utility

# ------------------------------
# Collect all UCDB files
# ------------------------------
ucdb_files = []
for root, dirs, files in os.walk(output_dir):
    for file in files:
        if file.endswith(".ucdb"):
            ucdb_files.append(os.path.join(root, file))

if not ucdb_files:
    print("No UCDB files found to merge!")
    exit(1)

print("UCDB files to merge:")
for ucdb in ucdb_files:
    print(f"  {ucdb}")

# ------------------------------
# Merge UCDB files
# ------------------------------
merge_cmd = [vcover_exec, "merge", merged_ucdb] + ucdb_files
print(f"\nRunning merge command: {' '.join(merge_cmd)}")
result = subprocess.run(merge_cmd)

if result.returncode != 0:
    print("UCDB merge failed!")
    exit(1)

print(f"Merged UCDB created: {merged_ucdb}")

# ------------------------------
# Generate coverage report
# ------------------------------
os.makedirs(coverage_report_dir, exist_ok=True)
report_cmd = [vcover_exec, "report", merged_ucdb, "-html", "-output", coverage_report_dir]
print(f"\nGenerating coverage report: {' '.join(report_cmd)}")
result = subprocess.run(report_cmd)

if result.returncode != 0:
    print("Coverage report generation failed!")
    exit(1)

print(f"Coverage report generated in: {coverage_report_dir}")

