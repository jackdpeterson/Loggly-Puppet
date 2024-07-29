require 'spec_helper'

describe 'loggly' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "rsyslog_to_vendor class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('rsyslog_to_vendor') }

#          it { is_expected.to contain_class('rsyslog_to_vendor::params') }
#          it { is_expected.to contain_class('rsyslog_to_vendor::install').that_comes_before('rsyslog_to_vendor::config') }
#          it { is_expected.to contain_class('rsyslog_to_vendor::config') }
#          it { is_expected.to contain_class('rsyslog_to_vendor::service').that_subscribes_to('rsyslog_to_vendor::config') }

          it { 
            is_expected.to contain_file('/usr/local/rsyslog_to_vendor').with(
              'ensure'  => 'directory', 
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0755'
            )
          }

          it { 
            is_expected.to contain_file('/usr/local/rsyslog_to_vendor/certs').with(
              'ensure'  => 'directory',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0755'
            ) 
          }

          it { 
            is_expected.to contain_file('/usr/local/rsyslog_to_vendor/certs/loggly_full.crt').with(
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'source'  => 'puppet:///modules/rsyslog_to_vendor/loggly_full.crt'
            ) 
          }
        end

        context "rsyslog_to_vendor class with custom base_dir" do
          let(:params) {{ 
            :base_dir  => '/tmp/base_dir'
          }}

          it { is_expected.to compile.with_all_deps }

          it { 
            is_expected.to contain_file('/tmp/base_dir').with(
              'ensure'  => 'directory', 
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0755'
            )
          }

          it { 
            is_expected.to contain_file('/tmp/base_dir/certs').with(
              'ensure'  => 'directory',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0755'
            ) 
          }

          it { 
            is_expected.to contain_file('/tmp/base_dir/certs/loggly_full.crt').with(
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'source'  => 'puppet:///modules/rsyslog_to_vendor/loggly_full.crt'
            ) 
          }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'rsyslog_to_vendor class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('rsyslog_to_vendor') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
