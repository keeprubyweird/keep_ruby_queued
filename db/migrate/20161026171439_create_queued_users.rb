class CreateQueuedUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :queued_users, id: :uuid do |t|
      t.string   :name
      t.string   :number
      t.boolean  :confirmed
      t.datetime :finished_at
      t.datetime :notified_at
      t.datetime :queued_at, index: true
      t.string   :confirm_token

      t.timestamps
    end
  end
end
