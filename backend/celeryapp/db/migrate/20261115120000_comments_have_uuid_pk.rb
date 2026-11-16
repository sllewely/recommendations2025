class CommentsHaveUuidPk < ActiveRecord::Migration[8.1]
  # Reactions reference their reactable by uuid, so comments need a uuid pk to be reactable
  def up
    rename_column :comments, :id, :numeric_id
    rename_column :comments, :uuid, :id

    execute "ALTER TABLE comments DROP CONSTRAINT comments_pkey;"
    execute "ALTER TABLE comments ADD PRIMARY KEY (id);"

    change_column :comments, :numeric_id, :bigint, default: 0, null: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be reverted because column renaming needs to happen first.'
  end
end
