Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28050FBE3
	for <linux-unionfs@vger.kernel.org>; Wed, 20 Dec 2023 04:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-35fc8389a58so4866615ab.3
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Dec 2023 20:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703045585; x=1703650385;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RbIRtxKG9SQkDjs+Z7h76sXDUO1uJds9y6Sy8ONpjNg=;
        b=LjIZaV2LrWmZ/6humbWwTxFSFXQBvQaWbEvYM5V8T1CFQz3ScfEyGNLsAYyUBQiLnc
         hTRXSpAFyA01CNpscPCMORhtoipfrbbGSusxidh7gjIWbawmeVe/RC9Uc3V3tDiVcqIs
         2gKN9goL6xza+ggdcuM9Fiq57mCdvRmKjAaVIHZzCuQCMiLiTbG6ocULVP0f4dHUpeK4
         x+TSyapbhVrKFtqmN58Nipa3lJWSisjQaVHkhK3bJ9kj5H3S3CMuwJWFWwTBAHRLiiCc
         hMcqvQpputrRJJ6meu9bQMWc+A2cRNLn3SprCq8W/NzWziP56pitE0EXyM4oIL1HVbGj
         tjfA==
X-Gm-Message-State: AOJu0YztR6I8zQSp3pgO1yZ2+cC8/4CG2+t7o9th1Rmu9BjXrq7CPBoX
	VC/yVmAvEmlwUJOqmvdwkpJwOSjBWn9LbuWlwWmUi8ukI4WM
X-Google-Smtp-Source: AGHT+IEz6EcBkaU6ZP6Uv3nEyANRnpGKfTlBukSjkw+TwT1c3hl3WcrOqMWNSzDcuvPwYiyY57+IHjXczOzCnJJcgH+F0CK13UeA
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cac6:0:b0:35d:642a:dd2b with SMTP id
 m6-20020a92cac6000000b0035d642add2bmr1055484ilq.2.1703045585422; Tue, 19 Dec
 2023 20:13:05 -0800 (PST)
Date: Tue, 19 Dec 2023 20:13:05 -0800
In-Reply-To: <CAOQ4uxiUoWO10a7UH5UweQ_1f+Fu+jSKPO66yAv80izyx9hBGg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000027d0d0060ce93328@google.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in seq_read_iter (2)
From: syzbot <syzbot+da4f9f61f96525c62cc7@syzkaller.appspotmail.com>
To: amir73il@gmail.com, axboe@kernel.dk, brauner@kernel.org, 
	dhowells@redhat.com, hch@lst.de, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+da4f9f61f96525c62cc7@syzkaller.appspotmail.com

Tested on:

commit:         d9e5d310 fsnotify: optionally pass access range in fil..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.rw
console output: https://syzkaller.appspot.com/x/log.txt?x=127b3016e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5300d21645bcd09
dashboard link: https://syzkaller.appspot.com/bug?extid=da4f9f61f96525c62cc7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
