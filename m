Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1AD1E1C2B
	for <linux-unionfs@vger.kernel.org>; Wed, 30 Oct 2024 10:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730285531; cv=none; b=K2A6uZQM8pwUXArJfmEPM4n0HfCzprkTpmpPcGgwvzaoTWfbuOhmvfraWdhmgVk9Xcdzna4GlLn0nxrPTP3ulV5kiwEz4vSwcle0SrvvYvICLxku3e/2Q+cxwl1+6ft9hoaj9XNWD1kAc0Vqc6xQx30U4MqlOuJjXC85rbxm9js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730285531; c=relaxed/simple;
	bh=kOe7NaPPMJKT/QbP2BkpWIMAHxP/mCEb+4qfjk7czwg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nEQwjuy6xKRvU9CieTJroVAw0NnnAMOfZZqCDgW+0mKwvNqvdjxIxF6iK41AK8JozzmVuxdyplp7Vxn1AdeSMkxXF09uwz0PbEMlzmSFNUnptKaS7Uw8jTFL23MPeivuOeIruBQBNrq2uQRi0EyGpikQr0ux5ZGCMho6eSbmvzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a4f32b0007so34171505ab.1
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Oct 2024 03:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730285529; x=1730890329;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LeALd6KDuOuKi9qXNLq10f5153cW8xXpkk8Olr/BMoE=;
        b=CVgo0UsR3rNRpoSCGDtQY7XLVVapqlZmu5sc9LG1PV6F3KTpxO53XIhCfCve1j7KuF
         +t/nEa/toniGrVS+JI89KkVM4aQU08SaswAAxp5JWjWLu8e7Fvb4EJsHAP+eEo+Qc1Rf
         Z/16DiHIMmCLZq+RMQWzCghXR0MmnaL94KQcn/zuvzWuDTNmJyM938k2s1qvcNOBN2ZR
         ap2mKhVthvudw3L/daNqAUB0KeatA75oDebH9qVOuNu7M4uZR03FJ2cQN6mvHVAoGEPS
         yxNMvzAJGNn9Uw7vqt39XlFw+shTISEsO4ZsgwFJLXzJruS5W560ixavxLFOmPhRFq4I
         mMog==
X-Forwarded-Encrypted: i=1; AJvYcCWQUgKEpKs/VXdtacZOqqyEVn+9UlNiBnzRfiZgxzwUuRzHLAIR3Wyvsrq4hxRl4KMs7rwFtpPJokIaSXjH@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn0+lUJgt8o3a1hgoW15kS0a5XLQgGJz8bD/5rkZXJQzfM7l2d
	/vWZecmpdBRjflrl2ECfnFiElwhCElE4uVtbuYQ1dO+HvWole0QaW3uj9IT8R5yOw5j8XPhNkCN
	HrW6ZgDp7ThpLSO3RCHQNWbqoRg7lNT3UtSD3CWbedxy1jIxrR3AU3og=
X-Google-Smtp-Source: AGHT+IELt0N6Rfd0bwOsR+AY3ppoTBV7RKwQ3Uic1kzPlRch2AJQGJsyjrM2XzMl745KfBe/1rsXYFGnRoHTVp1+131sJzwZGRHM
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c26d:0:b0:3a3:b256:f31f with SMTP id
 e9e14a558f8ab-3a4ed2fc0a7mr139108765ab.19.1730285529327; Wed, 30 Oct 2024
 03:52:09 -0700 (PDT)
Date: Wed, 30 Oct 2024 03:52:09 -0700
In-Reply-To: <tencent_93E0C66D49BEAEDE6ECA0C9FA7C786D2D206@qq.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67220fd9.050a0220.35b515.0012.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
From: syzbot <syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com>
To: amir73il@gmail.com, eadavis@qq.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com
Tested-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com

Tested on:

commit:         c1e939a2 Merge tag 'cgroup-for-6.12-rc5-fixes' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=123ee2a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=35698c25466f388c
dashboard link: https://syzkaller.appspot.com/bug?extid=ec07f6f5ce62b858579f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=123c8630580000

Note: testing is done by a robot and is best-effort only.
