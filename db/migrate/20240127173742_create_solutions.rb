class CreateSolutions < ActiveRecord::Migration[7.0]
  def change
    create_table :solutions do |t|
      t.references :test_problem, null: false, foreign_key: true, index: true
      t.string :student_unique_reference, null: false
      t.integer :try, null: false
      t.text :code, null: false

      t.timestamps
    end

    add_index :solutions, [:test_problem_id, :student_unique_reference, :try], unique: true
  end
end
