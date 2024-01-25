import sys
import re

def replace_values(input_file, output_file, substitutions):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            for find_value, replace_value in substitutions:
                # Use regular expression with word boundaries to ensure whole-word match
                line = re.sub(r'\b{}\b'.format(re.escape(find_value)), replace_value, line)
            outfile.write(line)

def main():
    # Check if the correct number of command-line arguments is provided
    if len(sys.argv) != 4:
        print("Usage: python script.py input_file output_file substitution_file")
        sys.exit(1)

    # Get command-line arguments
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    substitution_file = sys.argv[3]

    # Read substitution pairs from the substitution file
    try:
        with open(substitution_file, 'r') as subs_file:
            substitutions = [line.split() for line in subs_file]
    except FileNotFoundError:
        print(f"Error: Substitution file '{substitution_file}' not found.")
        sys.exit(1)

    # Perform text replacement with whole-word matching
    replace_values(input_file, output_file, substitutions)

    print(f"Text replacement completed successfully. Output written to '{output_file}'.")

if __name__ == "__main__":
    main()
