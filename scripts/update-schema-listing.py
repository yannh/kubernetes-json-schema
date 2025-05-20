#!/usr/bin/env python3
import os
import json
import argparse

#!/usr/bin/env python3

def main(working_directory: str):
    # Change to the specified working directory
    os.chdir(working_directory)

    result = []
    for filename in os.listdir(os.getcwd()):
        if not filename.endswith(".json"):
            continue
        with open(filename, 'r') as f:
            try:
                data = json.load(f)
                if not "x-kubernetes-group-version-kind" in data:
                    continue
                for entry in data["x-kubernetes-group-version-kind"]:
                    group = entry.get("group", "")
                    kind = entry.get("kind", "")
                    version = entry.get("version", "")
                    api_group = f"{group}/{version}" if group else version
                    result.append({
                        "group": group,
                        "kind": kind,
                        "version": version,
                        "filename": filename,
                        "apiGroup": api_group
                    })
            except json.JSONDecodeError:
                print(f"Skipping invalid JSON file: {filename}")

    with open("index.json", "w") as outfile:
        json.dump(result, outfile, indent=2)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process JSON files in a directory.")
    parser.add_argument(
        "-d", "--directory", type=str, default=os.getcwd(), help="The working directory to process JSON files. Defaults to the current working directory."
    )
    args = parser.parse_args()
    main(args.directory)
