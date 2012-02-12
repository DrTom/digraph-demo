class CreateArcs < ActiveRecord::Migration
  def change

    create_table :arcs do |t|

      t.integer :source_id
      t.integer :target_id

    end

    add_index :arcs, :source_id
    add_index :arcs, :target_id

  end
end
