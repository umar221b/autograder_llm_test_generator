class CreateTestProblems < ActiveRecord::Migration[7.0]
  def change
    create_table :test_problems do |t|
      t.string :title
      t.text :statement, null: false
      t.string :programming_language, null: false
      t.text :reference_solution, null: false

      t.timestamps
    end
  end
end
