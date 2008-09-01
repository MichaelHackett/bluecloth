#!/usr/bin/env ruby

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent
	
	libdir = basedir + "lib"
	
	$LOAD_PATH.unshift( libdir ) unless $LOAD_PATH.include?( libdir )
}

begin
	require 'spec/runner'
	require 'logger'
	require 'bluecloth'
	require 'spec/lib/constants'
	require 'spec/lib/matchers'
rescue LoadError
	unless Object.const_defined?( :Gem )
		require 'rubygems'
		retry
	end
	raise
end



#####################################################################
###	C O N T E X T S
#####################################################################

describe BlueCloth, "bugfixes" do
	include BlueCloth::TestConstants,
		BlueCloth::Matchers

	before( :all ) do
		@basedir = Pathname.new( __FILE__ ).dirname.parent
		@datadir = @basedir + 'spec/data'
	end
	
	

	### Test to be sure the README file can be transformed.
	it "can transform the included README file" do
		readme = @basedir + 'README'
		contents = readme.read

		bcobj = BlueCloth::new( contents )

		lambda do
			timeout( 2 ) { bcobj.to_html }
		end.should_not raise_error()
	end


	it "provides a workaround for the regexp-engine overflow bug" do
		datafile = @datadir + 're-overflow.txt'
		markdown = datafile.read

		lambda { BlueCloth.new(markdown).to_html }.should_not raise_error()
	end

	
	it "provides a workaround for the second regexp-engine overflow bug" do
		datafile = @datadir + 're-overflow2.txt'
		markdown = datafile.read

		lambda { BlueCloth.new(markdown).to_html }.should_not raise_error()
	end
	

	it "correctly wraps <strong> tags around two characters enclosed in four asterisks" do
		the_markdown( "**aa**" ).should be_transformed_into( "<p><strong>aa</strong></p>" )
	end


	it "correctly wraps <strong> tags around a single character enclosed in four asterisks" do
		the_markdown( "**a**" ).should be_transformed_into( "<p><strong>a</strong></p>" )
	end


	it "correctly wraps <strong> tags around two characters enclosed in four underscores" do
		the_markdown( "__aa__" ).should be_transformed_into( "<p><strong>aa</strong></p>" )
	end


	it "correctly wraps <strong> tags around a single character enclosed in four underscores" do
		the_markdown( "__a__" ).should be_transformed_into( "<p><strong>a</strong></p>" )
	end


	it "correctly wraps <em> tags around two characters enclosed in two asterisks" do
		the_markdown( "*aa*" ).should be_transformed_into( "<p><em>aa</em></p>" )
	end


	it "correctly wraps <em> tags around a single character enclosed in two asterisks" do
		the_markdown( "*a*" ).should be_transformed_into( "<p><em>a</em></p>" )
	end


	it "correctly wraps <em> tags around two characters enclosed in four underscores" do
		the_markdown( "_aa_" ).should be_transformed_into( "<p><em>aa</em></p>" )
	end


	it "correctly wraps <em> tags around a single character enclosed in four underscores" do
		the_markdown( "_a_" ).should be_transformed_into( "<p><em>a</em></p>" )
	end


	it "doesn't raise an error when run with $VERBOSE = true" do
		oldverbose = $VERBOSE

		lambda do
			$VERBOSE = true
			BlueCloth.new( "*woo*" ).to_html
		end.should_not raise_error()

		$VERBOSE = oldverbose
	end
	
	
end


__END__
