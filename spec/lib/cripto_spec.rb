require 'spec_helper'
require 'dictionary'
require 'cripto'

describe Cripto do
  let(:definition) do
    {'a' => 'b',
    'b' => 'c',
    'c' => 'd',
    'd' => 'e',
    'e' => 'f',
    'f' => 'g',
    'g' => 'h',
    'h' => 'i',
    'i' => 'j',
    'j' => 'k',
    'k' => 'l',
    'l' => 'm',
    'm' => 'n',
    'n' => 'o',
    'o' => 'p',
    'p' => 'q',
    'q' => 'r',
    'r' => 's',
    's' => 't',
    't' => 'u',
    'u' => 'v',
    'v' => 'w',
    'w' => 'x',
    'x' => 'y',
    'y' => 'z',
    'z' => 'a',

    'A' => 'B',
    'B' => 'C',
    'C' => 'D',
    'D' => 'E',
    'E' => 'F',
    'F' => 'G',
    'G' => 'H',
    'H' => 'I',
    'I' => 'J',
    'J' => 'K',
    'K' => 'L',
    'L' => 'M',
    'M' => 'N',
    'N' => 'O',
    'O' => 'P',
    'P' => 'Q',
    'Q' => 'R',
    'R' => 'S',
    'S' => 'T',
    'T' => 'U',
    'U' => 'V',
    'V' => 'W',
    'W' => 'X',
    'X' => 'Y',
    'Y' => 'Z',
    'Z' => 'A',
    ' ' => '.',
    '.' => ' ',
    } 
  end

  let(:dictionary) { Dictionary.new(definition) }

  subject do 
    Cripto.new(dictionary)
  end

  describe 'encrypt' do
    it do
      subject.encrypt("Dojo").should == "Epkp"
      subject.encrypt("Dado").should == "Ebep"
      subject.encrypt("Dojo Dado").should == "Epkp.Ebep"
    end
    
    it "should only replace string on the dictionary" do
       subject.encrypt("Dado!?#").should == "Ebep!?#"
    end

    describe "with a Hash dictionary" do
      subject do
        Cripto.new(definition)
      end

      it do
        subject.encrypt("Dojo").should == "Epkp"
        subject.encrypt("Dado").should == "Ebep"
        subject.encrypt("Dojo Dado").should == "Epkp.Ebep"
      end
      
      it "should only replace string on the dictionary" do
         subject.encrypt("Dado!?#").should == "Ebep!?#"
      end
    end
  end
  
  describe 'decrypt' do
    it do
      subject.decrypt("Epkp").should == "Dojo"
      subject.decrypt("Ebep").should == "Dado"
      subject.decrypt("Epkp.Ebep").should == "Dojo Dado"
    end
    
    it "should only replace string on the dictionary" do
       subject.decrypt("Ebep!?#").should == "Dado!?#"
    end

    describe "with a Hash dictionary" do
      subject do
        Cripto.new(definition)
      end

      it do
        subject.decrypt("Epkp").should == "Dojo"
        subject.decrypt("Ebep").should == "Dado"
        subject.decrypt("Epkp.Ebep").should == "Dojo Dado"
      end
      
      it "should only replace string on the dictionary" do
         subject.decrypt("Ebep!?#").should == "Dado!?#"
      end
    end
  end
end
