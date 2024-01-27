Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE7B2F32
	for <linux-unionfs@vger.kernel.org>; Sat, 27 Jan 2024 02:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706322486; cv=none; b=ZFohO0BN6UZp/wL/zXYo3V5prgizWH62M8fersOu0W2Ud0QObfim0lHXe/wulJvatGaPlwyLTJPV4Ue9Sl4rVL7+plkubVA3W4Y6wPIEM76L0K6D2O+lJ1q0kTureyQMQIo3XnJpRt5l8e9qpGuGZ884qs3QFxw+FYzOmW3mFFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706322486; c=relaxed/simple;
	bh=ZBY1cKp0LLNRmGaJwlj/p4mIIQlnwkuy2CaaDBrnEj8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=n8WZtiNQ8kvvzqcQSmgPJGtjaqfX4E7x8/ivC37sPsvu0p8NArqQ6QcF6kvhhPClCeH5n0hSpYlaMOIlYmkXrbwkiiKnLTgdMvE73aB/LDJjQKcpoEEqOuqbJuUBL9DXpZ1SlZqDM9lthZgiXvOSD/R6sWDQY2GaMf71oMvGQ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-362a46bf0a6so3589545ab.1
        for <linux-unionfs@vger.kernel.org>; Fri, 26 Jan 2024 18:28:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706322484; x=1706927284;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZTi9r6mGwHaV+mM5bJDyJp7on3c/3cIRVXJx/JYQ/w=;
        b=o7cCvFVoskmf4xW1fM4UGBFa8XiRZiRMgBLrPwEXQIl22BCCAUyDixr9Kj2Vc1E59Y
         uFLw2RIo27W1plmSN9evJUpi3xwkyBlj97YuVGACoeRYnRk2HmhZtuslB9/rUqjynuna
         WnKmYjvCeixIy8Ue/+nRYaIzpPI5nmzSjUzLWgHYkmDNtrd+n0MDb7/fBvuFG5pC5gjd
         CN3dKNinyZ0Y8zlx6YMh9/A0YbQy5HB47zxxVBAZ7uU21+wMG5TRPHrfz8cKIUf4XXcC
         b5oO54FWqr1fCrKj/L/hsqL0X+pXnTBtiZoj9qLMqG3mW73WIET24/hKjwwCcGItH1CN
         clLw==
X-Gm-Message-State: AOJu0YyxhoZALkh6JEQQi7xF8eI9ykVET0Qv/+ZHUQea5ObipQ0uPH47
	ppmvN+DaepdTKFYfAl7ffT880ZZNs1VgAKB7Th9zCfkl4x5BYrt1JcIwHQ50grHXMkoTfM5S2OB
	+n9UBuCx9ano3bRG1xDJurcTsMuSAGCusXRyA6Fs5Vh0Y3ngOs5Tqg7c=
X-Google-Smtp-Source: AGHT+IG06VZMbEHCAwbSAR9zm4HlIu9CCBfB6pPfyZajpD9dWqGxa4/bSzMKXn1RS3hevz4gLqiqB/u8yCKKkwCkEo40Nu5x4amM
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2162:b0:362:b3c6:882f with SMTP id
 s2-20020a056e02216200b00362b3c6882fmr73404ilv.4.1706322484593; Fri, 26 Jan
 2024 18:28:04 -0800 (PST)
Date: Fri, 26 Jan 2024 18:28:04 -0800
In-Reply-To: <000000000000e171200600d6d8bd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000910cf5060fe42991@google.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in seq_read_iter (2)
From: syzbot <syzbot+da4f9f61f96525c62cc7@syzkaller.appspotmail.com>
To: amir73il@gmail.com, axboe@kernel.dk, brauner@kernel.org, 
	dhowells@redhat.com, hch@lst.de, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit da40448ce4eb4de18eb7b0db61dddece32677939
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu Nov 30 14:16:23 2023 +0000

    fs: move file_start_write() into direct_splice_actor()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=105aa1a0180000
start commit:   2cf4f94d8e86 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5751b3a2226135d
dashboard link: https://syzkaller.appspot.com/bug?extid=da4f9f61f96525c62cc7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176a4f49e80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154aa8d6e80000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs: move file_start_write() into direct_splice_actor()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
