{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeInstanceInformation"
            ],
            "Resource": [
                "arn:aws:ssm:*:*:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:StartSession",
                "ssm:GetConnectionStatus"
            ],
            "Resource": [
		"arn:aws:ssm:*:*:document/SSM-SessionManagerRunShell",
                "${arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:TerminateSession",
                "ssm:ResumeSession"
            ],
            "Resource": [
                "arn:aws:ssm:*:*:session/$${aws:userid}-*"
            ]
        }
    ]
}
