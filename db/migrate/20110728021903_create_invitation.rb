class CreateInvitation < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :group_id
      t.string :user_email
      t.string :secure_token

      t.timestamps
    end
  end
end
