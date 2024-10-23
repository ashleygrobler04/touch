# myfilecreator/main.py

import argparse
import os
import logging

def main():
    # Argument parsing logic and file creation logic here
    parser = argparse.ArgumentParser(description="Easily create files on Windows via the command line")
    parser.add_argument("fi", help="Name of the file to create in the current working directory")
    parser.add_argument("--content", help="Initial content to write into the file", default="")
    parser.add_argument("--verbose", help="Increase output verbosity", action="store_true")
    arguments = parser.parse_args()

    if arguments.verbose:
        logging.basicConfig(level=logging.INFO)
    else:
        logging.basicConfig(level=logging.WARNING)

    result = createFile(arguments.fi, arguments.content)

    # Print the result
    if result.success:
        print(result.data)
    else:
        print(result.error)

# A result class to avoid exceptions
class Result:
    def __init__(self, success, data, error):
        self.success = success
        self.data = data
        self.error = error

    @classmethod
    def succeed(cls, data):
        return Result(True, data, None)

    @classmethod
    def fail(cls, error):
        return Result(False, None, error)

# Function to create a file with optional content
def createFile(name: str, content: str) -> Result:
    if os.path.exists(name):
        return Result.fail(f"File '{name}' already exists.")
    try:
        with open(name, 'w') as f:
            f.write(content)
        logging.info(f"File '{name}' created with content.")
        return Result.succeed(f"File '{name}' created successfully.")
    except Exception as e:
        return Result.fail(f"Error creating file: {e}")
