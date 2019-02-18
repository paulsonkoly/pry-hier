require 'pry-hier'

RSpec.describe Pry::Commands['hier'] do
  before do
    Pry.config.color = false
  end

  let(:output) { spy(Pry::Output) }
  let(:opts) { double(Pry::Slop, include_singletons?: false) }
  let(:singleton_opts) { double(Pry::Slop, include_singletons?: true) }

  context 'with a class that doesn\'t have descendants' do
    let(:command) do
      subject.tap do |cmd|
        cmd.args = ['Integer']
        cmd.opts = opts
        cmd.output = output
      end
    end

    it 'puts the name of the class' do
      command.process
      expect(output).to have_received(:puts).with('Integer')
    end
  end

  context 'with singleton flag' do
    let(:command) do
      subject.tap do |cmd|
        cmd.args = ['Class']
        cmd.opts = singleton_opts
        cmd.output = output
      end
    end

    it 'includes Singleton classes' do
      command.process
      expect(output).to have_received(:print).with(/#<.*>/)
    end
  end

  context 'with Numeric' do
    let(:command) do
      subject.tap do |cmd|
        cmd.args = ['Numeric']
        cmd.opts = opts
        cmd.output = output
      end
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
  end

  context 'with invalid class name' do
    let(:command) do
      subject.tap { |cmd| cmd.args = ['xxx'] }
    end

    it 'raises exception for something that\'s not a class' do
      expect { command.process }.to raise_error Pry::CommandError
    end
  end

  context 'with colours' do
    before do
      Pry.config.color = true
    end

    let(:command) do
      subject.tap do |cmd|
        cmd.args = ['Numeric']
        cmd.opts = opts
        cmd.output = output
      end
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
