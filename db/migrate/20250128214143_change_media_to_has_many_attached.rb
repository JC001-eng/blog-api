class ChangeMediaToHasManyAttached < ActiveRecord::Migration[8.0]
  def change
    remove_column :active_storage_attachments, :media, :string
  end
end
