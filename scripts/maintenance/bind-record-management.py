#!/usr/bin/python3
import paramiko
import re
from datetime import datetime

class DNSManager:
    def __init__(self, zone_choice, host='prod-bind-01', user='rt'):
        self.ssh = paramiko.SSHClient()
        self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.ssh.connect(host, username=user)
        
        # Zone configuration dictionary
        self.zones = {
            'local.rtyner.com': {
                'forward_zone': '/etc/bind/zones/db.local.rtyner.com',
                'reverse_zone': '/etc/bind/zones/db.10.1.1',
                'domain': 'local.rtyner.com'
            },
            'rtyner.com': {
                'forward_zone': '/var/cache/bind/zones/db.rtyner.com',
                'reverse_zone': '/etc/bind/zones/db.10.1.1',  # Update this if different
                'domain': 'rtyner.com'
            }
        }
        
        # Set current zone configuration
        zone_config = self.zones[zone_choice]
        self.forward_zone = zone_config['forward_zone']
        self.reverse_zone = zone_config['reverse_zone']
        self.domain = zone_config['domain']

    def backup_zone_files(self):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        try:
            # Create backup directory if it doesn't exist
            self.execute_command("sudo mkdir -p /etc/bind/zones/backups")
            
            # Backup forward zone
            forward_backup = f"/etc/bind/zones/backups/{self.domain}.{timestamp}"
            self.execute_command(f"sudo cp {self.forward_zone} {forward_backup}")
            
            # Backup reverse zone
            reverse_backup = f"/etc/bind/zones/backups/db.10.1.1.{timestamp}"
            self.execute_command(f"sudo cp {self.reverse_zone} {reverse_backup}")
            
            print(f"Zone files backed up with timestamp {timestamp}")
            return True
        except Exception as e:
            print(f"Error backing up zone files: {e}")
            return False

    def execute_command(self, command):
        stdin, stdout, stderr = self.ssh.exec_command(command)
        return stdout.read().decode().strip(), stderr.read().decode().strip()

    def check_record_exists(self, hostname, record_type='A'):
        try:
            # Read zone file directly instead of using dig
            content = self.read_zone_file(self.forward_zone)
            
            # Handle hostname check based on zone
            if self.domain == 'rtyner.com':
                hostname_check = hostname
            else:
                hostname_check = f"{hostname}.{self.domain}"
            
            # Check each line for the record
            for line in content.split('\n'):
                if line.strip() and not line.strip().startswith(';'):
                    if hostname_check in line and f"IN    {record_type}" in line:
                        return True
            return False
        except Exception as e:
            print(f"Error checking record: {e}")
            return False

    def read_zone_file(self, file_path):
        try:
            stdout, stderr = self.execute_command(f"cat {file_path}")
            if stderr:
                print(f"Warning while reading file: {stderr}")
            return stdout
        except Exception as e:
            print(f"Error reading zone file: {e}")
            return ""

    def write_zone_file(self, file_path, content):
        temp_path = f"/tmp/zone_{datetime.now().strftime('%s')}"
        echo_cmd = f"echo '{content}' > {temp_path}"
        mv_cmd = f"sudo mv {temp_path} {file_path}"
        chown_cmd = f"sudo chown bind:bind {file_path}"
        
        self.execute_command(echo_cmd)
        self.execute_command(mv_cmd)
        self.execute_command(chown_cmd)

    def update_serial(self, zone_file):
        try:
            content = self.read_zone_file(zone_file)
            serial_match = re.search(r'(\d+)\s*;\s*serial', content)
            if serial_match:
                new_serial = int(datetime.now().strftime("%Y%m%d%H"))
                updated_content = content.replace(
                    serial_match.group(0),
                    f"{new_serial}      ; serial"
                )
                self.write_zone_file(zone_file, updated_content)
        except Exception as e:
            print(f"Error updating serial: {e}")
            return False
        return True

    def list_records(self, record_type=None):
        try:
            # Read forward zone file
            content = self.read_zone_file(self.forward_zone)
            
            # Split into lines and filter out comments and empty lines
            lines = [line.strip() for line in content.split('\n') 
                    if line.strip() and not line.strip().startswith(';')]
            
            records = []
            for line in lines:
                # Skip SOA and NS records
                if 'SOA' in line or 'NS' in line:
                    continue
                    
                # Parse records
                if 'IN' in line:
                    parts = line.split()
                    if len(parts) >= 4:
                        hostname = parts[0].rstrip('.')
                        record_type_found = parts[2]
                        value = parts[3]
                        
                        if record_type is None or record_type_found == record_type:
                            records.append({
                                'hostname': hostname,
                                'type': record_type_found,
                                'value': value
                            })
            
            return records
            
        except Exception as e:
            print(f"Error listing records: {e}")
            return []

    def delete_record(self, record_to_delete):
        # First backup existing zone files
        if not self.backup_zone_files():
            response = input("Backup failed. Do you want to continue? (y/N): ")
            if response.lower() != 'y':
                return False

        try:
            # Handle forward zone
            forward_content = self.read_zone_file(self.forward_zone)
            new_forward_content = []
            deleted = False

            for line in forward_content.split('\n'):
                if line.strip() and not line.strip().startswith(';'):
                    if record_to_delete['hostname'] in line and record_to_delete['type'] in line and record_to_delete['value'] in line:
                        deleted = True
                        continue
                new_forward_content.append(line)

            if not deleted:
                print("Record not found in forward zone.")
                return False

            # Write updated forward zone
            self.write_zone_file(self.forward_zone, '\n'.join(new_forward_content))

            # Handle reverse zone if it's an A record
            if record_to_delete['type'] == 'A':
                reverse_content = self.read_zone_file(self.reverse_zone)
                new_reverse_content = []
                ip_last_octet = record_to_delete['value'].split('.')[-1]
                
                for line in reverse_content.split('\n'):
                    if line.strip() and not line.strip().startswith(';'):
                        if ip_last_octet in line and record_to_delete['hostname'] in line:
                            continue
                    new_reverse_content.append(line)

                # Write updated reverse zone
                self.write_zone_file(self.reverse_zone, '\n'.join(new_reverse_content))

            # Update serials
            self.update_serial(self.forward_zone)
            self.update_serial(self.reverse_zone)

            # Reload BIND
            self.execute_command("sudo rndc reload")
            print(f"Successfully deleted record: {record_to_delete['hostname']}")
            return True

        except Exception as e:
            print(f"Error deleting record: {e}")
            print("Note: Backup files are available in /etc/bind/zones/backups/")
            return False

    def add_dns_record(self, hostname, ip, record_type='A'):
        # First backup existing zone files
        if not self.backup_zone_files():
            response = input("Backup failed. Do you want to continue? (y/N): ")
            if response.lower() != 'y':
                return False

        if self.check_record_exists(hostname, record_type):
            print(f"Record already exists for {hostname}")
            return False

        try:
            # Add forward record - handle domain suffix based on zone
            forward_content = self.read_zone_file(self.forward_zone)
            if self.domain == 'rtyner.com':
                forward_content += f"\n{hostname}    IN    {record_type}    {ip}"
            else:
                forward_content += f"\n{hostname}.{self.domain}.    IN    {record_type}    {ip}"
            self.write_zone_file(self.forward_zone, forward_content)

            # Add reverse record (PTR) if it's an A record
            if record_type == 'A':
                ip_last_octet = ip.split('.')[-1]
                reverse_content = self.read_zone_file(self.reverse_zone)
                if self.domain == 'rtyner.com':
                    reverse_content += f"\n{ip_last_octet}    IN    PTR    {hostname}.{self.domain}."
                else:
                    reverse_content += f"\n{ip_last_octet}    IN    PTR    {hostname}.{self.domain}."
                self.write_zone_file(self.reverse_zone, reverse_content)

            # Update serials
            self.update_serial(self.forward_zone)
            self.update_serial(self.reverse_zone)

            # Reload BIND
            self.execute_command("sudo rndc reload")
            print(f"Successfully added {record_type} record for {hostname}")
            return True

        except Exception as e:
            print(f"Error adding record: {e}")
            print("Note: Backup files are available in /etc/bind/zones/backups/")
            return False

    def __del__(self):
        if hasattr(self, 'ssh'):
            self.ssh.close()

def print_records(records):
    if not records:
        print("No records found.")
        return

    # Calculate column widths
    hostname_width = max(len(record['hostname']) for record in records)
    type_width = max(len(record['type']) for record in records)
    value_width = max(len(record['value']) for record in records)

    # Print header
    print("\n" + "=" * (hostname_width + type_width + value_width + 8))
    print(f"{'Hostname':<{hostname_width}} | {'Type':<{type_width}} | {'Value':<{value_width}}")
    print("-" * (hostname_width + type_width + value_width + 8))

    # Print records
    for record in records:
        print(f"{record['hostname']:<{hostname_width}} | {record['type']:<{type_width}} | {record['value']:<{value_width}}")
    
    print("=" * (hostname_width + type_width + value_width + 8) + "\n")

def select_zone():
    while True:
        print("\nAvailable DNS Zones")
        print("------------------")
        print("1. rtyner.com")
        print("2. local.rtyner.com")
        
        choice = input("\nSelect zone (1-2): ").strip()
        
        if choice == '1':
            return 'rtyner.com'
        elif choice == '2':
            return 'local.rtyner.com'
        else:
            print("Invalid choice. Please try again.")

def main():
    # Get zone selection from user
    selected_zone = select_zone()
    print(f"\nManaging DNS records for: {selected_zone}")
    
    dns_manager = DNSManager(selected_zone)

    while True:
        print("\nDNS Record Management")
        print("--------------------")
        print(f"Selected Zone: {selected_zone}")
        print("1. List all records")
        print("2. List A records")
        print("3. List CNAME records")
        print("4. Add new record")
        print("5. Delete record")
        print("6. Switch Zone")
        print("7. Exit")
        
        choice = input("\nEnter your choice (1-7): ").strip()

        if choice == '1':
            records = dns_manager.list_records()
            print_records(records)
            
        elif choice == '2':
            records = dns_manager.list_records('A')
            print_records(records)
            
        elif choice == '3':
            records = dns_manager.list_records('CNAME')
            print_records(records)
            
        elif choice == '4':
            hostname = input("Enter hostname (without domain): ").strip()
            record_type = input("Enter record type (A/CNAME) [default: A]: ").strip().upper() or 'A'

            if not hostname:
                print("Hostname is required!")
                continue

            if record_type not in ['A', 'CNAME']:
                print("Invalid record type. Must be A or CNAME")
                continue

            if record_type == 'A':
                ip = input("Enter IP address: ").strip()
                if not ip:
                    print("IP address is required for A records!")
                    continue
                ip_pattern = re.compile(r'^(\d{1,3}\.){3}\d{1,3}$')
                if not ip_pattern.match(ip):
                    print("Invalid IP address format!")
                    continue
            else:  # CNAME record
                ip = input("Enter target hostname (without domain): ").strip()
                if not ip:
                    print("Target hostname is required for CNAME records!")
                    continue
                ip = f"{ip}.{dns_manager.domain}."  # Add domain and trailing dot for CNAME target

            dns_manager.add_dns_record(hostname, ip, record_type)

        elif choice == '5':
            records = dns_manager.list_records()
            if not records:
                print("No records to delete.")
                continue
                
            print("\nAvailable records:")
            for i, record in enumerate(records, 1):
                print(f"{i}. {record['hostname']} ({record['type']}) -> {record['value']}")
            
            try:
                record_num = int(input("\nEnter record number to delete (0 to cancel): "))
                if record_num == 0:
                    continue
                if 1 <= record_num <= len(records):
                    record_to_delete = records[record_num - 1]
                    confirm = input(f"Are you sure you want to delete {record_to_delete['hostname']} "
                                  f"({record_to_delete['type']} -> {record_to_delete['value']})? (y/N): ")
                    if confirm.lower() == 'y':
                        dns_manager.delete_record(record_to_delete)
                else:
                    print("Invalid record number.")
            except ValueError:
                print("Invalid input. Please enter a number.")
        
        elif choice == '6':
            # Switch to a different zone
            selected_zone = select_zone()
            print(f"\nSwitching to zone: {selected_zone}")
            dns_manager = DNSManager(selected_zone)
            
        elif choice == '7':
            print("Exiting...")
            break
            
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()