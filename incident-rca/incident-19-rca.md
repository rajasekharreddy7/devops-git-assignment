# Production Incident RCA Report

## Incident Details

Incident ID: INC-019
Incident Title: AWS EC2 Application Connectivity Failure
Incident Date: 14 October 2026
Severity: Lab Simulation
Environment: AWS EC2 - ap-south-2
Application: Flask Monitoring Application
Application Port: 5000
Status: Resolved (Lab)

## 1. Incident Summary

The Flask monitoring application hosted on AWS EC2
was inaccessible from an external client.

Initial investigation confirmed that the EC2 instance
was running and both AWS status checks were healthy.

The monitoring-app systemd service was active,
and Gunicorn was listening on port 5000.

Local HTTP testing returned HTTP 200 OK.
However, external HTTP requests timed out.

Further investigation identified a missing inbound
TCP port 5000 rule in the EC2 security group.

A temporary security group rule restricted to the
client's public IP restored external connectivity.

The temporary rule was removed after verification.

## 2. Impact Analysis

Affected Service:
Flask Monitoring Application hosted on AWS EC2.

Technical Impact:
- External HTTP requests to port 5000 timed out.
- The application remained accessible locally on EC2.
- The Gunicorn process and systemd service were healthy.
- No application restart was required.

User Impact:
- Direct external access from the test client was unavailable.
- Actual production customer impact was not measured.

Business Impact:
- No confirmed business impact because this was a lab simulation.

Incident Duration:
Not measured.

## 3. Incident Timeline

Date: 14 October 2026

Note: Exact timestamps were not recorded for every step.
The following events are listed in investigation order.

1. Incident Detection
   - External access to the Flask application was investigated.

2. AWS Infrastructure Verification
   - EC2 instance state: running.
   - System status check: OK.
   - Instance status check: OK.

3. Security Group Investigation
   - Identified security group: prometheus-lab-sg.
   - Inbound TCP port 5000 was not allowed.

4. Application Health Verification
   - monitoring-app systemd service: active (running).
   - Gunicorn listening on 0.0.0.0:5000.
   - Local HTTP request returned 200 OK.

5. External Connectivity Verification
   - External curl request timed out after 5 seconds.

6. Remediation
   - Added TCP port 5000 inbound access.
   - Restricted source to the test client's public IP /32.

7. Service Recovery Verification
   - External HTTP request returned 200 OK.
   - Application response: Monitoring App is Running!

8. Post-Incident Cleanup
   - Removed the temporary security group rule.
   - Restored the previous security group configuration.

## 4. Root Cause Analysis

Primary Root Cause:
The EC2 security group did not contain an inbound rule
allowing TCP traffic on application port 5000.

Technical Explanation:
- The Flask application was hosted on an AWS EC2 instance.
- Gunicorn was listening on 0.0.0.0:5000.
- The application returned HTTP 200 OK locally.
- External requests to the EC2 public IP on port 5000
  timed out because the security group blocked traffic.
- Adding a restricted inbound rule restored connectivity.

Evidence:
1. EC2 system and instance status checks: OK.
2. systemctl status monitoring-app: active (running).
3. ss -lntp: Gunicorn listening on port 5000.
4. Local curl: HTTP 200 OK.
5. External curl before remediation: connection timeout.
6. External curl after remediation: HTTP 200 OK.

Contributing Factors:
- The required inbound port was absent from the security group.
- The lab did not have a documented external-access
  configuration for the application.

Root Cause Category:
AWS Network Security Configuration.

Application Code Issue:
No application code failure was identified.

## 5. Resolution and Recovery Actions

Immediate Remediation:
- Identified the missing inbound TCP port 5000 rule.
- Identified the external test client's public IPv4 address.
- Added a temporary inbound security group rule.
- Restricted access to the test client's public IP using /32.

AWS Resources:
- Region: ap-south-2
- EC2 Instance: i-02b1b4d09e2e74c6f
- Security Group: sg-09b1b849b93a5aa62
- Application Port: TCP 5000
Recovery Verification:
- Executed an external HTTP request using curl.
- Received HTTP/1.1 200 OK.
- Verified response: Monitoring App is Running!
- Confirmed application connectivity from the authorized IP.

Post-Recovery Cleanup:
- Removed the temporary security group rule.
- AWS confirmed successful rule revocation.
- Restored the previous network access configuration.

Final Status:
- Application health: Healthy.
- External connectivity during authorized test: Successful.
- Temporary access rule: Removed.
- Direct external access on port 5000: Restricted again.

## 6. Preventive Actions and Long-Term Improvements

1. Infrastructure as Code
   - Manage EC2 security groups using Terraform.
   - Review infrastructure changes through Git pull requests.
   - Use terraform plan before applying changes.

2. Monitoring and Alerting
   - Configure Prometheus Blackbox Exporter.
   - Monitor application HTTP availability.
   - Configure alerts for application downtime.

3. Security Best Practices
   - Follow the principle of least privilege.
   - Avoid opening application ports to 0.0.0.0/0.
   - Restrict SSH access to trusted networks.
   - Use IAM roles instead of AWS root credentials.

4. High Availability
   - Consider an Application Load Balancer.
   - Configure HTTPS using AWS Certificate Manager.
   - Use multiple EC2 instances across Availability Zones
     when high availability is required.

5. Automated Validation
   - Add application health checks to CI/CD pipelines.
   - Verify application connectivity after deployments.
   - Test security group changes before production rollout.

6. Documentation
   - Maintain application port and network requirements.
   - Document incident troubleshooting procedures.
   - Review RCA findings with the DevOps/SRE team.

