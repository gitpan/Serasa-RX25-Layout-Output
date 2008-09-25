use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME              => 'Serasa::RX25::Layout::Output',
	DISTNAME          => 'Serasa-RX25-Layout-Output',
	VERSION_FROM      => 'lib/Serasa/RX25/Layout/Output.pm',
	PREREQ_PM         => {
			'LWP::UserAgent'    => 5,
			'Test::Simple'      => 0.44,
	},

	($] >= 5.006001 ?     ## Add these new keywords supported since 5.006001
	(ABSTRACT_FROM  => 'lib/Serasa/RX25/Layout/Output.pm',
	AUTHOR         => 'Thiago Rondon <thiago@aware.com.br>') : ()),
);
