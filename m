Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4208632A
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Dec 2024 11:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734608284; cv=none; b=OsM0QmU3avFJCK4W9jdFG6zwfLoQr6qpaU4dqV5IZdzbZC2ck253be0I6/b3I85/633z71gzLcydvin+V3Y3bqY+9AWfCdIbgghKpFFS44K82mJ7P4dmVCmtR2OQ4QUbfsbhPJiHN5pjTM6QDPdII8g0ZQ17pW0QNl82ySHYYHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734608284; c=relaxed/simple;
	bh=2Yu/b0fUjHdpCL51upFxNncYYiFRez/NHuteOge5uRA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=vFF7nhtkDdL5R9vBlfVa+2f4eR3h292xnqf1Kt3NHIRvwufQf+Mrq/kK2XqGCm7jaqfPZ1KwWMiWn3PU75JJdw/TEjZnC0fB6vnZhpdWTEwhNDNlg/ZAh+Deo/R/wO2V41dsM5P+XVUSMF7cFDe+tqr1DLfJE3RJ8gLRvp3pba4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a7cf41b54eso11856835ab.2
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Dec 2024 03:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734608282; x=1735213082;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c5AhmibNV7+VhVLJRbpswViHF4wllq1oqP/2KyD7Y20=;
        b=orukHu/VIcLHjtbrJoFYWjknVagiURLzod37coS/0x5fkvNIsp0gptUb0CzjUC/zI8
         0L+DV4GbEUHVdV394ZcWd1oESyKSEJABNQy5b6PxhOCxB3qotlpPq9mo89UEWeBFBlYC
         1FEmOWsDVKR8XJ4bEk3AZD4X+ID1I3Xlpe4nJfrUDXbbX9vG71hg7TVydn2QwQODQ8F0
         nxCCcFLKLJ8DD/x6j151Z4x8ajKvHVZg2xwMUD1fF2dcAFObSQI+JxaDA7mWBiJAmt8n
         5M6+Gp+IBC62iRKx7Ol7cAfEGmx/ERIXNcasp/oGAQbBHAL6Ar/AlQQRdBbw8mIKx/Y6
         8n0A==
X-Forwarded-Encrypted: i=1; AJvYcCUlPBsSrgr3BK1MGvylzDWk68gWmlXvXprI5ut9AoUibyjzV1kWP4O9a874/iRa2sVGXNQq/c5f6I9/pDHc@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy5kFCAfeJFjiib6m04CuTe+rWfk1mp5zcqjaX9nfwtkfI1h1f
	Xlh/fL5994OW8evezBzHcR3VGCipjZh3PYZ0/J2fmOt62LE0cBPS7GllNReiAhvHUAw83/4aUIz
	ouquB+t7z/krFkckeybaA/jRzGtcsXggXzvsOxD04EsIJYaDwNWQB2NQ=
X-Google-Smtp-Source: AGHT+IFQqJkJ+KObl60GH8Y1NG6T7FNcxOcunSiI+iFzHwP/ZJKXWLSI4a3ujjMUSwAh2afOG4fgjLMwzm0aYdANPIM7drWJC8Aj
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d94:b0:3ab:8f76:bcfd with SMTP id
 e9e14a558f8ab-3bdc4f18011mr69391195ab.20.1734608281803; Thu, 19 Dec 2024
 03:38:01 -0800 (PST)
Date: Thu, 19 Dec 2024 03:38:01 -0800
In-Reply-To: <CAOQ4uxg36w5rE6RgOCLBqbPsmytJ24cXhhahuQE0H8pqSZ_FJg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67640599.050a0220.15da49.000f.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
From: syzbot <syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Tested-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com

Tested on:

commit:         e42bb34c fs: relax assertions on failure to encode fil..
git tree:       https://github.com/amir73il/linux fsnotify-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=10674cf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c9e486c6802437cf
dashboard link: https://syzkaller.appspot.com/bug?extid=ec07f6f5ce62b858579f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
