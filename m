Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443B9C48BCF
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Jun 2021 06:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15B11611CC
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Jun 2021 06:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhFMGhY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 02:37:24 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:45827 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhFMGhX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 13 Jun 2021 02:37:23 -0400
Received: by mail-io1-f41.google.com with SMTP id k5so26372989iow.12;
        Sat, 12 Jun 2021 23:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQgZ+Rwdgt64BISq5qwkJUIWJGJK6sR3HjdFAk05y+U=;
        b=ju/D7CKSuEMCF+VLZWlWa0PYeUwIg8NTOp6K1f3bfHjnWRWkA/x5o9IXG8P1T8Hzrs
         WTJdGjje9Xr1FDec1R8Vl3FMBQ5JABfNKPVLHiZLmJMAg8l/RlzRUcS8RmViugG2zbyp
         uQKnar2zVfDTe/vvmultQsTpIUcsJjWJ9vdubfue/F/ibvwtiipWuskpy90+oLMWZjA9
         qt4PBshSvSQS7q4uPqop1DLpv2u5surezuagAVU7WBg3A/V3+wrILGbg8IU8losW/MWF
         e/yekTcSvljKO79UmjglKcTZ/VtPgad04COl56yFBkYe6EZP2k4NI95Nc6lWRQGIbmFk
         qYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQgZ+Rwdgt64BISq5qwkJUIWJGJK6sR3HjdFAk05y+U=;
        b=BsVS+h7S9zu9DnFkIHQUCz56aHBYEkcmimaVT+Z650jxAR0DoNnibPldcAafBbb3Q4
         XMZffPRTqgyjD7jfp3CrlkX1ZEeWWKwr1jolAHSkMIx1RIp6ia487zX16sNQuT931GKO
         FOBv1jNXAXl4xGL9tH8c6yuP7HL0o7i+8+S8DBxF5SQHP6c9LMFn+8/TdVhB9wONs8Lz
         XaY2ypbqFBEwnCxSxB/Sz8UNX21T+ulQCj4+IaZophpDVFP7r6JCeZ+rDT5dE4t+W/7p
         M9wNPJBo3o4xvfaw4EVwL9QBB9l51NfdV4YmUxVF2URZ8rWn2miXkEseeheSGsw+2m+k
         9mJw==
X-Gm-Message-State: AOAM532itojdtr/3xTYT/x8PmF3THzf5CKI80W7pWyWtOHziWovVXW8/
        +dFj3ofnfwVVgwDjoG8HtBPmEBO6Cl1YBr6ckwUxrATP
X-Google-Smtp-Source: ABdhPJz2JKhLk0hjKAjoPekOqQMVI7RUghrGFM9Sxq0EV7pZlfHMTKagR7bupZ7ok2Nwy0hHS8vVIu2taUK4rPJxC54=
X-Received: by 2002:a6b:7b41:: with SMTP id m1mr9727660iop.186.1623566063047;
 Sat, 12 Jun 2021 23:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210611131029.679307-1-amir73il@gmail.com>
In-Reply-To: <20210611131029.679307-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 13 Jun 2021 09:34:11 +0300
Message-ID: <CAOQ4uxgdZqBv6ju+6HLXSPh1N5X+pzBXTB+0uhZw2dFhTs1ESA@mail.gmail.com>
Subject: Re: [PATCH] generic/507: support more filesystems
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Chao Yu <yuchao0@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 11, 2021 at 4:10 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> The commit message introducing the test says:
> "We only check below attribute modification which most filesystem
>  supports:
>     - no atime updates (A)
>     - secure deletion (s)
>     - synchronous updates (S)
>     - undeletable (u)
> "
> But in fact, very few filesystems support the (s) and (u) flags.
> xfs and btrfs do not support them for example.
>
> The test doesn't need to check those specific flags, so replace those
> flags with immutable (i) and append-only (a), which most filesystems
> really do support.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Eryu,
>
> This would be a good test to cover the recent fileattr vfs changes
> by Miklos that changed the implementation of SETFLAGS ioctl in all the
> filesystem, only the test does not run on most of the filesystems...
>
> Thanks,
> Amir.
>
>  tests/generic/507 | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/tests/generic/507 b/tests/generic/507
> index b654883a..cc61b3cb 100755
> --- a/tests/generic/507
> +++ b/tests/generic/507
> @@ -9,7 +9,7 @@
>  # i_flags can be recovered after sudden power-cuts.
>  # 1. touch testfile;
>  # 1.1 sync (optional)
> -# 2. chattr +[AsSu] testfile
> +# 2. chattr +[ASai] testfile

I missed the same fix that's needed in line 8. below...

>  # 3. xfs_io -f testfile -c "fsync";
>  # 4. godown;
>  # 5. umount;
> @@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  _cleanup()
>  {
>         cd /
> +       $CHATTR_PROG -ai $testfile &> /dev/null
>         rm -f $tmp.*
>  }
>
> @@ -49,7 +50,7 @@ _supported_fs generic
>
>  _require_command "$LSATTR_PROG" lasttr
>  _require_command "$CHATTR_PROG" chattr
> -_require_chattr AsSu
> +_require_chattr ASai
>
>  _require_scratch
>  _require_scratch_shutdown
> @@ -79,7 +80,7 @@ do_check()
>
>         before=`$LSATTR_PROG $testfile`
>
> -       $XFS_IO_PROG -f $testfile -c "fsync" | _filter_xfs_io
> +       $XFS_IO_PROG -r -f $testfile -c "fsync" | _filter_xfs_io
>
>         _scratch_shutdown | tee -a $seqres.full
>         _scratch_cycle_mount
> @@ -101,7 +102,7 @@ do_check()
>
>         before=`$LSATTR_PROG $testfile`
>
> -       $XFS_IO_PROG -f $testfile -c "fsync" | _filter_xfs_io
> +       $XFS_IO_PROG -r -f $testfile -c "fsync" | _filter_xfs_io
>
>         _scratch_shutdown | tee -a $seqres.full
>         _scratch_cycle_mount
> @@ -122,7 +123,7 @@ do_check()
>
>  echo "Silence is golden"
>
> -opts="A s S u"
> +opts="A S a i"
>  for i in $opts; do
>         do_check $i
>         do_check $i sync
> --
> 2.31.1
>
