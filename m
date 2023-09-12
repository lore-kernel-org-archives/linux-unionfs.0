Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2062DCA0EF1
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 16:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbjILQUp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbjILQUo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 12:20:44 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8817D10F1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 09:20:40 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id ada2fe7eead31-44d60bb6aa5so2396809137.2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694535636; x=1695140436; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXSPBXxctXGYkdLcIqyMJCx7mPtbev1Vd+A2Tw44s2o=;
        b=DCP+3c9txEy2XIaTow45+9N3VfWEs+q1706yC8qsXeVCUCSXQsPzcIBBxIl+kIekLu
         2y5VRpkCG55I8JNcKRJyDZPmASYwfhZBeAI2ueejkytCgOoC5WuPeXjxG9hYreecgkrX
         Jt4p2JWkR+OOjxorMpwZvZqt7Gq5ym5Ww+861zoHvm7S6BRqxs+3jPxGPpdFmmTK2uPZ
         p4N0WBl8zNwmbLT9yJ+8zkAkWrCWsFDqFWg+o4wVV9RSUlk4Rc7TL896RSjKnGWUljGT
         VB2hlfiPRQvJaBPnJG4Ub5cKknp30pdmuB1OK0DPZ7RdTulIIfZRUqYcP/2ZglYeBD+y
         i5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694535636; x=1695140436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mXSPBXxctXGYkdLcIqyMJCx7mPtbev1Vd+A2Tw44s2o=;
        b=UN6lKUAcHUNAFk66Bj9LCcDhyxk/iEL8W1VhXIpyLO1w/XmpDc8C8gqByxUAWzsko7
         IVr3CRz8Lmv8KDBrcNz1lZsjrB4wQ1iAg6GkeWpLeeWrjQ3/J1jt0EYOQCBNot52ycvU
         9sqGHWG5caUizA7uH+Ce24lCs7FV9CX1TNazCKwo9qgV+SbFygkWvcrjm6y+Jpr6hKm1
         sTLXyh/nx9s5veMXJbOxCanaC4DQ/4D2BK999knSBb4OZggjoD7ZNkCG3vC0YNxtPJe1
         WlWmVQY4sFPRpDx54G8RawjJYy/QNZzi5Jnj/FlqmxdGtGbC4Y4FybMeE0xqzz9hq8Yd
         nglQ==
X-Gm-Message-State: AOJu0YyxQcIG085KNiqkX/jyeDeBJEOMeFkKxvhmy28zmdIhhOipkKDV
        UndB2cRnAVtKwCI8WoxSaSG6l4jcW4t4hJ7iLHfKZZtXG9A=
X-Google-Smtp-Source: AGHT+IF8Fz/IYpyjLZRya8/5HH12PaLCBR846cKmKV769tKUGuvHyhzL67R5jWiymYXSQ6xCHXeiaUnOi/DdXXtj1kI=
X-Received: by 2002:a05:6102:a2b:b0:44e:a558:5ec4 with SMTP id
 11-20020a0561020a2b00b0044ea5585ec4mr12027391vsb.9.1694535636219; Tue, 12 Sep
 2023 09:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694512044.git.alexl@redhat.com> <CAOQ4uxgoVmo2kqMkYbgOY4Wr9a=-2=qjFhdEgLJ6iznd_wET0Q@mail.gmail.com>
 <CAL7ro1F9cuyXqQEgQHm1Fwo0vFJTUFVXuBXR-v9U1JUFpcW11Q@mail.gmail.com>
In-Reply-To: <CAL7ro1F9cuyXqQEgQHm1Fwo0vFJTUFVXuBXR-v9U1JUFpcW11Q@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 12 Sep 2023 19:20:25 +0300
Message-ID: <CAOQ4uxg5r5uVzjGfEHNsp5PENWhggGzqntB7Xp0xCcC+x0osLA@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Support nested overlayfs mounts with xattrs and whiteous
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 12, 2023 at 6:36=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
>
>
> On Tue, Sep 12, 2023 at 2:08=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
>>
>> On Tue, Sep 12, 2023 at 12:56=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
>> >
>> > There are cases where you want to use an overlayfs mount as a lowerdir=
 for
>> > another overlayfs mount. For example, if the system rootfs is on overl=
ayfs due
>> > to composefs, or to make it volatile (via tmpfs), then you cannot curr=
ently store
>> > a lowerdir on the rootfs, because the inner overlayfs will eat all the=
 whiteouts
>> > and overlay xattrs. This means you can't e.g. store on the rootfs a pr=
epared
>> > container image for use with overlayfs.
>> >
>> > This patch series adds support for nesting of overlayfs mounts by esca=
ping the
>> > problematic features and unescaping them when exposing to the overlayf=
s user.
>> >
>> > This series is also available here:
>> >   https://github.com/alexlarsson/linux/tree/ovl-nesting
>> >
>> > And xfstest to test it is available here:
>> >   https://github.com/alexlarsson/xfstests/tree/overlayfs-nesting
>> >
>> > The overlay/083 test checks both xattr escaping, the new whiteouts as =
well as
>> > actual nesting of overlayfs.
>> >
>> > Note that this series breaks the overlay/026 test which validates that
>> > writing overlay.* xattrs is not supported, but it now is. I'm not sure
>> > if we should fix this test to not fail, or if we should make this an
>> > opt-in mount feature.
>>
>> Please fix the test as we discussed:
>> 1. relax the requirement that getxattr trusted.overlay should fail
>> 2. set expectations for setxattr depending on result of getxattr
>>
>> This way we will not lose much test coverage for old kernels.
>> This test fix can be posted to fstests ahead of time as preparation
>> for your patch set.
>
>
> Added to  https://github.com/alexlarsson/xfstests/commits/overlayfs-nesti=
ng
>

Nice.

Not sure that you need "getattr ok" in the golden output.

Also, if you test "legit failure" with [[ "$res" =3D~ "Operation not" ]]
there is no need to sed the output of [gs]etfattr not to _filter_scratch.
Those are only done to canonicalize the golder output.

However, test 083 failed all the xwhiteout test cases when I ran
it with your ovl-nesting-4 tag:

 =3D=3D Check xwhiteout trusted =3D=3D
+hidden
 regular
-stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
+  File: SCRATCH_MNT/hidden
...

>> Given that this version has dropped the controversial bits
>> and that the whiteout implementation is the one that was
>> proposed by Miklos, I don't see any problem with it now.
>> I can queue it up for 6.7 and if Miklos has any objections
>> or comments, we have enough time to address them.
>>
>
> That sounds good to me.
>
>>
>> Thanks,
>> Amir.
>>
>> >
>> > Changes since v3:
>> >  * Dropped the handling of whiteout xattrs across layers.
>> >  * Copy-up escaped overlayfs xattrs.
>> >  * Minor code cleanups.
>> >
>> > Changes since v2:
>> >  * Uses a new approach for escaping whiteouts with a regular file with=
 an
>> >    overlay.whiteout xattr in a lower directory with an overlay.whiteou=
ts
>> >    xattr.
>> >
>> > Changes since v1:
>> >
>> >  * Moved all xattr handling to xattr.c
>> >  * Made creation of escaped whiteouts atomic
>> >
>> > Alexander Larsson (5):
>> >   ovl: Move xattr support to new xattrs.c file
>> >   ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
>> >   ovl: Support escaped overlay.* xattrs
>> >   ovl: Add an alternative type of whiteout
>> >   ovl: Add documentation on nesting of overlayfs mounts
>> >
>> >  Documentation/filesystems/overlayfs.rst |  23 ++
>> >  fs/overlayfs/Makefile                   |   2 +-
>> >  fs/overlayfs/dir.c                      |   4 +-
>> >  fs/overlayfs/inode.c                    | 124 -----------
>> >  fs/overlayfs/namei.c                    |  15 +-
>> >  fs/overlayfs/overlayfs.h                |  42 +++-
>> >  fs/overlayfs/readdir.c                  |  27 ++-
>> >  fs/overlayfs/super.c                    |  67 +-----
>> >  fs/overlayfs/util.c                     |  40 ++++
>> >  fs/overlayfs/xattrs.c                   | 273 +++++++++++++++++++++++=
+
>> >  10 files changed, 404 insertions(+), 213 deletions(-)
>> >  create mode 100644 fs/overlayfs/xattrs.c
>> >
>> > --
>> > 2.41.0
>> >
>>
>
>
> --
> =3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
>  Alexander Larsson                                Red Hat, Inc
>        alexl@redhat.com         alexander.larsson@gmail.com
