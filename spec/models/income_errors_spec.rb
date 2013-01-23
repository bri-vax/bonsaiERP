require 'spec_helper'

describe IncomeErrors do
  subject { Income.new_income }

  it "initializes an income without any errors" do
    subject.should_not be_has_error
    subject.error_messages.should be_blank
  end

  it "sets error for balance" do
    subject.total = 10
    subject.balance = -1.1

    IncomeErrors.new(subject).set_errors

    subject.should be_has_error
    subject.error_messages[:balance].should eq(['transaction.negative_balance'])
  end

  context "Detail errors" do
    it "present errors when details are wrong" do
      subject.income_details.build(balance: 2)
      subject.income_details.build(balance: -1)
      
      IncomeErrors.new(subject).set_errors

      subject.should be_has_error
      subject.error_messages[:income_details].should eq(['transaction.negative_item_balance'])
    end

    it "present errors when details are wrong" do
      subject.income_details.build(balance: -2)
      subject.income_details.build(balance: -1)
      
      IncomeErrors.new(subject).set_errors

      subject.should be_has_error
      subject.error_messages[:income_details].should eq(['transaction.negative_items_balance'])
    end
  end
end