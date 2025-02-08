Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA0218CC08
	for <linux-unionfs@vger.kernel.org>; Sat,  8 Feb 2025 07:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738999508; cv=none; b=qCEs976sSH0NIDAYF/Izs6iirhasYMFAhGZBuToWuIze+M1SmVLmyE5f6w2quSLEW4hoGd+PY3Z/qte51nFN5VLXxZqq0I3KlfGR795+nrmW144jSuNoz9kcblTM2zqUuGMfOSUjQa3bSP5/OWxp7vLRZwGQW6Nodmai/S5V7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738999508; c=relaxed/simple;
	bh=nO3hchjOsaP1RONuy97ZQXYJfj/XWV3o1xs5m2QVd2Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BBNOh1qXBzz5xnpW+hcygJfc/RfUnxuFOHn2ghdZyY/G4CpTSNXFb0cmjmJcMCtN56FYy8xRnHdJiViX+B6hZdJxfH9Rm5xWmZu8c+T5bVC52bUI8nM/g/V0vOtcxZYYnAPKd7HJHaI6CxKVN8Ae7nuchckVqBCjsNjHtZ5RulU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ce81a40f5cso51197635ab.1
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Feb 2025 23:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738999506; x=1739604306;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTLH3DE1scVq8ZV/C5ZLGjBap6ga1IZ5cXcRDj04E4E=;
        b=DFs4yPkMKxeM1gDrN5ifXC2z4XnX1KsjNAcRsER9JxuhiJh+Pi01tUgQgcLqO49Z05
         kr97OrpZ9HHLUAHdcYhKMdAQDMa4VcI3f0Eif0Je2Vf9PfpewPEyl6+7eFZ32aV54pSO
         2uFCZGcN/4WsLynd2okr+tJ2kWIaTL79HDA988ZaH0EMA8KrHQjSx/XjiJImHrB6mLBg
         uMuGrtL8PXlRrUUvjk7LxJTApTmVIf57xVFZsYfRXr2SjfAqguT/rl584Sme6Cw75eRN
         10LrAE4SP9PW49Lq1EIbiQhGwr8l/ZVU5bcFQfQNkJOXQzEH/p56a9aQn3CtIG+ASSy5
         Dp9g==
X-Forwarded-Encrypted: i=1; AJvYcCWVPPmhfXULasOuUv6og/MH+MzxU5TwKMcajJyTZX+LQgIStLn2ciRQcT/o2C8kWXMc6HQnMBIGTIFQOcy0@vger.kernel.org
X-Gm-Message-State: AOJu0YyWMVrvrGfs2NsL1hb6bW3Yr3nR0HDzhfLprdEAnAykUxdFPiMJ
	o3e9/ccYouy/qLva6lUtQBVcqLE2dSSk2raAZf0wXrveO9I+mV9RXXaK+Bw7VrLG7mwrQCwFv1G
	XVnrcwEWpVV+4Dw2YO33uaRzJOV8bjsT8RK0sdmx8mWImm+gEtf8/690=
X-Google-Smtp-Source: AGHT+IGKkh/0FawH2W86AI8WUkzUTbydbSlAtwptxUOjYiSCq8r5MPZ/xLAa/+mPU/8D2xKFQdArsfXVcM8/oj6kp6MWTlj6YvS/
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:481c:b0:3cf:b626:66c2 with SMTP id
 e9e14a558f8ab-3d13df546c4mr45042965ab.19.1738999505985; Fri, 07 Feb 2025
 23:25:05 -0800 (PST)
Date: Fri, 07 Feb 2025 23:25:05 -0800
In-Reply-To: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a706d1.050a0220.3d72c.0020.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in clone_private_mount
From: syzbot <syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, lizhi.xu@windriver.com, mike@mbaynton.com, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit ae63304102ecd597130ecea27395739a6a6371b7
Author: Christian Brauner <brauner@kernel.org>
Date:   Thu Jan 23 19:19:48 2025 +0000

    fs: allow detached mounts in clone_private_mount()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10cb5ca4580000
start commit:   808eb958781e Add linux-next specific files for 20250206
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12cb5ca4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14cb5ca4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88b25e5d30d576e4
dashboard link: https://syzkaller.appspot.com/bug?extid=62dfea789a2cedac1298
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16346df8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117e80e4580000

Reported-by: syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com
Fixes: ae63304102ec ("fs: allow detached mounts in clone_private_mount()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
