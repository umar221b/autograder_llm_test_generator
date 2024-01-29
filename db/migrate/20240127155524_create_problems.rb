class CreateProblems < ActiveRecord::Migration[7.0]
  def change
    create_table :problems do |t|
      t.string :title, null: false, default: 'Untitled Problem'
      t.text :statement, null: false
      t.string :programming_language, null: false
      t.string :test_type, null: false
      t.text :reference_solution, null: false
      t.string :reference_solution_digest, null: false, index: true

      t.timestamps
    end
  end
end
