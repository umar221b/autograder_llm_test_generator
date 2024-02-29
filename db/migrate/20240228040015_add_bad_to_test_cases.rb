class AddBadToTestCases < ActiveRecord::Migration[7.0]
  def change
    add_column :test_cases, :bad, :boolean, null: false, default: false
  end
end
