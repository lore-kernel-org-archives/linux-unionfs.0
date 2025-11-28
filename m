Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7142D5C92
	for <linux-unionfs@vger.kernel.org>; Fri, 28 Nov 2025 07:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764314885; cv=none; b=HLgjLgL2sWQ8mflC0cnVaa06/k/NZJgZK+vmiutZ0h3rOd7B/zTlKxru048XqzF7N0mzJS35ziPIzpzEuu2P01sEE0m2FxT/9+GwZQaSAtSr3M3/BocmmIIM6Ad13ZjY1b1hzrfVEYBf2mE/6Rvc8f4VbXRlAlj7DFejDbu6vQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764314885; c=relaxed/simple;
	bh=h+VFGf2qMqWM1tpOmMrrI0z9cHsGUXXoVQvx3t0+sTw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GuZ0L/PHIKk9hJm5S+Qka2akA7b55cbw9nP3A4N1bzHPfBKqgBjyKZIuXkdcn0PPleqCbuIjMc9YpRDE8GDq2lQ6eF+lt407nICS2NQZFt1/A1n89jHoo2/g4vvDywUhc28exuUu39Sy49ZnWGlmB07s+yb9D7TnEfYgr+kLUzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-948ffd40eefso89786339f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Nov 2025 23:28:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764314883; x=1764919683;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWRxmXXesnllpc9IcCeFcNiS0kh5h9neGhzedXrtLNQ=;
        b=gssaTGRHNlzBcKOfhcNn98Zh/yqZIUYOZ200ApPCH1VoldKFEKdRSaRQFzC9sv7gmB
         31/JTC42suU0Yn1K9aJVkzc1dPJacOq7H9C/JfnBCE6MhkMxsn8SqvSemlwMSih07kzU
         MEjOOiBaL7Rj3xC96mll1BXUhjYLtIGnwghtejwxzxwQGbP4Yytz3fFPuJPSpYCeDdEX
         EW6Ye6nTwCITs4Ed+1AnQCSErytnk1uVp3RTAxu8UbDSBeOaaI+sQKOuMcrNEc5pFa7s
         UBdrClQLSmr77VZwOm614izvVlIqVnpXIeoyN3EyRGpXXdAaK713AiLY/IFNLyFma2EI
         Nvkg==
X-Forwarded-Encrypted: i=1; AJvYcCVQh+V3QCkoQ5nQRGae/g43V+0sAkQ8k9SFb8gSUQYrmxsy2bOsPbAKYVesmxeRTrIidnOm503Ei5a3/v7T@vger.kernel.org
X-Gm-Message-State: AOJu0YzTWDedgcUyDzkelwtKkYVcnQvS+zPxb4YS0akMvGeLSCaKpoOl
	9BBuxoR8VGWKvCJLMAmaCpOF9zAbLPdDwhGwHaJFQfeWxUNuCevW6urGz4M6QcjI1/H1N29dxLb
	qIZsLIZ+b/sZWCCCfgzPOfQFXimL6L+/3oufqMbahJkGu/FAV4poOqvqA6NU=
X-Google-Smtp-Source: AGHT+IFwAoNZGqDMP0finGsqreKqmCsP6fnyJR3K4MN32BL2q0YRvJGlWuBByAyQfFoguEpwUHLFsKDJJLZl/ttXQFc+T3ViXyZx
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1749:b0:433:7cf7:14ce with SMTP id
 e9e14a558f8ab-435b986a858mr210249135ab.11.1764314883012; Thu, 27 Nov 2025
 23:28:03 -0800 (PST)
Date: Thu, 27 Nov 2025 23:28:03 -0800
In-Reply-To: <20251128065521.9509-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69294f03.a70a0220.d98e3.0132.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink (2)
From: syzbot <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, neil@brown.name, neilb@ownmail.net, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
Tested-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com

Tested on:

commit:         e538109a Merge tag 'drm-fixes-2025-11-28' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17bc7e12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
dashboard link: https://syzkaller.appspot.com/bug?extid=bfc9a0ccf0de47d04e8c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17af2e12580000

Note: testing is done by a robot and is best-effort only.
