Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7B21D5171
	for <linux-unionfs@vger.kernel.org>; Tue, 26 Nov 2024 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732632186; cv=none; b=UWmJuj3mnYyFU/jU8ozdIfBWoeeqqaptVY6pON+tDWggGysmjLvzSbYb57QfGvqPqCn1gj4I7i7ZkDWjd4nNRXXQ/QMYupYwGQ9bdqz5cusodQ0wKTXLiZHNg/Iu02+6ywrM6525QoTQYmAdkDlYyVaN0fvXw9w0LIt0x7C41to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732632186; c=relaxed/simple;
	bh=oZ2U+TR3HpR8vr6TU1NLBMPx3jtCe+sz/la9/FkRAK8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=fpoJiZGHuQQrRhBVsqnjHvwNUEg9nlqCS3K8XwZhHQyBH2S5AguqHLkNaLdiYqkwWSC4gD9c7kEi8kA5NjR4rMXeXLALcCJjUhHgfS/fQPb6XeaPkTVfYxt1LLBL/c6WHniy4uBCDO4sy8O6SDbKEV/EX1sDg00nzCkPDFGLPWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a7932544c4so54269775ab.1
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Nov 2024 06:43:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732632183; x=1733236983;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jm9TicSPUToN5ja0H8CfLPul6Rp0mNhRfDIRhAmk84A=;
        b=FvNu6sisWA32XxrIuEciWgtWDfh2nT82moatwUEC5Ape5TyGyWZDCER2wWXtFcA/Jg
         2MaMFyCpiS145435MTEvutHCKMlEm3bmrZvazUsIoQPjM3mALGgNvk/BBVCjECEA+YOQ
         WLK19AUGadFoRHwaD2n8OPhxz0kXR9UOZPhm2WQTABqdsOlFr2Gw7s83dEDrPd03Gl30
         c4wsiOBrpDnUEw4wk8/3XJwTeYAjuRf1U1P9shk3hUKoP0hUyeE1DBVy51zXbedjC6U+
         LV4rpQ4r9uysiFsApmDu8sfl7Sou1i75/g2qGlce6PC0EC71YKfrb1rliMszS6GUpwGk
         /n6g==
X-Forwarded-Encrypted: i=1; AJvYcCVkgMsnKFdEEpNrkOGwXiRXIrf/hUt4Sz8EKBngJoRqSx81Sns5/s5tsZ0zzL2PvECuSrNqs8GlF6v+Ors7@vger.kernel.org
X-Gm-Message-State: AOJu0YxdM1T74ilN6CWNjWOq6ekUL36HtCJXfe1UyLliaqOg59zC6VZi
	ZGiawvD0DhBcGnvfj+ZZhVELKGRSYOfJAJbIIwL3Mgr8SVnmL+zlwcF/6saThu1wx8I9YDk7+2L
	VC+k20+G13vgcjGN3ZnvOnGn5uvSXlDDa3yQk/z2a2mK1RSLo79SBR5I=
X-Google-Smtp-Source: AGHT+IEq64wXQsmpsUQlLvYn2vOFU+udBfQ5L7C2L/up205iGAdxfWd1unk/NWHwUDNiRLb+Z80xYNtckJnO2cIykQB6dE2hmvVA
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1885:b0:3a7:8720:9de5 with SMTP id
 e9e14a558f8ab-3a79acfb902mr228550875ab.1.1732632183229; Tue, 26 Nov 2024
 06:43:03 -0800 (PST)
Date: Tue, 26 Nov 2024 06:43:03 -0800
In-Reply-To: <CAOQ4uxibdcHmnkn15G1M+8Ay7TK_4uB1tUi06+yuPWAze382Lg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6745de77.050a0220.21d33d.0019.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] KASAN: slab-out-of-bounds Read in ovl_inode_upper
From: syzbot <syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com
Tested-by: syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com

Tested on:

commit:         e638d5c6 fs/backing_file: fix wrong argument in callback
git tree:       https://github.com/amir73il/linux ovl-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=103e9530580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afdea6b282c7e739
dashboard link: https://syzkaller.appspot.com/bug?extid=8d1206605b05ca9a0e6a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
