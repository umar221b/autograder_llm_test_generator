class PromptTemplates
  DETAILED_PROBLEM_STATEMENT =
"""
Here is a step-by-step guide that you should follow to answer me.

You are going to receive a programming problem description along with its optimal solution. You are required to respond with a detailed problem statement based on the provided description and solution. The detailed problem statement must only have the following 5 sections: The problem scenario, the problem inputs, the problem outputs, an example, and a limits section that contains any memory limits, time limits, or code complexity limits that are defined in the problem description or can be infered from the optimal solution. If you cannot generate an example, just fill the Example section with \"None\". If there are no limits defined in the problem description and you could not infer the limits from the optimal solution, just fill the section with \"Not Available\".

After you provide the detailed problem statement, please reflect on it to make sure the sections in it correctly represent the problem. If there are any mistakes point them out.

After you finish the reflection, please take into account the feedback from the reflection, and fix any issues in the detailed problem statement that you generated.

Finally, use the following format to print the final improved detailed problem statement. If the feedback did not improve the detailed problem statement, print the detailed problem statement anyway.

Here is the format:
Print a native JSON object that only contains the following keys: \"scenario\", \"inputs\", \"outputs\", \"example\", \"limits\". The value of each key must be a string that corresponds to the appropriate value from the detailed problem statement. The JSON object must not have any comments in it.
"""

  INPUTS =
"""
Here is a step-by-step guide that you should follow to answer me.

You are going to receive a programming problem description. The problem description begins with the Scenario Section that describes the problem, it is then followed by the Input Format Section that describes the input of the problem, then by the Output Format Section that describes the output of the problem, then by an optional Example Section that may have an example, and then by an optional Limits Section that describes the problem's memory limits, time limits, and code complexity limits if any, then finally by the Optimal Solution Section which contains the problem's optimal solution. You are required to respond with the description of edge cases that test the problem based on its input limits and constraints that are present in the Input Format and the Limits Sections. With each edge case description, generate a plain text example for that edge case.

After you generate the edge cases, please reflect on them to make sure they cover all edge cases, and double check that the each plain text example actually conforms to its edge case description. If there are any mistakes point them out.

After you finish the reflection, please take into account the feedback from the reflection, and fix any issues in the edge cases or their plain text examples.

Finally, provide a native JSON output that contains all the improved edge cases in addition to another 20 completely random test cases, if possible. The input of the random test cases you generate must be within any limits defined in the Input Format Section in the problem description. The native JSON file must start with an array at the root that contains the cases. Each case has only one key: \"input\" which is a string that contains all the input. Do not include the output of the case in your response. The inputs should be ready as is without any further computation or evaluation. Do not add comments inside the JSON.
"""


  UNIT_TESTS =
"""
Here is a step-by-step guide that you should follow to answer me.

You are going to receive a programming problem description. The problem description begins with the Scenario Section that describes the problem, it is then followed by the Input Format Section that describes the input of the problem, then by the Output Format Section that describes the output of the problem, then by an optional Example Section that may have an example, and then by an optional Limits Section that describes the problem's memory limits, time limits, and code complexity limits if any, then finally by the Optimal Solution Section which contains the problem's optimal solution. You are required to respond with the description of edge cases that test the problem based on its input limits and constraints that are present in the Input Format and the Limits Sections.

After you generate the edge case descriptions, please reflect on them to make sure they cover all edge cases. If there are any mistakes point them out.

After you finish the reflection, please take into account the feedback from the reflection, and fix any issues in the edge cases.

Finally, provide python3 code that contains unit tests for the problem that cover all the improved edge cases in addition to another 20 completely random test cases, if possible. The input of the random test cases you generate must be within any limits defined in the Input Format Section or the Limits Section in the problem description. Import the solution to be tested from a file called \"solution\". Make sure you write a separate function for each test. Do not attempt to fix the optimal solution if the tests fail.
"""
end