Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F10C54FCE
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 14:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82774206F8
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 14:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="jGLi0jqS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgCWO1m (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 10:27:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35131 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgCWO1m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 10:27:42 -0400
Received: by mail-io1-f68.google.com with SMTP id h8so14322633iob.2
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 07:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QhgQiTH66sWx/eNlI7jfsfzmYrUfE8m0OL8LWkYA0o8=;
        b=jGLi0jqSjtfGB4CmBuGTr6X57Q6hFGieJqNpSHj/dYVkOKRZd6ZEHmzW+lG+7oVzr8
         ixWVNZ7nj/b8jLiz7NJ2SRVBOUfp8Pa83jmpTdZTUIxDnmqI78H+BxQO71HYDaczTv7p
         SzVsnogF4zQgT7qeHRQjJ1EvfTu6SJC5HMIwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QhgQiTH66sWx/eNlI7jfsfzmYrUfE8m0OL8LWkYA0o8=;
        b=ThTJqOgfNvXun3gFu6ax7XTsbmmVv8FDWU7fdlciNjxltDSRMOIRuBAdoumGNvSigU
         fIsbKX9jujczBGE/bys7sLUPA1hdM++Bkwx+jfVEoLXSKcQxwXxDZk2KWbJoGO4ka8Zi
         N32Z3oRCkaM+JqZYITCnK3IFKFvUKdxu+YOpy3StGtTYERL+N0wVl8TwZqTsC71+gSCN
         ve/xfo+gL/UJZ44LyFgnCKAklkwBLuJ8xKbymwoJ9KSwvtq2IbdhXvxhhii9PE5QdGTX
         DkXdGqhzzQbHMxmhGbiorHr5sZyVCF0Dt7oXE0p4N6V3z2Z49CZQMDqEfEN52pPW44vn
         vEXw==
X-Gm-Message-State: ANhLgQ0kIx/X8PXJiUiUEI7BU0jPNrW7a5JRATjK+QE2fAmmcl0J+frJ
        63JtIvzMSwdzY4ux7mG1ysMpt9TcwT7D5iW12oNgww==
X-Google-Smtp-Source: ADFU+vunR/JPufI6AZnAKKzqib155zroYqCHYa6f/D3LjJ6XrxLtm1p1eWqTgYR1Uwioz+rt/JvKKSRxTbEpDXO6mqo=
X-Received: by 2002:a5d:85d4:: with SMTP id e20mr20108704ios.140.1584973660391;
 Mon, 23 Mar 2020 07:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
In-Reply-To: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 23 Mar 2020 15:27:29 +0100
Message-ID: <CAJfpeguxq+f2XPKFzCq-e+Br9nOfegDb6NrMg9_LQ6P3qqw5SQ@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     fstests <fstests@vger.kernel.org>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Phasip <phasip@gmail.com>, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

[forwarding test case to fstests@vger]

On Mon, Mar 23, 2020 at 9:50 AM Phasip <phasip@gmail.com> wrote:
>
> Hello!
>
> I have stumbled upon two ways of producing kernel warnings when using the=
 overlayfs, both seem to be results of the same issue.
>
> The issue seems to be related to handling of hard links that are created =
directly in the upperdir.
> Below is my system details and then two samples with a list of commands t=
o reproduce and the corresponding kernel warning
>
> System details
> -------------------
> My kernel version: Linux ubuntu 5.6.0-050600rc5-generic #202003082130 SMP=
 Mon Mar 9 01:33:48 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
>
> # modinfo overlay
> filename:       /lib/modules/5.6.0-050600rc5-generic/kernel/fs/overlayfs/=
overlay.ko
> alias:          fs-overlay
> license:        GPL
> description:    Overlay filesystem
> author:         Miklos Szeredi <miklos@szeredi.hu>
> srcversion:     DF053786AE7737625051D8F
> depends:
> retpoline:      Y
> intree:         Y
> name:           overlay
> vermagic:       5.6.0-050600rc5-generic SMP mod_unload
> parm:           check_copy_up:Obsolete; does nothing
> parm:           redirect_max:Maximum length of absolute redirect xattr va=
lue (ushort)
> parm:           redirect_dir:Default to on or off for the redirect_dir fe=
ature (bool)
> parm:           redirect_always_follow:Follow redirects even if redirect_=
dir feature is turned off (bool)
> parm:           index:Default to on or off for the inodes index feature (=
bool)
> parm:           nfs_export:Default to on or off for the NFS export featur=
e (bool)
> parm:           xino_auto:Auto enable xino feature (bool)
> parm:           metacopy:Default to on or off for the metadata only copy =
up feature (bool)
>
>
> Sample 1
> -------------
> mkdir work lower upper final
> sudo mount -t overlay -o workdir=3Dwork,lowerdir=3Dlower,upperdir=3Dupper=
,metacopy=3Don overlay final
> touch final/h
> ln upper/h upper/k
> rm -rf final/k
> rm -rf final/h
> dmesg
>
> [ 5771.305217] ------------[ cut here ]------------
> [ 5771.305227] WARNING: CPU: 1 PID: 116244 at fs/inode.c:302 drop_nlink+0=
x28/0x40
> [ 5771.305228] Modules linked in: overlay intel_rapl_msr intel_rapl_commo=
n crct10dif_pclmul crc32_pclmul ghash_clmulni_intel vmw_balloon aesni_intel=
 crypto_simd cryptd glue_helper intel_rapl_perf joydev input_leds serio_raw=
 i2c_piix4 mac_hid vsock_loopback vmw_vsock_virtio_transport_common vmw_vso=
ck_vmci_transport vsock vmw_vmci parport_pc ppdev lp parport autofs4 vmw_pv=
scsi vmxnet3 hid_generic vmwgfx psmouse usbhid hid ttm drm_kms_helper ahci =
libahci e1000 mptspi syscopyarea mptscsih sysfillrect sysimgblt mptbase fb_=
sys_fops cec rc_core scsi_transport_spi drm pata_acpi [last unloaded: overl=
ay]
> [ 5771.305255] CPU: 1 PID: 116244 Comm: rm Tainted: G        W         5.=
6.0-050600rc5-generic #202003082130
> [ 5771.305256] Hardware name: VMware, Inc. VMware Virtual Platform/440BX =
Desktop Reference Platform, BIOS 6.00 07/29/2019
> [ 5771.305258] RIP: 0010:drop_nlink+0x28/0x40
> [ 5771.305260] Code: 66 90 0f 1f 44 00 00 55 8b 47 48 48 89 e5 85 c0 74 1=
8 8d 50 ff 89 57 48 85 d2 75 0c 48 8b 47 28 f0 48 ff 80 98 04 00 00 5d c3 <=
0f> 0b c7 47 48 ff ff ff ff 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00
> [ 5771.305261] RSP: 0018:ffffb7c042bdbdd8 EFLAGS: 00010246
> [ 5771.305262] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000020=
0000000
> [ 5771.305263] RDX: ffffa0ec6f512f80 RSI: 0000000100000000 RDI: ffffa0ec7=
26a22a8
> [ 5771.305263] RBP: ffffb7c042bdbdd8 R08: 0000000000000002 R09: 000000000=
0000064
> [ 5771.305264] R10: ffffa0ec7271b300 R11: ffffa0eaf2158668 R12: ffffa0eaf=
400a480
> [ 5771.305264] R13: ffffb7c042bdbe08 R14: 0000000000000000 R15: 000000000=
0000000
> [ 5771.305266] FS:  00007f81856ac700(0000) GS:ffffa0ec75e40000(0000) knlG=
S:0000000000000000
> [ 5771.305266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5771.305267] CR2: 0000000001a2e000 CR3: 000000003466c004 CR4: 000000000=
03606e0
> [ 5771.305273] Call Trace:
> [ 5771.305283]  ovl_do_remove+0x348/0x4c0 [overlay]
> [ 5771.305287]  ovl_unlink+0x13/0x20 [overlay]
> [ 5771.305289]  vfs_unlink+0x114/0x200
> [ 5771.305290]  do_unlinkat+0x19a/0x2d0
> [ 5771.305292]  __x64_sys_unlinkat+0x38/0x60
> [ 5771.305318]  do_syscall_64+0x57/0x1b0
> [ 5771.305322]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 5771.305323] RIP: 0033:0x7f81851cfac7
> [ 5771.305325] Code: 73 01 c3 48 8b 0d d1 b3 2c 00 f7 d8 64 89 01 48 83 c=
8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 07 01 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 b3 2c 00 f7 d8 64 89 01 48
> [ 5771.305325] RSP: 002b:00007ffdfc056c58 EFLAGS: 00000202 ORIG_RAX: 0000=
000000000107
> [ 5771.305327] RAX: ffffffffffffffda RBX: 0000000001a2f230 RCX: 00007f818=
51cfac7
> [ 5771.305327] RDX: 0000000000000000 RSI: 0000000001a2e000 RDI: 00000000f=
fffff9c
> [ 5771.305328] RBP: 0000000000000000 R08: 0000000000000003 R09: 000000000=
0000000
> [ 5771.305328] R10: 000000000000015e R11: 0000000000000202 R12: 000000000=
1a2df70
> [ 5771.305329] R13: 00007ffdfc056d80 R14: 0000000000000000 R15: 000000000=
0000000
> [ 5771.305331] ---[ end trace 67e413528020d510 ]---
>
>
> Sample 2
> -------------
> mkdir work lower upper final
> sudo mount -t overlay -o workdir=3Dwork,lowerdir=3Dlower,upperdir=3Dupper=
,metacopy=3Don overlay final
> touch final/h
> ln upper/h upper/k
> rm -rf final/k
> touch final/z
> mv final/z final/h
> dmesg
>
> [ 6633.944688] ------------[ cut here ]------------
> [ 6633.944700] WARNING: CPU: 0 PID: 47279 at fs/inode.c:302 drop_nlink+0x=
28/0x40
> [ 6633.944701] Modules linked in: overlay intel_rapl_msr intel_rapl_commo=
n crct10dif_pclmul crc32_pclmul ghash_clmulni_intel vmw_balloon aesni_intel=
 crypto_simd cryptd glue_helper intel_rapl_perf joydev input_leds serio_raw=
 i2c_piix4 mac_hid vsock_loopback vmw_vsock_virtio_transport_common vmw_vso=
ck_vmci_transport vsock vmw_vmci parport_pc ppdev lp parport autofs4 vmw_pv=
scsi vmxnet3 hid_generic vmwgfx psmouse usbhid hid ttm drm_kms_helper ahci =
libahci e1000 mptspi syscopyarea mptscsih sysfillrect sysimgblt mptbase fb_=
sys_fops cec rc_core scsi_transport_spi drm pata_acpi [last unloaded: overl=
ay]
> [ 6633.944732] CPU: 0 PID: 47279 Comm: mv Tainted: G        W         5.6=
.0-050600rc5-generic #202003082130
> [ 6633.944733] Hardware name: VMware, Inc. VMware Virtual Platform/440BX =
Desktop Reference Platform, BIOS 6.00 07/29/2019
> [ 6633.944735] RIP: 0010:drop_nlink+0x28/0x40
> [ 6633.944736] Code: 66 90 0f 1f 44 00 00 55 8b 47 48 48 89 e5 85 c0 74 1=
8 8d 50 ff 89 57 48 85 d2 75 0c 48 8b 47 28 f0 48 ff 80 98 04 00 00 5d c3 <=
0f> 0b c7 47 48 ff ff ff ff 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00
> [ 6633.944737] RSP: 0018:ffffb7c045163cc8 EFLAGS: 00010246
> [ 6633.944738] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
0000002
> [ 6633.944739] RDX: 0000000000000000 RSI: 0000000000000800 RDI: ffffa0ec7=
26a0020
> [ 6633.944739] RBP: ffffb7c045163cc8 R08: 0000000000000000 R09: 000000000=
0000000
> [ 6633.944740] R10: ffffa0eaf22cb500 R11: ffffa0eb93e20540 R12: ffffa0eaf=
22cb080
> [ 6633.944740] R13: ffffa0eb93e21440 R14: ffffb7c045163d40 R15: 000000000=
0000000
> [ 6633.944741] FS:  00007f866894e800(0000) GS:ffffa0ec75e00000(0000) knlG=
S:0000000000000000
> [ 6633.944742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6633.944743] CR2: 0000000001ba9808 CR3: 00000000af75c005 CR4: 000000000=
03606f0
> [ 6633.944753] Call Trace:
> [ 6633.944767]  ovl_rename+0x92f/0x940 [overlay]
> [ 6633.944770]  vfs_rename+0x3df/0x9b0
> [ 6633.944775]  ? _cond_resched+0x19/0x30
> [ 6633.944779]  ? security_path_rename+0x88/0xb0
> [ 6633.944780]  do_renameat2+0x507/0x570
> [ 6633.944782]  __x64_sys_rename+0x23/0x30
> [ 6633.944786]  do_syscall_64+0x57/0x1b0
> [ 6633.944787]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 6633.944789] RIP: 0033:0x7f8667db9367
> [ 6633.944790] Code: 75 12 48 89 df e8 a9 d7 08 00 85 c0 0f 95 c0 0f b6 c=
0 f7 d8 5b c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 52 00 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 01 8b 35 00 f7 d8 64 89 01 48
> [ 6633.944790] RSP: 002b:00007ffc331da4a8 EFLAGS: 00000202 ORIG_RAX: 0000=
000000000052
> [ 6633.944792] RAX: ffffffffffffffda RBX: 0000000000008000 RCX: 00007f866=
7db9367
> [ 6633.944792] RDX: 0000000000000000 RSI: 00007ffc331dc517 RDI: 00007ffc3=
31dc50f
> [ 6633.944793] RBP: 00007ffc331da870 R08: 0000000000000000 R09: 000000000=
0000000
> [ 6633.944793] R10: 0000000000000640 R11: 0000000000000202 R12: 00007ffc3=
31da601
> [ 6633.944794] R13: 00007ffc331da960 R14: 00007ffc331dc50f R15: 000000000=
0000000
> [ 6633.944795] ---[ end trace 67e413528020d64a ]---
>
>
> Best Wishes
> Pasi Saarinen
>
