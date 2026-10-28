Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793162025;
	b=twRV/mEyQQ2r+0Nt9fskS9JxKnhCG0zYZeDNuuLVSbWgeJQS76Gf3bPdJVR0hMrqEuQx
	 6NlS6Q35GjisXpy/RMdUWnZM2I+NI/hq2U3OjPxZ1frGv6i+y1eWA0qKLfyCZYIIC+Rsl
	 c9B/+ar4b7arktixOvOrgbSfBz8pshciKukuQETKNJYPw+tJqGDdHrEZsACFCFbNJXkzP
	 1wOhNJ64k2qlAOPUTnh1PQWzv90DtfwYxbDYG23zzSgPp10Hl8S0F4dYJUSBcDjYya0fH
	 Zpgoo1gyl4ql4z7GaKwKzra/NCAauBu4lk7oPo7BhXMGiyYKLEDtyN09L+gH/kcmuIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793162025;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=wT66TGIvpZCHrHHE05hEIvqStnKLFFiHYFABNX90Gc0=;
	b=yBHqe57OF8F+m5onq6SPsNVhv66OF2yla8i7g3bgC/9IAvZsjHlHgbicoQBPFwJahIz+
	 lWXBovc/5BMhRxyf1RIZ38vzABNDsEnvZwc+5Qw+9IO9XSUciqnZxe9GrI3HBkhBW2IC2
	 YD9Vir6BCQ98BlTSYrA6BjRkNfarXi8US6vmJxzkErqfp5TC/MJhrPXdcjMTKpl95p70k
	 VtQ7gkZdawLy7sS6X1saGi6rg4Rh+q0MwquTwRzjoa8Vsm8PTfu3eW57TwLCd6mhYUcX4
	 LQ+dC3HvbjoX9OVd7kAL0T/mThfNHv+JrWZR6y1C+y1R74rUS3FuYsQWdDl3A7NTcdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD34606A320
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 04:33:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCD34606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4cbf700ddccso602901b6e.0
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 21:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793162024; x=1793766824;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wT66TGIvpZCHrHHE05hEIvqStnKLFFiHYFABNX90Gc0=;
        b=ZSO8xVeIZs4Ykygb6iK5qcbq0HKUmNedRz8WuIjcGF1+DUXopjU4PQZsyIsaBuzMt+
         1eqzm5ng1pHbay8stS+QDwNTzAb+jIT8hbk8yqANv3nLyCqxe9IMe8AZKXa7NHiWlQjx
         WRpk9lNEQMYpTDvFEg50abgFmbHySH2NFqAgrLHv2s94GvRd0V4ihlljTj/nURsoNv0j
         4xi2XxWw/+4x+MqMBvJ1z7W4GuQahvhaR+qf9nfhdSTAKZknCh0n+SChazgJ7Jlf8bTE
         eme76JS9IHG7oEz5NW81Bvhc0Xggi97ywaRR+GirlYGQiUdvUylCfP+0Dg2rsWvmIJlZ
         lcRg==
X-Forwarded-Encrypted: i=1; AKwUvBy2+Knshqdo2Ir8juUDIZIMq/uVC5e1oIwAdEtbpk+orAlo6fx5qpzZAv+3Ar6cTvsvVlphKtvEsctpH0mE@vger.kernel.org
X-Gm-Message-State: AFq9FYI44w3ATT+VGLzdWfc+L8+d+ujLJx65KcRo84yfsN8PbSbNTQdV
	lHQLkSayohAVJMtVJsDBie5VHcjNsSYeYS7O75jRW8Px9cO67gKaSzyW03DHAsmT0nU4788omZn
	3Fv58opdfbmSbR+ho5sJ9LxgW5ZBGnQ0kqzbrXtWHvvgwWtFAjCPiC1iO6IQ=
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c133:b0:4f5:41f:fdba with SMTP id
 5614622812f47-56382c82ccamr833659b6e.20.1793162023919; Tue, 27 Oct 2026
 21:33:43 -0700 (PDT)
Date: Tue, 27 Oct 2026 21:33:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae17b27.6200f071.51519.0f5e.GAE@google.com>
Subject: [syzbot] Monthly overlayfs report (Oct 2026)
From: syzbot <syzbot+list5b4fe76f3e4e41f927af@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello overlayfs maintainers/developers,

This is a 31-day syzbot report for the overlayfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/overlayfs

During the period, 2 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 38 have already been fixed.
There are also 3 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 276     Yes   possible deadlock in __d_alloc_parallel
                  https://syzkaller.appspot.com/bug?extid=52aa59fd5e3cd8a19dd7
<2> 74      No    possible deadlock in pipe_lock (6)
                  https://syzkaller.appspot.com/bug?extid=603e6f91a1f6c5af8c02
<3> 69      No    possible deadlock in iterate_dir (4)
                  https://syzkaller.appspot.com/bug?extid=7c4b3d05083880a09cdd

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
