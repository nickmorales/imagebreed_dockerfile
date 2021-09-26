#!/bin/bash

mkdir perl-local-lib

curl -L https://cpanmin.us | perl - --sudo App::cpanminus

sudo apt-get install -y libexpat1-dev libcatalyst-controller-html-formfu-perl libcairo2-dev libgd-dev libpq-dev libmoosex-runnable-perl libgdbm6 libgdm-dev

sudo cpanm -L perl-local-lib/ local::lib
sudo cpanm -L perl-local-lib/ install Catalyst::ScriptRunner
sudo cpanm -L perl-local-lib/ Catalyst::Restarter
sudo cpanm -L perl-local-lib/ HTML::Mason::Interp
sudo cpanm -L perl-local-lib/ Selenium::Remote::Driver
sudo cpanm -L perl-local-lib/ DBI
sudo cpanm -L perl-local-lib/ Hash::Merge
sudo cpanm -L perl-local-lib/ DBIx::Connector
sudo cpanm -L perl-local-lib/ Catalyst::Plugin::Authorization::Roles
sudo cpanm -L perl-local-lib/ XML::DOM::XPath --force
sudo cpanm -L perl-local-lib/ Bio::PrimarySeq
sudo cpanm -L perl-local-lib/ Class::DBI
sudo cpanm -L perl-local-lib/ Tie::UrlEncoder
sudo cpanm -L perl-local-lib/ Data::BitMask
sudo cpanm -L perl-local-lib/ enum
sudo cpanm -L perl-local-lib/ File::NFSLock
sudo cpanm -L perl-local-lib/ Class::MethodMaker
sudo cpanm -L perl-local-lib/ Bio::BLAST::Database
sudo cpanm -L perl-local-lib/ Catalyst::Plugin::SmartURI
sudo cpanm -L perl-local-lib/ Modern::Perl
sudo cpanm -L perl-local-lib/ List::Compare
sudo cpanm -L perl-local-lib/ Cache::File
sudo cpanm -L perl-local-lib/ Config::JFDI
sudo cpanm -L perl-local-lib/ CatalystX::GlobalContext --force
sudo cpanm -L perl-local-lib/ DBIx::Class::Schema
sudo cpanm -L perl-local-lib/ Bio::Chado::Schema
sudo cpanm -L perl-local-lib/ Array::Utils
sudo cpanm -L perl-local-lib/ JSON::Any
sudo cpanm -L perl-local-lib/ Math::Round
sudo cpanm -L perl-local-lib/ Math::Round::Var
sudo cpanm -L perl-local-lib/ Catalyst::View::Email
sudo cpanm -L perl-local-lib/ Catalyst::View::HTML::Mason
sudo cpanm -L perl-local-lib/ Catalyst::View::Bio::SeqIO
sudo cpanm -L perl-local-lib/ Catalyst::View::JavaScript::Minifier::XS@2.101001
sudo cpanm -L perl-local-lib/ Catalyst::View::Download::CSV
sudo cpanm -L perl-local-lib/ URI::FromHash
sudo cpanm -L perl-local-lib/ JSAN::ServerSide
sudo cpanm -L perl-local-lib/ Config::INI::Reader
sudo cpanm -L perl-local-lib/ Bio::GFF3::LowLevel
sudo cpanm -L perl-local-lib/ Statistics::Descriptive
sudo cpanm -L perl-local-lib/ String::Random
sudo cpanm -L perl-local-lib/ MooseX::FollowPBP
sudo cpanm -L perl-local-lib/ GD
sudo cpanm -L perl-local-lib/ Tie::Function
sudo cpanm -L perl-local-lib/ Digest::Crc32
sudo cpanm -L perl-local-lib/ Barcode::Code128
sudo cpanm -L perl-local-lib/ Math::Base36
sudo cpanm -L perl-local-lib/ Captcha::reCAPTCHA
sudo cpanm -L perl-local-lib/ Test::Aggregate::Nested --force
sudo cpanm -L perl-local-lib/ SVG
sudo cpanm -L perl-local-lib/ IPC::Run3
sudo cpanm -L perl-local-lib/ Spreadsheet::WriteExcel
sudo cpanm -L perl-local-lib/ MooseX::Object::Pluggable
sudo cpanm -L perl-local-lib/ R::YapRI::Base
sudo cpanm -L perl-local-lib/ PDF::Create
sudo cpanm -L perl-local-lib/ String::CRC
sudo cpanm -L perl-local-lib/ Algorithm::Combinatorics
sudo cpanm -L perl-local-lib/ String::Approx
sudo cpanm -L perl-local-lib/ Cairo
sudo cpanm -L perl-local-lib/ Chart::Clicker
sudo cpanm -L perl-local-lib/ Spreadsheet::ParseExcel
sudo cpanm -L perl-local-lib/ MooseX::Types::URI
sudo cpanm -L perl-local-lib/ Bio::Graphics::FeatureFile --force
sudo cpanm -L perl-local-lib/ Mail::Sendmail --force
sudo cpanm -L perl-local-lib/ Array::Compare
sudo cpanm -L perl-local-lib/ GD::Graph::lines
sudo cpanm -L perl-local-lib/ GD::Graph::Map
sudo cpanm -L perl-local-lib/ Bio::GMOD::GenericGenePage
sudo cpanm -L perl-local-lib/ Number::Bytes::Human
sudo cpanm -L perl-local-lib/ AnyEvent --force
sudo cpanm -L perl-local-lib/ IO::Event --force
sudo cpanm -L perl-local-lib/ File::Flock
sudo cpanm -L perl-local-lib/ Graph
sudo cpanm -L perl-local-lib/ Bio::SeqFeature::Annotated
sudo cpanm -L perl-local-lib/ XML::Twig
sudo cpanm -L perl-local-lib/ XML::Generator
sudo cpanm -L perl-local-lib/ DBD::Pg
sudo cpanm -L perl-local-lib/ MooseX::Runnable@0.09
sudo cpanm -L perl-local-lib/ XML::Feed
sudo cpanm -L perl-local-lib/ Parse::Deb::Control
sudo cpanm -L perl-local-lib/ Bio::GMOD::Blast::Graph
sudo cpanm -L perl-local-lib/ Catalyst::DispatchType::Regex
sudo cpanm -L perl-local-lib/ DateTime::Format::Flexible
sudo cpanm -L perl-local-lib/ DateTime::Format::Pg
sudo cpanm -L perl-local-lib/ HTML::TreeBuilder::XPath
sudo cpanm -L perl-local-lib/ JSON::XS
sudo cpanm -L perl-local-lib/ Lingua::EN::Inflect
sudo cpanm -L perl-local-lib/ List::AllUtils
sudo cpanm -L perl-local-lib/ MooseX::Declare
sudo cpanm -L perl-local-lib/ MooseX::Singleton
sudo cpanm -L perl-local-lib/ SOAP::Transport::HTTP
sudo cpanm -L perl-local-lib/ Test::Class
sudo cpanm -L perl-local-lib/ WWW::Mechanize::TreeBuilder
sudo cpanm -L perl-local-lib/ Data::UUID
sudo cpanm -L perl-local-lib/ HTML::Lint --force
sudo cpanm -L perl-local-lib/ Test::JSON
sudo cpanm -L perl-local-lib/ Test::MockObject
sudo cpanm -L perl-local-lib/ Test::WWW::Selenium
sudo cpanm -L perl-local-lib/ Sort::Versions
sudo cpanm -L perl-local-lib/ Term::ReadKey --force
sudo cpanm -L perl-local-lib/ Spreadsheet::Read
sudo cpanm -L perl-local-lib/ Sort::Maker
sudo cpanm -L perl-local-lib/ Term::Size::Any
sudo cpanm -L perl-local-lib/ Proc::ProcessTable
sudo cpanm -L perl-local-lib/ URI::Encode
sudo cpanm -L perl-local-lib/ Archive::Zip
sudo cpanm -L perl-local-lib/ Statistics::R
sudo cpanm -L perl-local-lib/ Lucy::Simple
sudo cpanm -L perl-local-lib/ DBIx::Class::Schema::Loader
sudo cpanm -L perl-local-lib/ Text::CSV
sudo cpanm -L perl-local-lib/ Imager::QRCode
sudo cpanm -L perl-local-lib/ GD::Barcode::QRcode
sudo cpanm -L perl-local-lib/ LWP::UserAgent
sudo cpanm -L perl-local-lib/ Set::Product
sudo cpanm -L perl-local-lib/ Server::Starter
sudo cpanm -L perl-local-lib/ Net::Server::SS::PreFork --force
sudo cpanm -L perl-local-lib/ Catalyst::Plugin::Assets --force
sudo cpanm -L perl-local-lib/ PDF::API2
sudo cpanm -L perl-local-lib/ CAM::PDF
sudo cpanm -L perl-local-lib/ Sort::Key::Natural
sudo cpanm -L perl-local-lib/ Bio::Restriction::Analysis
sudo cpanm -L perl-local-lib/ Bio::BLAST::Database
sudo cpanm -L perl-local-lib/ Parallel::ForkManager
sudo cpanm -L perl-local-lib/ Math::Polygon
sudo cpanm -L perl-local-lib/ Email::Send::SMTP::Gmail
sudo cpanm -L perl-local-lib/ Hash::Case::Preserve
