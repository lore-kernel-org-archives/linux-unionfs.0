Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BC323B609
	for <linux-unionfs@vger.kernel.org>; Thu, 17 Jul 2025 07:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752738425; cv=none; b=Ey8JNtrmNDwJFdu1PTZSO5Okv19Hu0ZukRh13v1KGKNf1lU6Qlktd8ngAYxeuPmM8aA/+vg5g+svshdqF3+eCSOM2529gEyb6A1izwZ8UUKFHjwnzaWZRFhXy/w/yVA28TYzdAaI5Q6TB3F1ur0aemgdvOAZVfhO/D2PhVvGCzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752738425; c=relaxed/simple;
	bh=oAushCkBvV9QVtlmVzcvZy/T7QeVNIgehZzoxP8tyJI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Z0mHPk4vJgmufb2LTjPyu9FRbQDQxnVOyhVZjoBSUwBB+tCC7wiqxVRj3o9br7hlnt9iTKfW7rbWlKLsWChlQZF4U6wP5Of/fe5lGrFkz7im6hmoZwHV7Xcu/fnHvKCb+VJ8kcPY3qbpAqBmdtIQ1ZMgHCTKOAWRj3xVgGUx8OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8649be94fa1so129218639f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jul 2025 00:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752738423; x=1753343223;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i4XNUZgAi+l283TvCsQpiUhvK+cuI7VeHcRlXxmM9i8=;
        b=i9UAl8TPx4ODpwTPnNNMaTkIUXTpCr+IExSBp21PbkGxyPL6OKu6jNP65VwFavMsR4
         6BdqRIixuYGVY7uljR4lXR0qGSIAZvV6y8i/myoRPRq3CGxJNm0Ba34KRe+LqgfCCbY7
         61pjKwGiZRhIpN9fUzJYc3VuS3xgJoD7pyUi7Q+tc8BQWNlWRXDK5OSSluYl3b6ufbGe
         E+y9/rSECmfGo5zPLYyDG4VhVQQGXE0ICThUDkb3ZO4qM2sYxGxeZbBmUbZx4LS3Rsac
         pZOlBtkp4x9L1FBgsd0rtTGWUMPuT/qeTUu3U3cTsMUbmByAWmGyVcsmVFUBLD/3BXyU
         2qeQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1Ex7MUrj/PwbGaltu2OsxW4CohHEZZzSI8a2BZ2Ad+/E2Tpj3ZBIAKbVQ5jcfvHL8U0YXzC/0jqKpG0Cl@vger.kernel.org
X-Gm-Message-State: AOJu0YwRQfsUL+MXtVmkCAfcZAaQ72Cd2hjdnDo6y94slYysTEs+DhMu
	8ERg1dwK7WQ98MrszmGXeSlrEFUPOaAQbz79TqopbzrhsieJ7QxTuD2LtmV5mIZC5I2rzlmrucC
	+5tGMlv+Wu11i8exGUSGKhp5j/Z078+eYVFxFG7Z5UrEiG6DiV5jUUv5/NnU=
X-Google-Smtp-Source: AGHT+IGz8aHEsyxj7rtahA3L5ydsmqjP1wxPohxhGBIyDbGW2LUyNzgIO3XefJSSds12HTndVIt9ieUIDcFlGhYdL3f9rFlmxmh/
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6c0d:b0:86c:e686:ca29 with SMTP id
 ca18e2360f4ac-879c0892211mr769810239f.2.1752738423049; Thu, 17 Jul 2025
 00:47:03 -0700 (PDT)
Date: Thu, 17 Jul 2025 00:47:03 -0700
In-Reply-To: <6828591c.a00a0220.398d88.0248.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6878aa77.a70a0220.693ce.0040.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_listxattr
From: syzbot <syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, eadavis@qq.com, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, lizhi.xu@windriver.com, miklos@szeredi.hu, 
	stephen.smalley.work@gmail.com, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 800d0b9b6a8b1b354637b4194cc167ad1ce2bdd3
Author: Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Thu Jun 5 16:51:16 2025 +0000

    fs/xattr.c: fix simple_xattr_list()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=173de382580000
start commit:   e9565e23cd89 Merge tag 'sched_ext-for-6.15-rc6-fixes' of g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=5929ac65be9baf3c
dashboard link: https://syzkaller.appspot.com/bug?extid=4125590f2a9f5b3cdf43
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cb6af4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1301f670580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs/xattr.c: fix simple_xattr_list()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
