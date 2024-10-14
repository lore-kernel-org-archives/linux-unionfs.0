Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450321AB6DC
	for <linux-unionfs@vger.kernel.org>; Mon, 14 Oct 2024 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728921544; cv=none; b=V2XyG0OsM9eEJU0IjZIXrhJ+EuGC7y060HAKU+B1Wo3gxJf4V8KlhezMn78xT6ZnNbfu6jTtRLLnt1GQ2jucnBi/8cOIzKVXlc2Lt7CEXwZNnEMoBMVsw9K+hZiBI9I+WMrXpZz44wi5v1WcHwdUQ/j97iYQ26BOxyQdpWpuL4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728921544; c=relaxed/simple;
	bh=yYjCjnKyWWEhTK49Z7J9QBWqaLavJtlsumymWwDexQc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=a8nBpn18nklKwqGe37urMBtb4N5Jij7HwmSJbhwBfqCEAShz6Q4a6I15bo/hubgl02k3MCj7V4aQgIgcm2HdDx0iRM26w8v5j8xN+Hd+H10LSrWiJGwmucsjGIHRvHlFH6obLANF7cMpydTnrrko2vXIRqbkjaE65FtETaUKViw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3b7d1e8a0so20677555ab.0
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Oct 2024 08:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728921542; x=1729526342;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2B+oHb7GsvncoATojUDsI07bjYeVlJ7EVCHHMvtLChg=;
        b=LULHk5kad2WSnFpYg7XQI3cv9guU5+vWhcdMWzPaDR8dri4U0sXAH//2SMw0sU020i
         5uu09o6rp8oEjZqdHbTFRMzHNaH2kkI2B6ghS1WytjeAiE7GVLnV4ysPs+hl1LJJLt7L
         XGuFWtwMgBbPrFUqCkSy2KjA2n8cDQ80PiSHbQkhUXkmEiMmpddkU4Fb1MwbXh61fBUc
         a9ROY9RGh8dFaRxXCEvYCh6quWEZpNP3aeKiIwKu3ChgUkw7t5aeCd2HPYb0xIRvsZvk
         Fm/C/yIRl9Gntw9BS4GckpIruaqzuR6w5zVa9fwPi3r9c+b7hJb4ZYmvjzBiAzb7OGt5
         NFYg==
X-Forwarded-Encrypted: i=1; AJvYcCUOI7Mjj+C7EqcDdWD/PoK6y/qKjKIxtUOt5fbsV0soAJt/9CXJ3iaLCgXX4CeRCHNmy5BrwB5xc38hNzM/@vger.kernel.org
X-Gm-Message-State: AOJu0YyJgYG/3g5IBnc70GRo5dS9bW2CFbrYFJpAVj11Am2uzEDBdGrY
	HfpWPZVIJ2rhZBEYaAIwLD9TkYmn7NBAOABRqtLYY0fXI3pcvJwk+Bqi+WHIwqk7xYx5UVBdXoS
	ePne0x1WYawD/Koo44NgbpyapAJ7uykbdZ8FIKurRlmr4npxwYdM3hiE=
X-Google-Smtp-Source: AGHT+IEB1o9aRPaI5CycKDs1+XfU4SzSOYp4i6cVka7d2UQwciHA67ck89wKCzhAaiBHOR+qNO/WaHGYCOzckPXIK36LJoz2VZj+
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2167:b0:3a3:983a:874f with SMTP id
 e9e14a558f8ab-3a3bcdc6bfamr71677955ab.12.1728921542422; Mon, 14 Oct 2024
 08:59:02 -0700 (PDT)
Date: Mon, 14 Oct 2024 08:59:02 -0700
In-Reply-To: <CAOQ4uxgbKV9q9WVwrwv28ucAEUfh1V7T+gqe6euTm+b_+TcG3w@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670d3fc6.050a0220.4cbc0.004d.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_real_file_path
From: syzbot <syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com
Tested-by: syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com

Tested on:

commit:         2d66a7ce ovl: convert ovl_real_fdget() callers to ovl_..
git tree:       https://github.com/amir73il/linux ovl_real_file
console output: https://syzkaller.appspot.com/x/log.txt?x=15a3385f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7cd9e7e4a8a0a15b
dashboard link: https://syzkaller.appspot.com/bug?extid=aaf95b6e8fc9d906d8a7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
