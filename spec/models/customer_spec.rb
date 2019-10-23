require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "supports soft-delete" do
    it "is hidden from default scope after destroy" do
      customer = create(:customer)

      customer.destroy

      expect {
        Customer.find(customer.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is available from with_deleted scope after destroy" do
      customer = create(:customer)

      customer.destroy

      found_customer = Customer.with_deleted.find(customer.id)

      expect(found_customer).to eq customer
    end
  end
end
