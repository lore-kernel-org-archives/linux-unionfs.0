Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEBBC433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Nov 2022 12:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKXMmf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 07:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKXMmX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2022 07:42:23 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228A38C793
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 04:42:20 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id m19so1157278edj.8
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 04:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Vgu95H9HDbUKu9y2OrYjx1GYm5CGbkRbPZ1vVSyFcT8=;
        b=Jxirt0RsX3+VFCSphVlYncFIGRC8SmMC11z6LOkQwEn71JlECZT0iBOTKny2VGzREf
         oagi1ff0kZid3H4P9pOywwk2Gy8Njg59zeEGlC13Gq40dsCwulq7oGoB9yObE1D6KIRA
         S9/pTn54GROXIzEMKRdBUMFebKf+xXvj4wLLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vgu95H9HDbUKu9y2OrYjx1GYm5CGbkRbPZ1vVSyFcT8=;
        b=CvBAy2RM4XR19iO6/5ZGacNsRd5UJtpG72vWtiJrxK5Py/UNSym5CpYqi1JuH2691G
         L6e9HDgvMelK3TCn2YMpAY63WrAPv3L3BO9mHcWCiAdJKst4pC1flqQ7mATjwSTSt/QJ
         wvknsPBZ+IuIWOx4RtN/VHI5DjJg8QViSH2QcsWXfQAb/oeZiO/8yVastzjPrDgJzl2P
         UZcRIqF0LkhbHez2wopopO38aHGM+Ps8pnE3W8Kmlkmh23dW3BQW88rhCR5U3PFDupgM
         Kebofu2rNphbb6TlOojFIw9lvtDb0+C24A/rQLh4VxGhwrzD8B7DC105eJOMCzIrGpcn
         jLOw==
X-Gm-Message-State: ANoB5plxyO4bzt6HutmIyBBnYbhtfP1YPM3kVIXJWf4p8lz1KBnCYwKt
        xh7JkodCZ+r52bqmddrrX4sXSSzolODdNxeKCz2m6w==
X-Google-Smtp-Source: AA0mqf5vuNcpYi/ZuPTnP52aRVEzkDyomCELlBJ2zYjs0Ri9rTlzAonk0Oe4afvYfv0l8CcXy/q5kOi56DzNuVVbFP0=
X-Received: by 2002:a50:bb08:0:b0:469:1684:217d with SMTP id
 y8-20020a50bb08000000b004691684217dmr19643063ede.270.1669293738607; Thu, 24
 Nov 2022 04:42:18 -0800 (PST)
MIME-Version: 1.0
References: <000000000000381c1405ee3029c0@google.com>
In-Reply-To: <000000000000381c1405ee3029c0@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 24 Nov 2022 13:42:07 +0100
Message-ID: <CAJfpeguD4Ai8_PiRnDO8dRFauHPdwLimWrB6xsxsyn8yFLgL6w@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in ovl_dentry_upper
To:     syzbot <syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="000000000000511e4a05ee36bc33"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000511e4a05ee36bc33
Content-Type: text/plain; charset="UTF-8"

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master

On Thu, 24 Nov 2022 at 05:51, syzbot
<syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    fe24a97cf254 Merge tag 'input-for-v6.1-rc5' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15a02765880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6f9416d398342c83
> dashboard link: https://syzkaller.appspot.com/bug?extid=a4055c78774bbf3498bb
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a320fd880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e6b6ed880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d4424ef25058/disk-fe24a97c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/61c4ed6a96dd/vmlinux-fe24a97c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d1b8ff061e4e/bzImage-fe24a97c.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc0000000092: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000490-0x0000000000000497]
> CPU: 0 PID: 16299 Comm: syz-executor309 Not tainted 6.1.0-rc5-syzkaller-00307-gfe24a97cf254 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:ovl_upperdentry_dereference fs/overlayfs/ovl_entry.h:150 [inline]
> RIP: 0010:ovl_dentry_upper+0x40/0x60 fs/overlayfs/util.c:213
> Code: fe 49 83 c6 68 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 7f 28 e9 fe bb 90 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 61 28 e9 fe 48 8b 03 5b 41 5e 41
> RSP: 0018:ffffc9000ef3fa50 EFLAGS: 00010202
> RAX: 0000000000000092 RBX: 0000000000000490 RCX: ffff888020328000
> RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff888075528758
> RBP: dffffc0000000000 R08: ffffffff81f2119e R09: ffffed100eaa50fa
> R10: ffffed100eaa50fa R11: 1ffff1100eaa50f9 R12: 0000000000000040
> R13: ffffc9000ef3fc20 R14: ffff8880755287c0 R15: dffffc0000000000
> FS:  00007f7e44d61700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7e44df1800 CR3: 000000007c404000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  ovl_dentry_revalidate_common fs/overlayfs/super.c:146 [inline]
>  ovl_dentry_revalidate+0x4b/0x380 fs/overlayfs/super.c:159
>  d_revalidate fs/namei.c:856 [inline]
>  lookup_fast+0x26c/0x480 fs/namei.c:1634
>  walk_component+0x55/0x410 fs/namei.c:1989
>  lookup_last fs/namei.c:2450 [inline]
>  path_lookupat+0x17d/0x450 fs/namei.c:2474
>  filename_lookup+0x274/0x650 fs/namei.c:2503
>  user_path_at_empty+0x40/0x1a0 fs/namei.c:2876
>  user_path_at include/linux/namei.h:57 [inline]
>  __do_sys_name_to_handle_at fs/fhandle.c:107 [inline]
>  __se_sys_name_to_handle_at+0xf8/0x610 fs/fhandle.c:93
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f7e44db0159
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7e44d612f8 EFLAGS: 00000246 ORIG_RAX: 000000000000012f
> RAX: ffffffffffffffda RBX: 0000000000000034 RCX: 00007f7e44db0159
> RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
> RBP: 00007f7e44e394a8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7e44e394a0
> R13: 00007f7e44e394ac R14: 00007f7e44e06074 R15: 0030656c69662f2e
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ovl_upperdentry_dereference fs/overlayfs/ovl_entry.h:150 [inline]
> RIP: 0010:ovl_dentry_upper+0x40/0x60 fs/overlayfs/util.c:213
> Code: fe 49 83 c6 68 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 7f 28 e9 fe bb 90 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 61 28 e9 fe 48 8b 03 5b 41 5e 41
> RSP: 0018:ffffc9000ef3fa50 EFLAGS: 00010202
> RAX: 0000000000000092 RBX: 0000000000000490 RCX: ffff888020328000
> RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff888075528758
> RBP: dffffc0000000000 R08: ffffffff81f2119e R09: ffffed100eaa50fa
> R10: ffffed100eaa50fa R11: 1ffff1100eaa50f9 R12: 0000000000000040
> R13: ffffc9000ef3fc20 R14: ffff8880755287c0 R15: dffffc0000000000
> FS:  00007f7e44d61700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000564e6292d008 CR3: 000000007c404000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   49 83 c6 68             add    $0x68,%r14
>    4:   4c 89 f0                mov    %r14,%rax
>    7:   48 c1 e8 03             shr    $0x3,%rax
>    b:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1)
>   10:   74 08                   je     0x1a
>   12:   4c 89 f7                mov    %r14,%rdi
>   15:   e8 7f 28 e9 fe          callq  0xfee92899
>   1a:   bb 90 04 00 00          mov    $0x490,%ebx
>   1f:   49 03 1e                add    (%r14),%rbx
>   22:   48 89 d8                mov    %rbx,%rax
>   25:   48 c1 e8 03             shr    $0x3,%rax
> * 29:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
>   2e:   74 08                   je     0x38
>   30:   48 89 df                mov    %rbx,%rdi
>   33:   e8 61 28 e9 fe          callq  0xfee92899
>   38:   48 8b 03                mov    (%rbx),%rax
>   3b:   5b                      pop    %rbx
>   3c:   41 5e                   pop    %r14
>   3e:   41                      rex.B
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

--000000000000511e4a05ee36bc33
Content-Type: text/x-patch; charset="US-ASCII"; name="ovl-fix-rcu-revalidate.patch"
Content-Disposition: attachment; filename="ovl-fix-rcu-revalidate.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lav2dseu0>
X-Attachment-Id: f_lav2dseu0

RnJvbTogQ2hlbiBaaG9uZ2ppbiA8Y2hlbnpob25namluQGh1YXdlaS5jb20+ClN1YmplY3Q6IG92
bDogZml4IHVzZSBpbm9kZSBkaXJlY3RseSBpbiByY3Utd2FsayBtb2RlCgpvdmxfZGVudHJ5X3Jl
dmFsaWRhdGVfY29tbW9uKCkgY2FuIGJlIGNhbGxlZCBpbiByY3Utd2FsayBtb2RlLiAgQXMgZG9j
dW1lbnQKc2FpZCwgImluIHJjdS13YWxrIG1vZGUsIGRfcGFyZW50IGFuZCBkX2lub2RlIHNob3Vs
ZCBub3QgYmUgdXNlZCB3aXRob3V0CmNhcmUiLgoKQ2hlY2sgaW5vZGUgaGVyZSB0byBwcm90ZWN0
IGFjY2VzcyB1bmRlciByY3Utd2FsayBtb2RlLgoKRml4ZXM6IGJjY2VjZTFlYWQzNiAoIm92bDog
YWxsb3cgcmVtb3RlIHVwcGVyIikKUmVwb3J0ZWQtYnk6IHN5emJvdCthNDA1NWM3ODc3NGJiZjM0
OThiYkBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tClNpZ25lZC1vZmYtYnk6IENoZW4gWmhvbmdq
aW4gPGNoZW56aG9uZ2ppbkBodWF3ZWkuY29tPgpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+
ICMgdjUuNwpTaWduZWQtb2ZmLWJ5OiBNaWtsb3MgU3plcmVkaSA8bXN6ZXJlZGlAcmVkaGF0LmNv
bT4KLS0tCiBmcy9vdmVybGF5ZnMvc3VwZXIuYyB8ICAgIDcgKysrKysrLQogMSBmaWxlIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKLS0tIGEvZnMvb3ZlcmxheWZzL3N1
cGVyLmMKKysrIGIvZnMvb3ZlcmxheWZzL3N1cGVyLmMKQEAgLTEzOSwxMSArMTM5LDE2IEBAIHN0
YXRpYyBpbnQgb3ZsX2RlbnRyeV9yZXZhbGlkYXRlX2NvbW1vbigKIAkJCQkJdW5zaWduZWQgaW50
IGZsYWdzLCBib29sIHdlYWspCiB7CiAJc3RydWN0IG92bF9lbnRyeSAqb2UgPSBkZW50cnktPmRf
ZnNkYXRhOworCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBkX2lub2RlX3JjdShkZW50cnkpOwogCXN0
cnVjdCBkZW50cnkgKnVwcGVyOwogCXVuc2lnbmVkIGludCBpOwogCWludCByZXQgPSAxOwogCi0J
dXBwZXIgPSBvdmxfZGVudHJ5X3VwcGVyKGRlbnRyeSk7CisJLyogQ2FyZWZ1bCBpbiBSQ1UgbW9k
ZSAqLworCWlmICghaW5vZGUpCisJCXJldHVybiAtRUNISUxEOworCisJdXBwZXIgPSBvdmxfaV9k
ZW50cnlfdXBwZXIoaW5vZGUpOwogCWlmICh1cHBlcikKIAkJcmV0ID0gb3ZsX3JldmFsaWRhdGVf
cmVhbCh1cHBlciwgZmxhZ3MsIHdlYWspOwogCg==
--000000000000511e4a05ee36bc33--
