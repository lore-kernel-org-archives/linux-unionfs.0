Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1278EEC873E
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 16:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbjIGQLC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbjIGQKp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 12:10:45 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4067A9E
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 09:06:17 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-58ca499456dso11678477b3.1
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694102704; x=1694707504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIW1wQnbn7QifvC78y9tLpOKuKJRAApzYD1rdxYpBy4=;
        b=HrDLnOLNZMGpbFyUPmQuDWdykbyHfcxYbJz/Le4/uS5mpLVgLA2azwGv3/LicnWQDm
         SPe8eUjjjCDjjqG/bcB0xG9prL5GkmMsAUdnGjS884eI+Z4bf/WH/6AVfux3oirkJeAe
         Z3JvabXlVmb1JkjUdUWNyl18e59UmTxd0ABd7oe1KbQ+woLGkqaWln3KFgHk/uxbh0Za
         R/nuvEpS3FASquFWs37+WWVEprzRmuFYkiMiOtWZ7zbtjbnbIuL9Y7FmdFZAu9PAl4xi
         qNFwa5sYiRZyslbOHFI95trQaPwWTPaXQ9fUh7Pa+/JKb+Fh4InOZVZ2JWAXsStDlhv0
         YYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694102704; x=1694707504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tIW1wQnbn7QifvC78y9tLpOKuKJRAApzYD1rdxYpBy4=;
        b=ZK/btQO/tHhvm4opBD70ZcbZjhC5UZou5JpJaLHfZeAyFBKaqeyut4zSI39zC9OeI1
         piMRC9UGgyIbVVlymj4FApTK7H7yJDsJ9aNSzVUn4Nb9k1Oqbvh+lUyMcRO0MmAuxKt0
         Gt6gwDQnVLBoo3C2RrlRdWl1RPhprzSWnieqMXPQXvyFYFypRLX7V5SVLZnVShXRaPQl
         PRTXgiHtYM4gvhxsFJj8nZpCIiRZckI7nRBQ6f0uL6ZywInGOCTcmt0g6NGw/KPqZe0H
         Jexeub+unJZByYBm3pO0TR9Ta9LRqxvCQ+1V8lcgdaq4JfI3gln1dI1D9xv4WHcBaz3h
         NDNw==
X-Gm-Message-State: AOJu0YxjE61s19VjsXHVJYneWqEiMOoqxVi4Vbs0ovaE+H6oAvbl8DUQ
        cMyGWWrnDF7kch7Wja2kEJqYdB5ghsUf+J5XaL/urXXSQe8=
X-Google-Smtp-Source: AGHT+IE/w1hLcRCPW4Vjev2AhlyHnDqVEoYTU/tSsJgx4kOytycEQbUoyop5sAg9ELfuoyz60m9qYGet25Rm5GXXVt4=
X-Received: by 2002:a67:eb9a:0:b0:44d:41bc:705f with SMTP id
 e26-20020a67eb9a000000b0044d41bc705fmr6330826vso.16.1694092968112; Thu, 07
 Sep 2023 06:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com>
In-Reply-To: <cover.1694075674.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 7 Sep 2023 16:22:37 +0300
Message-ID: <CAOQ4uxgsH2B68O91-Rx8_EXNkwUe26M1P3EKRDnS-0u=GepVZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Support nested overlayfs mounts
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 7, 2023 at 11:44=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> There are cases where you want to use an overlayfs mount as a lowerdir fo=
r
> another overlayfs mount. For example, if the system rootfs is on overlayf=
s due
> to composefs, or to make it volatile (via tmpfs), then you cannot current=
ly store
> a lowerdir on the rootfs, becasue the inner overlayfs will eat all the wh=
iteouts
> and overlay xattrs. This means you can't e.g. store on the rootfs a prepa=
red
> container image for use with overlayfs.
>
> This patch series adds support for nesting of overlayfs mounts by escapin=
g the
> problematic features and unescaping them when exposing to the overlayfs u=
ser.
>
> This series is also available here:
>   https://github.com/alexlarsson/linux/tree/ovl-nesting
>
> And xfstest to test it is available here:
>   https://github.com/alexlarsson/xfstests/tree/overlayfs-nesting
>
> The overlay/083 test checks both xattr escaping, the new whiteouts as wel=
l as
> actual nesting of overlayfs.
>

This test look good. Left minor comments in github.
Missing test for the perplexing "escaped xwhiteouts across layers" use case=
.

> Note that this series breaks the overlay/026 test which validates that
> writing overlay.* xattrs is not supported, but it now is. I'm not sure
> if we should fix this test to not fail, or if we should make this an
> opt-in mount feature.

I think we don't need an opt-in mount option, but would like to know
what Miklos thinks?

We can fix the test this way:

setfattr trusted.overlayfsrz
verify success
getfattr trusted.overlayfsrz
verify success AND that xattr was not escaped

setfattr trusted.overlay.fsz
verify failure OR that xattr was escaped
getfattr trusted.overlay.fsz
verify failure OR that xattr was escaped

Thanks,
Amir.

>
> Changes since v2:
>  * Uses a new approach for escaping whiteouts with a regular file with an
>    overlay.whiteout xattr in a lower directory with an overlay.whiteouts
>    xattr.
>
> Changes since v1:
>
>  * Moved all xattr handling to xattr.c
>  * Made creation of escaped whiteouts atomic
>
> Alexander Larsson (6):
>   ovl: Move xattr support to new xattrs.c file
>   ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
>   ovl: Support escaped overlay.* xattrs
>   ovl: Add an alternative type of whiteout
>   ovl: Handle escaped xwhiteouts across layers
>   ovl: Add documentation on nesting of overlayfs mounts
>
>  Documentation/filesystems/overlayfs.rst |  23 ++
>  fs/overlayfs/Makefile                   |   2 +-
>  fs/overlayfs/dir.c                      |   4 +-
>  fs/overlayfs/inode.c                    | 124 ----------
>  fs/overlayfs/namei.c                    |  15 +-
>  fs/overlayfs/overlayfs.h                |  42 +++-
>  fs/overlayfs/readdir.c                  |  27 +-
>  fs/overlayfs/super.c                    |  67 +----
>  fs/overlayfs/util.c                     |  40 +++
>  fs/overlayfs/xattrs.c                   | 312 ++++++++++++++++++++++++
>  10 files changed, 443 insertions(+), 213 deletions(-)
>  create mode 100644 fs/overlayfs/xattrs.c
>
> --
> 2.41.0
>
