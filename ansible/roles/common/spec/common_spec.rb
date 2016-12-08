require 'spec_helper'

describe service('/bin/sh /var/awslogs/bin/awslogs-agent-launcher.sh') do
    it { should be_running }
end