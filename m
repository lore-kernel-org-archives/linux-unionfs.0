Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A761F4179;
	Thu,  6 Feb 2025 15:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738857199; cv=none; b=D2mIfoAgLORL/WkTtYBhf/QL5jtfYIfKsQ/DCyIlYV015zgatI0E/b1ojhuytORZNYo4n/nyx4brqCZtzA5to5hZUZW9fIPvP7fiIWfTKlS0VjO/U87dVZIKCzy2rX+GhlyAUXpQCuFsoYFjUxnSIHM4iS4wRR5a6WxTTWVkHhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738857199; c=relaxed/simple;
	bh=EEO+RXlJJn5oRvwqBCSKDUQQl6JRaHG1JbhOEhBfMOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HN7fASnic8buDjtBDgFifRZJAp4mBLJBHHFFe6Ku/K+ctN/qbwETqYq+ohTzuSxNxBDDAypNTdumbkrXWsLFmiUGJvw/h4TF7afrGDSg1/XRKVmcms6lnoXO73tlQALIQblNGak7rPcjcruRp8THJA3CMp7cUqx0AE3Vn1zRc1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXqSMZrk; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXqSMZrk"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5dca4521b95so2364090a12.0;
        Thu, 06 Feb 2025 07:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738857196; x=1739461996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yVxGlWr5Hrz+6+AtcVGpT5mxcbq4sHMPEsoNU+9wudU=;
        b=CXqSMZrkM96tejllFKRD0Q6p41/a7a9gM8+jR1HAGsNpqMbSRfXtHlwx6fF/JxsMfA
         ioKH+zFB0aWExDr1FDtB79KFvlleTBPTa6PWiYom0jZ+hWXbBYSOmiSmhiMkqj03RHKj
         J14oFzhV/8phDStnk6FeAoTvMceU44t+8QKf0nHcMGZTwwynHUtW7TleMw8UC0nOXOa+
         tNbkZj+bMhP/Mwmt+EmVDuLZUIvwLvyVTw97UPdoU9SuBLwrS5ihM+EzswEJbG5atfu0
         e2gPycZNo6OLL6O7SG7rtJsKRb1/OkJ4wU/VQISjE5/aSTzvNIm+i/obyVZOH5I1soTz
         vgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738857196; x=1739461996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yVxGlWr5Hrz+6+AtcVGpT5mxcbq4sHMPEsoNU+9wudU=;
        b=bdun3wnJN5vHgS3Yc2uLDWDCc/6AXeubNrgT6u8iEF3baWg0aN+QgvQKkaGxkFfAh/
         J5HLpZ2cFeBnKzc333Wo+KRsLAk3WM8pDGpdi3jFvUAi0B6EH34YE/fiiKNNfIIBDzS2
         PxXRMHplJt8hhIjXrHrNsKltKjeranUDXgMAP79HU29FxnKUwY+T+svWEN9C+zPGAZGj
         2iRAtDNtI2Rvto0pptbb7If0iESLlpR5RU8ZbtvBmkbD4Pq2gCMUqK3zZk+Han7UoxX9
         YaR2yvOIValfXWKcy4D/Qt+zSG8bfLnkbY30qDLcMMBHX+nI7I5DOdpMQ74rnUYKAwrH
         6LXg==
X-Forwarded-Encrypted: i=1; AJvYcCVSVIWWTHF4ep9jUQUb2SgYAD15tzP+XqJMFnAmyTL4BRQOhcV4hGG1Swn0P9TyTVpafVx9Eyxg9TCFsFa9@vger.kernel.org
X-Gm-Message-State: AOJu0YzEDovhO90DfVeL9hgbo726mrR6htZlFmW01RwC0hN+3B8RNxJ7
	TWjAnG4DU/E6lQpli7qvFEi4kf/YKMAcmBUe+Tk2V8hrU74WtfTgY2t3GvM2mevY8uZbsisjsl+
	jINBMoMNJyP/kvsW3IqfD4U6Qx3I=
X-Gm-Gg: ASbGncuRHW5fU0cZ0Xzkg9bUVBL7CTVscaRucsaVfxUSzJxCNrp1jp38X0UhpWkv3sw
	YnEqKp6r0rl//nm0VMGSDUNkuTkCvtpdkrt4w+LKEU3Mx9ARwog64DD9zWNKEjbLIDn6gBFK2
X-Google-Smtp-Source: AGHT+IFycZ6gL4Awm5pVs5wqBHNfxA7H1dYPt4NLr1ogsVbl7kFMnrScv8wLouJRYwn1Uw12bM1M88UoUwulKi3giLI=
X-Received: by 2002:a05:6402:13c8:b0:5dc:7fbe:730a with SMTP id
 4fb4d7f45d1cf-5dcdb58fb0cmr7916596a12.0.1738857195654; Thu, 06 Feb 2025
 07:53:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com>
In-Reply-To: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 6 Feb 2025 16:53:04 +0100
X-Gm-Features: AWEUYZmgKzK1xJw4IXZd-sMvWkmdTWbA_Fhz8CZILqQtGkmFvVUh5v-lgCqY0aE
Message-ID: <CAOQ4uxhS47k3q+QBSnFfWHUCarSR+MW8ms15jDpuCyWdX1RC4g@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in clone_private_mount
To: syzbot <syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com>, 
	Christian Brauner <brauner@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 2:32=E2=80=AFPM syzbot
<syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    808eb958781e Add linux-next specific files for 20250206
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D126e33df98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D88b25e5d30d57=
6e4
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D62dfea789a2ceda=
c1298
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D16346df8580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D117e80e458000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/493ef93f2e5f/dis=
k-808eb958.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b41757cd41c9/vmlinu=
x-808eb958.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/24f456104aad/b=
zImage-808eb958.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000009: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
> CPU: 0 UID: 0 PID: 5834 Comm: syz-executor772 Not tainted 6.14.0-rc1-next=
-20250206-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 12/27/2024
> RIP: 0010:is_anon_ns fs/mount.h:159 [inline]
> RIP: 0010:clone_private_mount+0x184/0x3e0 fs/namespace.c:2425

Christian,

This obviously points to line:

      /* Make sure this isn't something purely kernel internal. */
     if (!is_anon_ns(old_mnt->mnt_ns))

in commit:
ae63304102ecd fs: allow detached mounts in clone_private_mount()

Where old_mnt->mnt_ns can be NULL.

Thanks,
Amir.
