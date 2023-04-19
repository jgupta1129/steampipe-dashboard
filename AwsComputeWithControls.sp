dashboard "my_s3_dashboard" {

  title = "My S3 Dashboard"

  container {
    card {
      sql = <<-EOQ
        select
          count(*) as "Total Buckets"
        from
          aws_s3_bucket
      EOQ
      width = 2
    } 

    card {
      sql = <<-EOQ
        select
          count(*) as "Unencrypted Buckets"
        from
          aws_s3_bucket
        where
          server_side_encryption_configuration is null;
        EOQ
      type  = "alert" 
      width = 2
    } 
  }


  container {
    title = "Analysis"

    chart {
      title = "Buckets by Account"
      sql = <<-EOQ
        select
          a.title as "account",
          count(i.*) as "total"
        from
          aws_s3_bucket as i,
          aws_account as a
        where
          a.account_id = i.account_id
        group by
          account
        order by count(i.*) desc
      EOQ
      type  = "column"
      width = 6
    }


    chart {
      title = "Buckets by Region"
      sql = <<-EOQ
        select
          region,
          count(i.*) as total
        from
          aws_s3_bucket as i
        group by
          region
      EOQ
      type  = "column"
      width = 6
    }
  }

}