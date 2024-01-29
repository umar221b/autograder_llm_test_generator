class CreateTestSuites < ActiveRecord::Migration[7.0]
  def change
    create_table :test_suites do |t|
      t.references :problem, null: false, foreign_key: true, index: true
      t.string :generated_by, null: false

      t.timestamps
    end
  end
end
