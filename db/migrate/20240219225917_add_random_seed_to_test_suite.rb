class AddRandomSeedToTestSuite < ActiveRecord::Migration[7.0]
  def change
    add_column :test_suites, :random_seed, :integer, default: -> { 'random() * 100000' }
  end
end
