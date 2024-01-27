class CreateSolutionTestSuiteGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :solution_test_suite_grades do |t|
      t.references :test_suite, null: false, foreign_key: true, index: true
      t.references :solution, null: false, foreign_key: true, index: true
      t.float :grade, null: false

      t.timestamps
    end

    add_index :solution_test_suite_grades, [:test_suite_id, :solution_id]
  end
end
