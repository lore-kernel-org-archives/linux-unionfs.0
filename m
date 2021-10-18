Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD929C433F5
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Oct 2021 08:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B6460F02
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Oct 2021 08:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhJRIuG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Oct 2021 04:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhJRIuG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Oct 2021 04:50:06 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C164C06161C
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Oct 2021 01:47:55 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id e10so4345427uab.3
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Oct 2021 01:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FzX4prSOovWVOBaelUszJBPwKcFTLgREfwaZWCJWb4I=;
        b=KewSraeIMkL7mYs60IGHy1Aib3GiK9O0XPgNImgDy5et3iXnrLBjHy1CpzEja2rwRl
         GdHem3WTNPmpwJxNrE+RhsrCwCkVv5tQUEUIkuIlt3vTVOj+c560Z65T3eZLgTRiPP+Y
         4/Uwj7oF5Pq/UHK9SxXmqvO0KZuGFmPrdAgrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FzX4prSOovWVOBaelUszJBPwKcFTLgREfwaZWCJWb4I=;
        b=x4AcpldR3WvTF47Ahv5spfb+fQjIDuKSeNlLS1a3c/OmSyRx80ccinU1nAhhLMccFM
         iF05pAhXAQqwwxCdXd9S7cSJaa6bBSFzyuCQrk0TpjvCxItKS+RjaSx2+aI3VCd4k9xi
         V+HaPHfECnq2A72Re3j3fczQs9CCfjiEi7q97B/D9W3Sc5LpwOXqaOp7WQ2oALZMgN9W
         IuGv9HWSC06UTxZeHVpA7rH7puK8ft2GHZwacBJVDQAniDj8/UWdjkjEeQbqI9TG8EBW
         y8Vkj40wuAKd6QfQSMoKM5FbRenSJwtMRHf9lqms856xKSvWknReTzDppFYgichsydmA
         ZlaQ==
X-Gm-Message-State: AOAM533kRGiIxD2pFtX6gP71VTepvTJJ8x+qB+/g4tKn/hvwJTr9p162
        Eox/ZT/n+v3sWkF0o9uH+gvidMhqI3JmAywV2mdaRMBOdo/TEw==
X-Google-Smtp-Source: ABdhPJy/nuMqHKAk6PATPiDHlF4TFLIwYuUeHq/5Bwj70A+zSY8wmZ+s+IstCpeywMivS3FOogwakCS6YdVOqOAi4W4=
X-Received: by 2002:ab0:5741:: with SMTP id t1mr24013856uac.72.1634546874308;
 Mon, 18 Oct 2021 01:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210910001820.174272-1-sashal@kernel.org> <20210910001820.174272-40-sashal@kernel.org>
 <YWyLigrybF6yzf6Y@kevinlocke.name>
In-Reply-To: <YWyLigrybF6yzf6Y@kevinlocke.name>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 18 Oct 2021 10:47:43 +0200
Message-ID: <CAJfpegsRo3e-9B64W37YrmvDcjo0QB9t+coAW3mO6TSqdROz2w@mail.gmail.com>
Subject: Re: [Regression] ovl: rename(2) EINVAL if lower doesn't support fileattrs
To:     Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000cffa9705ce9c99d3"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000cffa9705ce9c99d3
Content-Type: text/plain; charset="UTF-8"

On Sun, 17 Oct 2021 at 22:53, Kevin Locke <kevin@kevinlocke.name> wrote:
>
> Hi all,
>
> With 5.15-rc5 or torvalds master (d999ade1cc86), attempting to rename
> a file fails with -EINVAL on an overlayfs mount with a lower
> filesystem that returns -EINVAL for ioctl(FS_IOC_GETFLAGS).  For
> example, with ntfs-3g:
>
>     mkdir lower upper work overlay
>     dd if=/dev/zero of=ntfs.raw bs=1M count=2
>     mkntfs -F ntfs.raw
>     mount ntfs.raw lower
>     touch lower/file.txt
>     mount -t overlay -o "lowerdir=$PWD/lower,upperdir=$PWD/upper,workdir=$PWD/work" - overlay
>     mv overlay/file.txt overlay/file2.txt
>
> mv fails and (misleadingly) prints
>
>     mv: cannot move 'overlay/file.txt' to a subdirectory of itself, 'overlay/file2.txt'
>
> which strace(1) reveals to be due to rename(2) returning -22
> (-EINVAL).  A bit of digging revealed that -EINVAL is coming from
> vfs_fileattr_get() with the following stack:
>
> ovl_real_fileattr_get.cold+0x9/0x12 [overlay]
> ovl_copy_up_inode+0x1b5/0x280 [overlay]
> ovl_copy_up_one+0xaf1/0xee0 [overlay]
> ovl_copy_up_flags+0xab/0xf0 [overlay]
> ovl_rename+0x149/0x850 [overlay]
> ? privileged_wrt_inode_uidgid+0x47/0x60
> ? generic_permission+0x90/0x200
> ? ovl_permission+0x70/0x120 [overlay]
> vfs_rename+0x619/0x9d0
> do_renameat2+0x3c0/0x570
> __x64_sys_renameat2+0x4b/0x60
> do_syscall_64+0x3b/0xc0
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> This issue does not occur on 5.14.  I've bisected the regression to
> 72db82115d2b.

This is clearly a regression.  Not trivial how far the fix should go, though.

One option is to just ignore all errors from ovl_copy_fileattr(),
which would solve this and similar issues.  However that would result
in missing the cases when the attributes were really meant to be
copied up, but failed to do so for some reason.

If vfs_fileattr_get() fails with ENOIOCTLCMD or ENOTTY on lower, that
obviously means we need to return success (lower fs does not support
fileattr).   As ntfs-3g seems to return EINVAL that needs to be added
too.

More interesting question is what to do with get/set failures on
upper.   My feeling is that for now we should try to return errors
(even ENOTTY), but should print a warning in the kernel log.  If that
turns out to regress some use cases, then that needs to fixed as well.

Untested patch attached.

Thanks,
Miklos

--000000000000cffa9705ce9c99d3
Content-Type: text/x-patch; charset="US-ASCII"; name="ovl-fix-fileattr-copy-up-failure.patch"
Content-Disposition: attachment; 
	filename="ovl-fix-fileattr-copy-up-failure.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kuwey4ua0>
X-Attachment-Id: f_kuwey4ua0

ZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9jb3B5X3VwLmMgYi9mcy9vdmVybGF5ZnMvY29weV91
cC5jCmluZGV4IDRlN2Q1YmZhMjk0OS4uZWQwYTBjZTZkZWRhIDEwMDY0NAotLS0gYS9mcy9vdmVy
bGF5ZnMvY29weV91cC5jCisrKyBiL2ZzL292ZXJsYXlmcy9jb3B5X3VwLmMKQEAgLTE0MCwxMiAr
MTQwLDIxIEBAIHN0YXRpYyBpbnQgb3ZsX2NvcHlfZmlsZWF0dHIoc3RydWN0IGlub2RlICppbm9k
ZSwgc3RydWN0IHBhdGggKm9sZCwKIAlpbnQgZXJyOwogCiAJZXJyID0gb3ZsX3JlYWxfZmlsZWF0
dHJfZ2V0KG9sZCwgJm9sZGZhKTsKLQlpZiAoZXJyKQorCWlmIChlcnIpIHsKKwkJLyogTnRmcy0z
ZyByZXR1cm4gLUVJTlZBTCBmb3IgIm5vIGZpbGVhdHRyIHN1cHBvcnQiICovCisJCWlmIChlcnIg
PT0gLUVOT1RUWSB8fCBlcnIgPT0gLUVJTlZBTCkKKwkJCXJldHVybiAwOworCQlwcl93YXJuKCJm
YWlsZWQgdG8gcmV0cmlldmUgZmlsZWF0dHIgKCVwZDIsIGVycj0laSlcbiIsCisJCQlvbGQsIGVy
cik7CiAJCXJldHVybiBlcnI7CisJfQogCiAJZXJyID0gb3ZsX3JlYWxfZmlsZWF0dHJfZ2V0KG5l
dywgJm5ld2ZhKTsKLQlpZiAoZXJyKQorCWlmIChlcnIpIHsKKwkJcHJfd2FybigiZmFpbGVkIHRv
IHJldHJpZXZlIGZpbGVhdHRyICglcGQyLCBlcnI9JWkpXG4iLAorCQkJb2xkLCBlcnIpOwogCQly
ZXR1cm4gZXJyOworCX0KIAogCS8qCiAJICogV2UgY2Fubm90IHNldCBpbW11dGFibGUgYW5kIGFw
cGVuZC1vbmx5IGZsYWdzIG9uIHVwcGVyIGlub2RlLApkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZz
L2lub2RlLmMgYi9mcy9vdmVybGF5ZnMvaW5vZGUuYwppbmRleCA4MzJiMTc1ODk3MzMuLjFmMzYx
NThjN2RiZSAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL2lub2RlLmMKKysrIGIvZnMvb3Zlcmxh
eWZzL2lub2RlLmMKQEAgLTYxMCw3ICs2MTAsMTAgQEAgaW50IG92bF9yZWFsX2ZpbGVhdHRyX2dl
dChzdHJ1Y3QgcGF0aCAqcmVhbHBhdGgsIHN0cnVjdCBmaWxlYXR0ciAqZmEpCiAJaWYgKGVycikK
IAkJcmV0dXJuIGVycjsKIAotCXJldHVybiB2ZnNfZmlsZWF0dHJfZ2V0KHJlYWxwYXRoLT5kZW50
cnksIGZhKTsKKwllcnIgPSB2ZnNfZmlsZWF0dHJfZ2V0KHJlYWxwYXRoLT5kZW50cnksIGZhKTsK
KwlpZiAoZXJyID09IC1FTk9JT0NUTENNRCkKKwkJZXJyID0gLUVOT1RUWTsKKwlyZXR1cm4gZXJy
OwogfQogCiBpbnQgb3ZsX2ZpbGVhdHRyX2dldChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVj
dCBmaWxlYXR0ciAqZmEpCg==
--000000000000cffa9705ce9c99d3--
