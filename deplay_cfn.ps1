Param(
	[parameter(mandatory=$true)][String]$cmd_type,        # コマンド種別(create,update,delete)
	[parameter(mandatory=$true)][String]$account_id,      # アカウントID
	[parameter(mandatory=$true)][String]$file_name,       # ファイル名(拡張子無し)
	[parameter(mandatory=$true)][String]$profile_name    # プロファイル名
)

# yamlファイル存在確認
$yml_file = $file_name + ".yaml"
if(-not (Test-Path $yml_file)){
    print("yamlファイルが存在しません")
    exit 1
}

# awsアカウントID設定
$aws_account_id = $account_id

# Cloudformatino実行ロール設定
$role_name = "CloudformationExecuteRole"

# 実行コマンド設定
$exe_cmd = $cmd_type + "-stack"

# Stack名設定
$stack_name = $file_name

# role設定
$role_arn = "arn:aws:iam::" + $aws_account_id + ":role/" + $role_name

# コマンド作成
if(($cmd_type -eq "create") -Or ($cmd_type -eq "update")){
    $cmd = "aws cloudformation " + $exe_cmd + " --template-body file://" + $yml_file + " --role-arn " + $role_arn + " --capabilities CAPABILITY_NAMED_IAM " + " --profile " + $profile_name + " --stack-name " + $stack_name
}
if($cmd_type -eq "delete"){
    $cmd = "aws cloudformation " + $exe_cmd + " --profile " + $profile_name + " --stack-name " + $stack_name
}
if($cmd_type -eq ""){
    print("コマンド種別が間違っています")
    exit 1
}

# 実行コマンド出力
Write-Output($cmd)

# コマンド実行
Invoke-Expression $cmd

# 実行結果値出力
Write-Output($?)