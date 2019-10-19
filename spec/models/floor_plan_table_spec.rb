require 'rails_helper'

RSpec.describe FloorPlanTable, type: :model do
  describe "supports soft-delete" do
    before(:each) do
      @floor_plan_table = create(:floor_plan_table)
    end

    it "is hidden from default scope after destroy" do
      @floor_plan_table.destroy

      expect {
        FloorPlanTable.find(@floor_plan_table.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is available from with_deleted scope after destroy" do
      @floor_plan_table.destroy

      found = FloorPlanTable.with_deleted.find(@floor_plan_table.id)

      expect(found).to eq @floor_plan_table
    end
  end

  describe "validations" do
    describe "prevents identically-numbered tables for same floor plan" do
      it "allows tables to have same number in different floor plans" do
        restaurant = create(:restaurant)
        floor_plan_1 = create(:floor_plan, restaurant: restaurant)
        floor_plan_2 = create(:floor_plan, restaurant: restaurant)

        floor_plan_1_table_1 = create(
          :floor_plan_table,
          floor_plan: floor_plan_1,
          table_number: '1'
        )
        floor_plan_2_table_1 = create(
          :floor_plan_table,
          floor_plan: floor_plan_2,
          table_number: '1'
        )
      end

      it "prevents tables having the same number in the same floor plan" do
        restaurant = create(:restaurant)
        floor_plan = create(:floor_plan, restaurant: restaurant)

        floor_plan_1_table_1 = create(
          :floor_plan_table,
          floor_plan: floor_plan,
          table_number: '1a'
        )

        expect {
          create(
            :floor_plan_table,
            floor_plan: floor_plan,
            table_number: '1A'
          )
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
