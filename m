Return-Path: <SRS0=Xlr+=AB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AE4C433E0
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 Jun 2020 16:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E44823E53
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 Jun 2020 16:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G3Fr4as6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgFTQOP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 12:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgFTQOP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jun 2020 12:14:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571B8C06174E
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 09:14:15 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id x189so14835989iof.9
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 09:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AvWKwdSnIH9XF6wMSTwU57iZK9F8ReesRs7aDIANndQ=;
        b=G3Fr4as6gz1kHJF0umTvhzuOnbqy3pUFT5VIQ93K2DYM1ILr43zMulxiFl6fgRxvk4
         Ssc7ifHC3Ad4IvbZHXu3nveXVKiDo6ZHa0gF3Xz2zGUxsEatG5NLXVjElzO4w9hoHuYT
         YhCBF0eW7ExUsI+EbhOBSOez/zpzrtQcPkUecdsroBzY+QONCb7fyXfM3+66aH2P8Dvl
         qJ2eNRiCB//QfreIgkEH/D1zK1iCDlQbpF8lAWNk3IhkQzKd4zCivu87Plw3ky9MqdRu
         7QVdqjTCkG1843wqPwY8XZjFqbNL3Xi3tp7p63+9G6yhhj5S9tM1B6OEZTU28/AIoVQi
         mmUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvWKwdSnIH9XF6wMSTwU57iZK9F8ReesRs7aDIANndQ=;
        b=l1WcXMzIS4RxuPQnvOrs+uvM0rdyZKKkQeEeInOBS/BOY9L2a1N8YRyrd71Kidkyor
         6Cq5DF80+OeoY2dff1gk6QA/suqB7Nl07TS1dVOFfiwju7co6gCvmra9sEV870XLzLIG
         asvpo7jRYEx1kTzu+jqwUe6sB5WCEqWOSMNbxsT5FgGzG5T0SxNgvAfPkU62V/wzyIbb
         PViMpLV2XqO9ZyRjiGFtrveSNIEbKcFg1POUfFgRIkVJK6OfxYWJeENYcWUjND0C11zc
         NfZXekdUuaJlrcbIC5/BYrVYY350bkn6VSjAsTID8jw9JQokwyB66Xag3GRE9BUt+7uy
         qxsQ==
X-Gm-Message-State: AOAM5326zqdjrrCNhxxF2bDszS540xdxlJdH7XFfCNcWcA8b22K3EmBi
        ffviGeTfgtuT2QzEOcLG20jI/o778tMiFhtJPdI=
X-Google-Smtp-Source: ABdhPJykF+DZQy52hHE8xSMRdkfn0NK8hUIqTK6JKFPeYU0hryMTaOaiyESpctg03OEcUZa/+0erCuqpzpzqOdHg9to=
X-Received: by 2002:a02:83c3:: with SMTP id j3mr6596614jah.81.1592669654579;
 Sat, 20 Jun 2020 09:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200620132845.w34h6y2p5txrsd73@xzhoux.usersys.redhat.com>
In-Reply-To: <20200620132845.w34h6y2p5txrsd73@xzhoux.usersys.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 20 Jun 2020 19:14:02 +0300
Message-ID: <CAOQ4uxiZ=JmSzDQ-05EJyPr4iRtDsXYyNSpqh8iaiDxcO-paZw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: fix NULL ref while cleanup index when mount with nfs_export
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <mszeredi@redhat.com>
Content-Type: multipart/mixed; boundary="00000000000001993705a8864d6e"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--00000000000001993705a8864d6e
Content-Type: text/plain; charset="UTF-8"

On Sat, Jun 20, 2020 at 4:28 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Mounting with nfs_export=on, xfstests overlay/031 triggers panic
> since v5.8-rc1 overlayfs updates.
>
> [ 7492.110430] run fstests overlay/031 at 2020-06-10 00:25:16
> [ 7492.487300] overlayfs: disabling metacopy due to nfs_export=on
> [ 7492.514270] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
> [ 7492.648049] overlayfs: disabling metacopy due to nfs_export=on
> [ 7492.675189] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
> [ 7492.781437] overlayfs: disabling metacopy due to nfs_export=on
> [ 7492.808608] overlayfs: "xino=on" is useless with all layers on same fs, ignore.
> [ 7492.842132] overlayfs: orphan index entry (index/00fb1d000175e1f1e51e134b75b98d1f572f21252d030004002ae1559a, ftype=4000, nlink=2)
> [ 7492.895298] BUG: kernel NULL pointer dereference, address: 0000000000000030
> [ 7492.926984] #PF: supervisor read access in kernel mode
> [ 7492.950703] #PF: error_code(0x0000) - not-present page
> [ 7492.974243] PGD 0 P4D 0
> [ 7492.985754] Oops: 0000 [#1] SMP PTI
> [ 7493.001771] CPU: 11 PID: 951781 Comm: mount Not tainted 5.7.0+ #1
> [ 7493.029799] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013
> [ 7493.059809] RIP: 0010:ovl_cleanup_and_whiteout+0x28/0x220 [overlay]
> [ 7493.087978] Code: 00 00 0f 1f 44 00 00 41 57 41 56 49 89 f6 41 55 41 54 49 89 d4 55 48 89 fd 53 48 83 ec 08 4c 8b 47 20 48 83 bf a8 00 00 00 00 <4d> 8b 68 30 0f 84 41 01 00 00 80 7d 7c 00 0f 85 b7 00 00 00 48 8b
> [ 7493.173542] RSP: 0018:ffffbb8409a7fc20 EFLAGS: 00010246
> [ 7493.197332] RAX: 00000000fffffffe RBX: ffff9425aa44ee40 RCX: 0000000000000000
> [ 7493.230058] RDX: ffff9420f64c5a40 RSI: ffff9425a25d91c8 RDI: ffff94259dfc9680
> [ 7493.262699] RBP: ffff94259dfc9680 R08: 0000000000000000 R09: 000000000000000b
> [ 7493.295568] R10: 0000000000000000 R11: ffffbb8409a7fab8 R12: ffff9420f64c5a40
> [ 7493.328117] R13: ffff94259dfc9680 R14: ffff9425a25d91c8 R15: ffff9420f64c5a40
> [ 7493.360681] FS:  00007f43bdfc2080(0000) GS:ffff9425af740000(0000) knlGS:0000000000000000
> [ 7493.397797] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7493.424340] CR2: 0000000000000030 CR3: 000000082bd18001 CR4: 00000000001606e0
> [ 7493.456765] Call Trace:
> [ 7493.467695]  ovl_indexdir_cleanup+0x1ab/0x330 [overlay]
> [ 7493.491605]  ? ovl_cache_entry_find_link.constprop.18+0x80/0x80 [overlay]
> [ 7493.522754]  ovl_fill_super+0x1031/0x11d0 [overlay]
> [ 7493.545183]  ? sget+0x1c7/0x220
> [ 7493.559242]  ? get_anon_bdev+0x40/0x40
> [ 7493.576593]  ? ovl_show_options+0x230/0x230 [overlay]
> [ 7493.599407]  mount_nodev+0x48/0xa0
> [ 7493.615187]  legacy_get_tree+0x27/0x40
> [ 7493.632193]  vfs_get_tree+0x25/0xb0
> [ 7493.647926]  do_mount+0x7ae/0x9d0
> [ 7493.662996]  ? _copy_from_user+0x2c/0x60
> [ 7493.681534]  __x64_sys_mount+0xc4/0xe0
> [ 7493.698370]  do_syscall_64+0x55/0x1b0
> [ 7493.715177]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 7493.737697] RIP: 0033:0x7f43bcffec8e
> [ 7493.753986] Code: Bad RIP value.
> [ 7493.768721] RSP: 002b:00007ffe1b7c74f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> [ 7493.803468] RAX: ffffffffffffffda RBX: 000055ba081c1310 RCX: 00007f43bcffec8e
> [ 7493.837362] RDX: 000055ba081c1a00 RSI: 000055ba081c1a40 RDI: 000055ba081c1a20
> [ 7493.872745] RBP: 00007f43bdda9184 R08: 000055ba081c1880 R09: 0000000000000003
> [ 7493.905227] R10: 00000000c0ed0000 R11: 0000000000000246 R12: 0000000000000000
> [ 7493.938152] R13: 00000000c0ed0000 R14: 000055ba081c1a20 R15: 000055ba081c1a00
>
> Bisect says the first bad commit is:
>     [c21c839b8448dd4b1e37ffc1bde928f57d34c0db] ovl: whiteout inode sharing
>
> Minimal reproducer:
> --------------------------------------------------
> rm -rf l u w m
> mkdir -p l u w m
> mkdir -p l/testdir
> touch l/testdir/testfile
> mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> echo 1 > m/testdir/testfile
> umount m
> rm -rf u/testdir
> mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
> umount m
> --------------------------------------------------
>
> When mount with nfs_export=on, and fail to verify an orphan index, we're
> cleaning this index from indexdir by calling ovl_cleanup_and_whiteout,
> in which we should clean indexdir rather than workdir. We start to use
> ofs structure and only clean workdir since commit c21c839b8448
> ("ovl: whiteout inode sharing"), breaking the nfs_export code path.
>
> Fixing this by passing additional explicit workdir argument to the cleanup
> helper and passing indexdir as workdir argument in ovl_indexdir_cleanup and
> ovl_cleanup_index.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
> v2:
>     Pass workdir as argument along with ofs to the helper instead of
> checking availability of the dirs.
>     Pass indexdir in ovl_indexdir_cleanup and ovl_cleanup_index.

Sorry for not looking closer before, I wasn't near my workstation.
Here is another suggestion.
I think Miklos will like this one better, because he was the one who removed
the workdir from Chengguang's original patch.

The design was that ovl->workdir will point at ovl->indexdir, but we did
it too late for ovl_indexdir_cleanup().
No reason not to do it sooner, because once we get success from
ofs->indexdir = ovl_workdir_create(... there is no turning back.

Feel free to re-post this with proper commit message after testing and
verifying that moving the code didn't break any other error path.

Thanks,
Amir.

--00000000000001993705a8864d6e
Content-Type: text/plain; charset="US-ASCII"; 
	name="0001-ovl-fix-NULL-ref-while-cleanup-index-when-mount-with.patch.txt"
Content-Disposition: attachment; 
	filename="0001-ovl-fix-NULL-ref-while-cleanup-index-when-mount-with.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kbnu76u50>
X-Attachment-Id: f_kbnu76u50

RnJvbSA0ZTA0NDU3YTFiNjE2Y2M4NDMzMTIxNDAxNzAxNGJlYmQ0Nzk0NjFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDIwIEp1biAyMDIwIDE5OjA0OjM1ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gb3Zs
OiBmaXggTlVMTCByZWYgd2hpbGUgY2xlYW51cCBpbmRleCB3aGVuIG1vdW50IHdpdGgKIG5mc19l
eHBvcnQKCi4uLgoKRml4ZXM6IGNvbW1pdCBjMjFjODM5Yjg0NDggKCJvdmw6IHdoaXRlb3V0IGlu
b2RlIHNoYXJpbmciKQpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21h
aWwuY29tPgotLS0KIGZzL292ZXJsYXlmcy9zdXBlci5jIHwgMTYgKysrKysrKy0tLS0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9mcy9vdmVybGF5ZnMvc3VwZXIuYyBiL2ZzL292ZXJsYXlmcy9zdXBlci5jCmluZGV4IDkx
NDc2YmM0MjJmOS4uMTU5MzlhYjM5YzFjIDEwMDY0NAotLS0gYS9mcy9vdmVybGF5ZnMvc3VwZXIu
YworKysgYi9mcy9vdmVybGF5ZnMvc3VwZXIuYwpAQCAtMTM1NCw2ICsxMzU0LDEyIEBAIHN0YXRp
YyBpbnQgb3ZsX2dldF9pbmRleGRpcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzdHJ1Y3Qgb3Zs
X2ZzICpvZnMsCiAKIAlvZnMtPmluZGV4ZGlyID0gb3ZsX3dvcmtkaXJfY3JlYXRlKG9mcywgT1ZM
X0lOREVYRElSX05BTUUsIHRydWUpOwogCWlmIChvZnMtPmluZGV4ZGlyKSB7CisJCS8qIGluZGV4
IGRpciB3aWxsIGFjdCBhbHNvIGFzIHdvcmtkaXIgKi8KKwkJaXB1dChvZnMtPndvcmtkaXJfdHJh
cCk7CisJCW9mcy0+d29ya2Rpcl90cmFwID0gTlVMTDsKKwkJZHB1dChvZnMtPndvcmtkaXIpOwor
CQlvZnMtPndvcmtkaXIgPSBkZ2V0KG9mcy0+aW5kZXhkaXIpOworCiAJCWVyciA9IG92bF9zZXR1
cF90cmFwKHNiLCBvZnMtPmluZGV4ZGlyLCAmb2ZzLT5pbmRleGRpcl90cmFwLAogCQkJCSAgICAg
ImluZGV4ZGlyIik7CiAJCWlmIChlcnIpCkBAIC0xODQzLDIwICsxODQ5LDEyIEBAIHN0YXRpYyBp
bnQgb3ZsX2ZpbGxfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgdm9pZCAqZGF0YSwgaW50
IHNpbGVudCkKIAkJc2ItPnNfZmxhZ3MgfD0gU0JfUkRPTkxZOwogCiAJaWYgKCEob3ZsX2ZvcmNl
X3JlYWRvbmx5KG9mcykpICYmIG9mcy0+Y29uZmlnLmluZGV4KSB7Ci0JCS8qIGluZGV4IGRpciB3
aWxsIGFjdCBhbHNvIGFzIHdvcmtkaXIgKi8KLQkJZHB1dChvZnMtPndvcmtkaXIpOwotCQlvZnMt
PndvcmtkaXIgPSBOVUxMOwotCQlpcHV0KG9mcy0+d29ya2Rpcl90cmFwKTsKLQkJb2ZzLT53b3Jr
ZGlyX3RyYXAgPSBOVUxMOwotCiAJCWVyciA9IG92bF9nZXRfaW5kZXhkaXIoc2IsIG9mcywgb2Us
ICZ1cHBlcnBhdGgpOwogCQlpZiAoZXJyKQogCQkJZ290byBvdXRfZnJlZV9vZTsKIAogCQkvKiBG
b3JjZSByL28gbW91bnQgd2l0aCBubyBpbmRleCBkaXIgKi8KLQkJaWYgKG9mcy0+aW5kZXhkaXIp
Ci0JCQlvZnMtPndvcmtkaXIgPSBkZ2V0KG9mcy0+aW5kZXhkaXIpOwotCQllbHNlCisJCWlmICgh
b2ZzLT5pbmRleGRpcikKIAkJCXNiLT5zX2ZsYWdzIHw9IFNCX1JET05MWTsKIAl9CiAKLS0gCjIu
MTcuMQoK
--00000000000001993705a8864d6e--
