dashboard "ec2_instance_public_access_report" {

  title         = "AWS EC2 Instance Public Access Report"
  

  container {

    card {
      query = query.ec2_instance_count
      width = 3
    }

    card {
      query = query.ec2_instance_public_access_count
      width = 3
    }

  }

}

query "ec2_instance_public_access_count" {
  sql = <<-EOQ
    select
      count(*) as value,
      'Publicly Accessible' as label,
      case count(*) when 0 then 'ok' else 'alert' end as "type"
    from
      aws_ec2_instance
    where
      public_ip_address is not null;
  EOQ
}

query "ec2_instance_public_access_table" {
  sql = <<-EOQ
    select
      i.instance_id as "Instance ID",
      i.tags ->> 'Name' as "Name",
      case when public_ip_address is null then 'Private' else 'Public' end as "Public/Private",
      i.public_ip_address as "Public IP Address",
      a.title as "Account",
      i.account_id as "Account ID",
      i.region as "Region",
      i.arn as "ARN"
    from
      aws_ec2_instance as i,
      aws_account as a
    where
      i.account_id = a.account_id
    order by
      i.instance_id;
  EOQ
}