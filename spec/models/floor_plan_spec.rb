require 'rails_helper'

RSpec.describe FloorPlan, type: :model do
  describe "supports soft-delete" do
    before(:each) do
      @floor_plan = create(:floor_plan)
    end

    it "is hidden from default scope after destroy" do
      @floor_plan.destroy

      expect {
        FloorPlan.find(@floor_plan.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is available from with_deleted scope after destroy" do
      @floor_plan.destroy

      found = FloorPlan.with_deleted.find(@floor_plan.id)

      expect(found).to eq @floor_plan
    end
  end
end
