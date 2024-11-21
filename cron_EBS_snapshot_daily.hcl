#Task: Schedule snapshots for EBS volumes.

resource "aws_ebs_volume" "data_volume" {
  size              = 50
  availability_zone = "us-west-2a"
}

resource "aws_ebs_snapshot" "daily_snapshot" {
  volume_id = aws_ebs_volume.data_volume.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_backup_vault" "daily_backup_vault" {
  name = "daily-backup-vault"
}

resource "aws_backup_plan" "daily_backup_plan" {
  name = "daily-backup-plan"
  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.daily_backup_vault.name
    schedule          = "cron(0 12 * * ? *)"
  }
}
