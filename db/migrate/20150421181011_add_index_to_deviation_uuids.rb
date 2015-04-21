class AddIndexToDeviationUuids < ActiveRecord::Migration
  def change
    add_index :deviations, :uuid
  end
end
