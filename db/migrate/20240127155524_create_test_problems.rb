class CreateTestProblems < ActiveRecord::Migration[7.0]
  def change
    create_table :test_problems do |t|
      t.string :title, null: false, default: 'Untitled Problem'
      t.text :problem_statement, null: false
      t.string :programming_language, null: false
      t.text :reference_solution, null: false
      t.string :reference_solution_digest, null: false, index: true

      t.timestamps
    end

    add_index :test_problems, [:reference_solution_digest, :title], unique: true
  end
end
