class AddRejectedFieldsToTestCases < ActiveRecord::Migration[7.0]
  def change
    add_column :test_cases, :rejected, :boolean, null: false, default: false, index: true
    add_column :test_cases, :reference_solution_errors, :text
    change_column_null  :test_cases, :expected_output, true
  end
end
