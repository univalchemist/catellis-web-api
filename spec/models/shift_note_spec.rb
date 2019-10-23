require 'rails_helper'

RSpec.describe ShiftNote, type: :model do
  describe "supports soft-delete" do
    before(:each) do
      @shift_note = create(:shift_note)
    end

    it "is hidden from default scope after destroy" do
      @shift_note.destroy

      expect {
        ShiftNote.find(@shift_note.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "is available from with_deleted scope after destroy" do
      @shift_note.destroy

      found = ShiftNote.with_deleted.find(@shift_note.id)

      expect(found).to eq @shift_note
    end
  end
end
