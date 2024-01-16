class DeleteValuesFromX100Tickets < ActiveRecord::Migration[7.0]
  def change
    remove_column :x100_tickets, :is_sold
    remove_column :x100_tickets, :ticket_number
    remove_column :x100_tickets, :perform_at
  end
end
