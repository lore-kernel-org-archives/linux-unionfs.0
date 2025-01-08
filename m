Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6401202F80
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jan 2025 20:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736368926; cv=none; b=rTthVn95iH3GTmWHL5OWQBfq5Hk/15yLZd+ANtyGa1hTTjxBidTxsL54UcK4xhWP/dkVcDm8Bw16dWcwKDXoLE5R919fG2VLfC5UcyMjY58snmjVuKQMZYsarPt8W7RzeTBcjbhbEeSH6DaSIJwfApG5e0PEbwOxZ3UqyjBC5FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736368926; c=relaxed/simple;
	bh=rJ0PBgRJ8JQ65hZJ2DfAQJvAcwVTjGP1dqjfW1aqmOc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Xc/q3b+f5dl7dp0xZbDo6j7wcuAutyD1MESrIz9GX5gFM5z96oUvqD4Ag4TpxwyyNYVuvCU6wfR7O5Tl491o1m5W0nsx1+VlA4QP9iexR6p5c11F6dpT4Ov2NzQKOSLj1mMCsTkObWhFAHzcKEdbqhqZNfcoWwX961pz8OTMvus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a7e4bfae54so1648955ab.0
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jan 2025 12:42:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736368924; x=1736973724;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNs6O3kkr3r5I7w/dw3fJq7XUHf1uqk5MiUvua0Nv68=;
        b=FhUtQiBi8FWZaZQUTsCTRY2d4qidLXZ0mM25WCutfc5fI9XVicP0jNH6LWm0rUJXi/
         d/vEj/UEwAfX7UQ2xxW0k/3nTGAl9a8oJg7u40lLspF3W9Je1hbDTq1KVZCkwc46U2Wg
         opClc0OxuHavIErQjfNpQmsOp6Z5mDETihmQggVH8XjWYwiuV95L71OdlXwqoyDUVyI/
         3GPfDNAzjBopYfudMjNu07s9Cufi3/61ELNpF3SC1uu07iyU8XYRKkdKePeQS3iWMgvD
         TGQ5FOZ9WouPUDG50GnWc6hbOwk5DiJ/M5fAfgJDmBNN2F/qKfC1ZbwmVh46g1gMTjAf
         Qs+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWvazsd7dQt902/JT8v6iapdK1rWwyfecreZAwJ8751XHlKEts3IsD8oZ53SBfhVDNsdLpUz1SED1QGjGhw@vger.kernel.org
X-Gm-Message-State: AOJu0YxjrVZjf9inOlqMRhncC67/J9Z5lHdRI7Krk0SNDnK/MlieOB+E
	nuE1DClWVEaq7mYCVWVh0qoBGNeFtSfdCPA2m9K7+VR7KGgb8RsLx2pP9ZS+AKR0tn/30c3m9K0
	D9IVc/hcgBegn/D289sJlRoIlleRALGaZJLH4UEERNnGfaUpHHgpCsaU=
X-Google-Smtp-Source: AGHT+IECo9lGm603Dk8vIUiGK8QpkBSx6h1ErbJnWMSVgNgDWyfFyYFqwgh99vQBrvmYiQIujlLwDkp4H2G7ucDx9e5v5WFae6xI
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1605:b0:3a7:e800:7d36 with SMTP id
 e9e14a558f8ab-3ce3a9b9cdcmr31182255ab.10.1736368924026; Wed, 08 Jan 2025
 12:42:04 -0800 (PST)
Date: Wed, 08 Jan 2025 12:42:04 -0800
In-Reply-To: <0000000000003d5bc30617238b6d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677ee31c.050a0220.25a300.01a2.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] BUG: unable to handle kernel NULL pointer
 dereference in __lookup_slow (3)
From: syzbot <syzbot+94891a5155abdf6821b7@syzkaller.appspotmail.com>
To: aivazian.tigran@gmail.com, amir73il@gmail.com, andrew.kanner@gmail.com, 
	kovalev@altlinux.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit c8b359dddb418c60df1a69beea01d1b3322bfe83
Author: Vasiliy Kovalev <kovalev@altlinux.org>
Date:   Tue Nov 19 15:58:17 2024 +0000

    ovl: Filter invalid inodes with missing lookup function

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ef4dc4580000
start commit:   20371ba12063 Merge tag 'drm-fixes-2024-08-30' of https://g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d806687521800cad
dashboard link: https://syzkaller.appspot.com/bug?extid=94891a5155abdf6821b7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1673fcb7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15223467980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: ovl: Filter invalid inodes with missing lookup function

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
