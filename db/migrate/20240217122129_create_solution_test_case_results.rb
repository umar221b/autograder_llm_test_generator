class CreateSolutionTestCaseResults < ActiveRecord::Migration[7.0]
  def change
    create_table :solution_test_case_results do |t|
      t.references :solution, null: false, foreign_key: true, index: true
      t.references :test_case, null: false, foreign_key: true, index: true
      t.text :output
      t.text :runtime_errors

      t.timestamps
    end

    add_index :solution_test_case_results, [:solution_id, :test_case_id], unique: true, name: 'unique_solution_test_case_result'
    remove_index :solution_test_suite_grades, [:test_suite_id, :solution_id]
    add_index :solution_test_suite_grades, [:test_suite_id, :solution_id], unique: true, name: 'solution_test_suite_index'
  end
end
