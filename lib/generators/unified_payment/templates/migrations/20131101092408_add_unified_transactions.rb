class AddUnifiedTransactions < ActiveRecord::Migration
  def change
    create_table :unified_transactions do |t|
      t.integer :gateway_order_id
      t.string :gateway_session_id
      t.string :url
      t.string :merchant_id
    end

    add_index :unified_transactions, [:gateway_order_id, :gateway_session_id], name: :order_session_index
  end
end
