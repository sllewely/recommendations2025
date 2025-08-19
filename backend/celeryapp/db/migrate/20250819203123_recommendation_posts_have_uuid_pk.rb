class RecommendationPostsHaveUuidPk < ActiveRecord::Migration[8.0]
  def up
    rename_column :posts, :id, :numeric_id
    rename_column :posts, :uuid, :id
    rename_column :recommendations, :id, :numeric_id
    rename_column :recommendations, :uuid, :id

    change_pk(:posts)
    change_pk(:recommendations)
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be reverted because column renaming needs to happen first.'
  end

  def change_pk(table)
    execute "ALTER TABLE #{table} DROP CONSTRAINT #{table}_pkey;"
    execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
  end
end
