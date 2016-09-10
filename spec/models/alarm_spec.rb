# == Schema Information
#
# Table name: alarms
#
#  id         :integer          not null, primary key
#  alarm_time :time             not null
#  days       :string           default([]), is an Array
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  turned_on  :boolean          default(FALSE), not null
#  status     :string
#  online_key :string
#  name       :string
#

require 'rails_helper'

RSpec.describe Alarm, type: :model do
  subject { create(:alarm) }

  context "validation" do
    it "doesn't save invalid days" do
      subject.days << "Someday"

      expect(subject.save).to be_falsy
    end

    it "allows empty array or nil" do
      subject.days = []
      expect(subject.save).to be_truthy

      subject.days = nil
      expect(subject.save).to be_truthy
    end

    it "validates alarm_time format", focus: true do
      subject.alarm_time = "13:23"
      expect(subject.save).to be_truthy

      subject.alarm_time = "abcd"
      expect(subject.save).to be_falsy

      subject.alarm_time = "23:99"
      expect(subject.save).to be_falsy
    end
  end

  describe "::create" do
    it 'converts time to utc' do
      time = Time.current.in_time_zone 'Pacific Time (US & Canada)'
      alarm = Alarm.create(alarm_time: time, user: create(:user))
      expect(alarm.alarm_time.utc?).to be_truthy
    end
  end

  describe "#days" do
    it "returns days in an array" do
      expect(subject.days).to be_a Array
    end

    it "can push in valid day" do
      subject.days << "Sunday"
      expect(subject.save).to be_truthy
    end

    it "doesn't accept invliad day" do
      subject.days << "Someday"
      expect(subject.save).to be_falsy
    end

    it "pushes day into array" do
      subject.days << "Sunday"
      subject.save
      expect(subject.days.size).to eq 4
    end

    it "deletes day in the array" do
      subject.days.reject! { |day| day == "Monday" }
      subject.save
      expect(subject.days.size).to eq 2
    end

    it "doesn't allow duplicated day" do
      subject.days << "Sunday"
      subject.save
      subject.days << "Sunday"
      expect(subject.save).to be_falsy
    end

    it "normalize days" do
      subject.days = nil
      subject.save
      expect(subject.days).to be_an Array

      subject.days << "sunday"
      subject.save
      expect(subject.days).to eq ["Sunday"]
    end
  end

  describe "#alarm_time_to_str" do
    it "parse time to formatted string" do
      time_str = subject.alarm_time_to_str
      expect(time_str).to eq "15:14"
    end
  end

  describe "#ring" do
    it "goes online" do
      expect { subject.ring }.to change { subject.online? }.from(false).to(true)
    end

    it "changes status to ringing" do
      expect { subject.ring }.to change { subject.status }.from(nil).to('ringing')
    end
  end

  describe "#stop" do
    
  end
end
