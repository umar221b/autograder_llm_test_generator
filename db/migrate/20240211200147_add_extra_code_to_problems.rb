class AddExtraCodeToProblems < ActiveRecord::Migration[7.0]
  def change
    add_column :problems, :extra_code, :text
  end
end
