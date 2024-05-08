Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6726986AF4
	for <linux-unionfs@vger.kernel.org>; Wed,  8 May 2024 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715181185; cv=none; b=JzftIYcF09qCrB8UrwUCjCMVbaXfgFgjYI7DsACRlY8vJ08WvFqK28zCYq+AHwoGoLAWEV4Jfh00E6+cHXmSF2oisT3Beg0RwyvMBRsuVUM3GxP6Jj8swA4rmlJWEZcefs7d67sNJVKkqRl4NRQR8eMACDtG3/UUEYGBh95junQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715181185; c=relaxed/simple;
	bh=VTooLKM1UWVTk8gSGQDqgDwStVWBUyMdaRzHq8tOcbs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=L5oqXMtLDCz/mROLTfwZkJGUJ4KC4uULoPRkw7b5sSOo0pGH/nQqLd1OtSsMhFhy6tTTqzLNb61es/pkGXuU5cTU/ascxwoS43arIpif1vTKtBbpL5IrMOhVT8bcGwETcj8bIDcioTH798s5aK8ljAWqiMDu5zFgKA4lV08KIaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7e18170ca14so235532039f.3
        for <linux-unionfs@vger.kernel.org>; Wed, 08 May 2024 08:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715181183; x=1715785983;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEBdO5/t3gWQndQoUbCFMwd1dlzvgeFuNRoAmahB4YQ=;
        b=jdg3VGoC3f8HiJVPFWlxYqB0n/Hub6q9PGVeq1YsT4jB6OW5/oDiWHsmPRD8Bv6GEN
         CftUkJdaheFBWeyj1qIx4lwqgpbu9AQN9UR10dRL1Qw7xtkLb267MTKcYKyXisXzQTau
         HhDcoSWcVtSwfCNMq5HmJsH9D21Yt9KsREIMvD8giyg7w7aiBnZKZQLcNqyRWGFxCUZ2
         PQfqUL4saHn3cf1nK7Q6DAw3fxVq6IToKKcGKEuzz2kw8+7exjPziPd9cDAualIgDv2Z
         3SzUsSJejWmqCqCpvktcHQ4gwL8x9MbR/CVOZ+TcmqDLjoLhGOOwZEg1yrIPlFy2rnpz
         1ahQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhaE5DC/FX935yYJIS/IcWSwm1R3fdG6mQ7+UWLcGwKuUsLTo+aOEneOSNzDdtVoE+OfV3PG4k13VMy2btKsILezGykYCdhSii9U8dXA==
X-Gm-Message-State: AOJu0YxOakCTBZs+xHonxRpGveI2KqYeepYGZZXmGOibo3XB/C6HI/S+
	dk6Qsw9Ba0Nb5dQSsGMPbBz+iylPi2kcFyky3iDtUZN2Lar3OxW5e0AtlChbFLbCNOPDhUyxsq9
	b9JroIHnc4BMFrnRBiphEvom/TS+4ivG4fFW2SxZ23jq+kZcsvRBBmIY=
X-Google-Smtp-Source: AGHT+IEgJOu5ZVCCFED8YRbF5GZ6UCcgUorZLjp//7D8s5IUYcamXViyuOmXvu9So1WH93R5xeRN4nyaq37WLksFXyCFnIm9g7Cb
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8325:b0:488:ac5a:7fe9 with SMTP id
 8926c6da1cb9f-488fdd777e4mr155178173.4.1715181183643; Wed, 08 May 2024
 08:13:03 -0700 (PDT)
Date: Wed, 08 May 2024 08:13:03 -0700
In-Reply-To: <0000000000006399c80617120daa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d41840617f2bd39@google.com>
Subject: Re: [syzbot] [kernfs?] possible deadlock in kernfs_seq_start
From: syzbot <syzbot+4c493dcd5a68168a94b2@syzkaller.appspotmail.com>
To: axboe@kernel.dk, gregkh@linuxfoundation.org, hch@lst.de, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, rafael@kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 1e8c813b083c4122dfeaa5c3b11028331026e85d
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed May 31 12:55:32 2023 +0000

    PM: hibernate: don't use early_lookup_bdev in resume_store

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1380072f180000
start commit:   dccb07f2914c Merge tag 'for-6.9-rc7-tag' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1040072f180000
console output: https://syzkaller.appspot.com/x/log.txt?x=1780072f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7ea7de0cb32587
dashboard link: https://syzkaller.appspot.com/bug?extid=4c493dcd5a68168a94b2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1134f3c0980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1367a504980000

Reported-by: syzbot+4c493dcd5a68168a94b2@syzkaller.appspotmail.com
Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
