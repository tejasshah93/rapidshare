# Class CreateDocuments
class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :title
      t.string :doc_path
      t.boolean :is_private, default: true
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
