Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9441F3FE46
	for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716845769; cv=none; b=IbpCRQFHQHXj//A+RWLYpH+LhDQoLAkuwOX7UJQzttthLNGp7OBbKkRADNTgSIzDwpVq5lyk5hsbf4ycquD2oF1P64Qqw3WAZX7Okwqld91k4M2EfN2p768/IIGGUKI39HTZdXXjCYTzOmr8SdahFgmW60uRp27Guv/15SWB9co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716845769; c=relaxed/simple;
	bh=xg5p9I+oP40kmJhXADMlxZAPjvXHHTMarEVG/hmd09E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nxX+HqVCbpHvzDhL7bTQwX4Sh18bVRA0DYjSWgBN/k//u6itDMU7UM5uPe90nyLFKoM7IgsQhogE45gB0E85tpJmswusJdagna/FAtdzk9oygZ+ImYskQvOnsQIqtRir5xzm6OzIvDMiHwk07k0C/rsi9GDgNBFFDwLP4y5ERSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e94cac3c71so21420439f.2
        for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 14:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716845766; x=1717450566;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGnBPYhIToM5CvdNlwOkqkKSjA25/rvGdeWcOIlxVBw=;
        b=Iuewen4kAxv9H29NE7EVdHFzqeSYn2w31koTdohJEJ7YfgmDwu0++xg39fb16me3Qc
         PzB4czZ0igMCcS6rk7muqLs9VAmtcub9eVAcnLY8lFEXIwTQmuW7SRtyb/RjNmPYWlSE
         AL2qzxCNz8PxYnIi9u9bLQmXKhKtxmq46j4RFpzPyN3MR8/nSjQOBkgLCJ4Xcxd8Lj8A
         FQ4a78mRRY11a9JtHCEpOtrKw96iy0Ga8RK8ATEjVxWHGwVzAre+vAZbUdu6cfVwH9Q0
         fBwj/Grfy/yaAHiIQv4mB1w0Z/pLuKYcbwLX+XCjR2ZfCC8ilLsSpmVMAj6buPFZbk8M
         oAqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT0fDZPYZs//uxhRXq2hVpWTOyNCLzaFO+4rdXoHS8YBu3KB67qe07exztp0KVSdTpliSb297XbUls3+CKZUgvgCK3BhF52Eox+2zM4A==
X-Gm-Message-State: AOJu0Ywcjbxd24n7jThF2gZaKbdfcjkYQlDgvbX15chbQPunyT2dH7Or
	EThWjNg40QDkSN2zWiqHSIqYWfclHEvniCKQSES5vLd3ZP3Nb9+zzBMImuqO/DSAHkwp3GvYStn
	mGYEtlf0g6ungX+dielZqTeQ/2im0e3YgfT9z1SfHj3tRrNJFUU+zh6g=
X-Google-Smtp-Source: AGHT+IGF5ftlSVDbRXoxRHrscozfUco3U5VmGiqRYnoCeclwuvAWs6L99ygLz4h+7bPaa9AKbhQaDw4qGRY1xtZYUovJp3h9Xpv1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1601:b0:7e2:b00:2239 with SMTP id
 ca18e2360f4ac-7e8c1adbc2amr32193639f.0.1716845765956; Mon, 27 May 2024
 14:36:05 -0700 (PDT)
Date: Mon, 27 May 2024 14:36:05 -0700
In-Reply-To: <CAJfpeguD5jSUd=fLaAGzuYU-01cKjSij6UbQWy72LDpqK1KQfw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000003a6e50619764eb4@google.com>
Subject: Re: [syzbot] [overlayfs] possible deadlock in ovl_copy_up_flags
From: syzbot <syzbot+85e58cdf5b3136471d4b@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, clm@fb.com, dsterba@suse.com, 
	jack@suse.cz, josef@toxicpanda.com, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, mszeredi@redhat.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+85e58cdf5b3136471d4b@syzkaller.appspotmail.com

Tested on:

commit:         f74ee925 ovl: tmpfile copy-up fix
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git
console output: https://syzkaller.appspot.com/x/log.txt?x=142c4e2c980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9016f104992d69c
dashboard link: https://syzkaller.appspot.com/bug?extid=85e58cdf5b3136471d4b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
