require 'spec_helper'

describe 'rsyslog_to_vendor::rsyslog' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "rsyslog_to_vendor::rsyslog class without any parameters" do
          let(:params) {{ }}

          it { should_not compile }
        end
        
        context "rsyslog_to_vendor::rsyslog class with invalid loggly_customer_token" do
          let(:params) {{
            :loggly_customer_token => [ 'thing1', 'thing2' ],
          }}
          it { should_not compile }
        end

        context "rsyslog_to_vendor::rsyslog class with invalid cert_path" do
          let(:params) {{
            :loggly_customer_token => '0000-0000-0000',
            :cert_path      => 'relative/path',
          }}
          it { should_not compile }
        end

        context "rsyslog_to_vendor::rsyslog class with invalid enable_tls" do
          let(:params) {{
            :loggly_customer_token => '0000-0000-0000',
            :enable_tls     => 'yes',
          }}
          it { should_not compile }
        end

        context "rsyslog_to_vendor::rsyslog class with loggly_customer_token" do
          let(:params) {{
            :loggly_customer_token => '0000-0000-0000',
          }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('rsyslog_to_vendor::rsyslog') }

          it {
            is_expected.to contain_exec('restart_rsyslogd').with(
              'command'     => 'service rsyslog restart',
              'refreshonly' => true,
            )
          }
        end

        context "rsyslog_to_vendor::rsyslog class with enable_tls" do
          context "true" do
            let(:params) {{
              :loggly_customer_token => '0000-0000-0000',
              :enable_tls     => true,
            }}
         
            it { 
              is_expected.to contain_file('/etc/rsyslog.d/22-loggly.conf').with(
                'ensure'  => 'file',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644',
                'content' => /#RsyslogGnuTLS/,
              )
            }

            it { is_expected.to contain_package('rsyslog-gnutls').with_ensure('installed') }
          end

          context "false" do
            let(:params) {{
              :loggly_customer_token => '0000-0000-0000',
              :enable_tls     => false,
            }}
         
            it { 
              is_expected.to contain_file('/etc/rsyslog.d/22-loggly.conf').with(
                'ensure'  => 'file',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644',
                'content' => /logs-01\.loggly\.com:514; LogglyFormat/,
              )
            }
          end
        end
      end
    end
  end
end
