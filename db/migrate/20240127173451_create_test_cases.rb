class CreateTestCases < ActiveRecord::Migration[7.0]
  def change
    create_table :test_cases do |t|
      t.references :test_suite, null: false, foreign_key: true, index: true
      t.text :test, null: false
      t.text :expected_output, null: false

      t.timestamps
    end
  end
end
