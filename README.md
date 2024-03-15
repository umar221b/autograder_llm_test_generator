# Autograding Using LLMs

## Workflow

1. Instructor provides problem statement, reference solution, and any extra code
2. Reference solution is required
    1. Provided by instructor
    2. Generated by AI, but approved/edited by instructor (not implemented)
3. Find problem type: Test case inputs (full-program) / Unit Tests (function-implementation), or have the instructor select it (currently the instructor selects it). "Unit Tests" is no longer the right way to describe this type of grading.
4. Find assignment's programming language, or have the instructor select it (currently the instructor selects it)
5. LLM: Generate detailed problem description from the provided problem description, reference solution, and extra code
6. LLM: Generate test cases based on the detailed problem description and the reference solution:
    1. Find edge cases
    2. Reflect on their correctness and coverage 
    3. Generate tests (edge + random)
       - For full-programs: Tests are only inputs.
       - For unit tests:
         - Python (not fully implemented): tests compare the result of calling the student's function with the result of calling the reference solution on the same input
         - C: tests call the tested function and print its result to standard output
       - Note: The LLM was not able to run the reference solution to generate the outputs. It expects wrong outputs for the tests, even when it says it did run the solution to generate the expected outputs
7. Run tests and drop any test that crashes the reference solution

## Security Concerns

Instructor and LLM generated code must be run inside a sandbox to avoid any unauthorized access to the host machine.