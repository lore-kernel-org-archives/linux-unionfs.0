Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F078B1BC39
	for <linux-unionfs@vger.kernel.org>; Sun, 17 Mar 2024 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710683886; cv=none; b=g9I29jhJhap9for70b91nFKDjugtj7/qB6cgojphhwJZhkdgYAhBBDkXewKjAaKp/XKha0Z08GV4LA+brzUMkOlryUtHLUwpKUkm14xbDU5ip4SY2/5eVk5e9Q3aP4K/2cF6JCQjjHwXmlEn1ZQCdUnN6CRxzj1nNTA7nlg4h4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710683886; c=relaxed/simple;
	bh=L9G4HDohrXQuIakqxZZFzidXl1q6Qm9FtmslfgpyzRk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hCzVFhAcntkovZC3UeeKREPODEkoxYyJL0Geqnya07mVyni3XxRUBUWNfKvNWo5G7wgy/cZswCnDdwhQ/7IVGWoFmv/AGwUC+0ZbK7efwmunnTk6OMM0iD+KKXvBE8ldur1UvxJhm6tYkxrvVFzbEKak+vB7pVsK2UMuyq83sCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-366222a4ebfso40062175ab.0
        for <linux-unionfs@vger.kernel.org>; Sun, 17 Mar 2024 06:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710683883; x=1711288683;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eD5+B9KN5f6+6XpRxSKGiUG39g7Rk1aFKdCD3iKDsCk=;
        b=TpysEoppclByrDFiMQTvcI6lHdjnjGpYUcbUPLgLb4TLxYA/8DKPAvN9/sNOdwmGgg
         1NPsCLRrGiK16ZB+BouYx6DtSzRtaIu3VkQjY0ExzHop4i4BztfwfYnFzNz6/6n0p1Js
         4x/R89LN8uiocDIfR3hwjAzui0ZI1nWJrxxwxr3S3IR1EaIeZY7Qu5CVZlco8pN75qiL
         tER5vvPhjNAV4fneV5NixTy6YNEeuGHkL8vRoIpT/4bdrqIpz41C7AGF4+OgeSpOzpRb
         k2BPsTcj5ZV2nBGAO+AJXe1Ex/S0Z1yuGfhLGeB/cVSQajJfbjh+9kXGzkzXNAR1jtNH
         pU6g==
X-Forwarded-Encrypted: i=1; AJvYcCV9DIqmv5FXL9TJKKFGWtBolqwBLLB/47xqboLEF+MI6zPgsq5hEIDdRtVGz1sMrJjA+UbKMv8xa9jGCdtOzcIK5YYvgohgd0PgFcWIZQ==
X-Gm-Message-State: AOJu0YwmCH1pG7Ll9R1tJ3/6EHb7QpiEAqQWhQHYMomuMPLFI7EQdITA
	OKYqp+1q7tEY5beAaFeN6z0m9t/qvTGGjtWltkiu6VKoTc/AnWaEzNwgdBNTvjS5oFNXpJIN3dK
	HhVSLm3oWUUwFDpfk1zfpyuXKh4k74wqVpIxiu9JVtXwNYIsv8ctX6RQ=
X-Google-Smtp-Source: AGHT+IHPul9WGgkKqm7B8jSCs3hOp4iNttQYvYYPfYn6tt6kgff+bf7Kr/d5QUuiKI5Un4eH0JnQ1vAaB29H+fcRR2HAvVFMlWKf
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5ab:b0:366:b26a:ecb0 with SMTP id
 k11-20020a056e0205ab00b00366b26aecb0mr38488ils.6.1710683883125; Sun, 17 Mar
 2024 06:58:03 -0700 (PDT)
Date: Sun, 17 Mar 2024 06:58:03 -0700
In-Reply-To: <CAOQ4uxjdGyN84GV7rA3FTWYzvSTTY6+bza2PvHn2mNpHTPfxFA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d50840613dba1c2@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_copy_up_file
From: syzbot <syzbot+3abd99031b42acf367ef@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+3abd99031b42acf367ef@syzkaller.appspotmail.com

Tested on:

commit:         a8d73a85 ovl: relax WARN_ON in ovl_verify_area()
git tree:       https://github.com/amir73il/linux ovl-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=14d627b6180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2271d60b0617d474
dashboard link: https://syzkaller.appspot.com/bug?extid=3abd99031b42acf367ef
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
