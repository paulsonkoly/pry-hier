require 'pry-hier'

RSpec.describe Pry::Commands['hier'] do
  let(:output) { spy(Pry::Output) }
  let(:command) do
    subject.tap do |cmd|
      cmd.args = ['Numeric']
      cmd.opts = double(Pry::Slop, include_singletons?: false)
      cmd.output = output
    end
  end

  before do
    Pry.config.color = false
  end

  it 'prints the descendants of Numeric' do
    command.process

    expect(output).to have_received(:print).with <<EOS
Numeric
├── Complex
├── Rational
├── Float
└── Integer
EOS
  end

  context 'with colours' do
    before do
      Pry.config.color = true
    end

    it 'includes the color ansi sequences' do
      command.process

      expect(output).to have_received(:print).with <<EOS
\e[1;34;4mNumeric\e[0m
├── \e[1;34;4mComplex\e[0m
├── \e[1;34;4mRational\e[0m
├── \e[1;34;4mFloat\e[0m
└── \e[1;34;4mInteger\e[0m
EOS
    end
  end
end
