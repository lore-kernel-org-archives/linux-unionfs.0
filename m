Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06E6CA0EC3
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 12:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbjILMIn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 08:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbjILMIm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 08:08:42 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663BE10D3
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 05:08:38 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-44e8fc5dc63so1868019137.2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 05:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694520517; x=1695125317; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnsAqAKF3arSedku4VUBPUCrmcLbjRjjPSyibbzDenE=;
        b=UGst3fTRe08nLeBpKiWKdhQ2s94QaiRmjwzEIQno7myPwJJLyLTpEP3/6YsSz2cW8V
         oFmRUfw/0cnSwE+0whsxRRdJtShEVVkexmvs1ks1nC3PGA9lq2GOG+Molc8r6qXY65Wu
         lUVrAqEWcnfFgpIVdZus9BZCME4+CjdOvhHezz3b4b5lxiUnYt7DSUGxYgs2sshZzJQI
         gS3tkK86qCQtZVM7WTTouvWp3J4b1H7E2zWI5HmEnnsmNQbfDC4W4fIA0dBA885a0oJG
         A6FyqaqMWsHxIFvj34eDFI3If/yU0U6iQqZbopRS65aGBbXRuy2JSXevYYbko0O7hTyn
         W8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694520517; x=1695125317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnsAqAKF3arSedku4VUBPUCrmcLbjRjjPSyibbzDenE=;
        b=LThZCkGpQ7ng7rF7+DKZBXYjAuS5RuESj2igAljXDweS1EDmDQf9dqjlWHeTna3ZSL
         MHtxoo0Q9E/TfC95lKVu8uqYwJ5ITheR3jPYuxrkZLamHdgEcBk+bxxMHElYr2eNVMQW
         mhYvV6duSWxnZMCME5jL7enubkNqbKXIRxW/M/2YU3IRi6eW1mckG0pnloGHQoSMYkXO
         g36oEEeoH1OJxQcfKCN8Ky9FI6ZN3XHxfcCKQJDKo2a797tg31KWvvvZRe6bQgllNRtf
         i6DG9g9voWiGRInboP6kcyiObbjqeSaLiEpR256NrjI4V5a3M6Wm1DT0qsuLMo1nGMN0
         0W2Q==
X-Gm-Message-State: AOJu0YwLWdMPGDfpabufJdynDwPs+umFyCihZ81cWtfAiKhhyiUes9G8
        SWy5tkEIZ0VczsTrPnMGQe0Gi2niFBUznd8SW1U=
X-Google-Smtp-Source: AGHT+IG3OeaKnwu1x4H440QCNGpBSx20fFCRnTHAwXiZjy+Gk63TNUY714RAPekxV1oPB2jcT6389Mkao8J1HN+NmcE=
X-Received: by 2002:a67:eac5:0:b0:44e:8c20:a92d with SMTP id
 s5-20020a67eac5000000b0044e8c20a92dmr8122077vso.7.1694520517447; Tue, 12 Sep
 2023 05:08:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694512044.git.alexl@redhat.com>
In-Reply-To: <cover.1694512044.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 12 Sep 2023 15:08:26 +0300
Message-ID: <CAOQ4uxgoVmo2kqMkYbgOY4Wr9a=-2=qjFhdEgLJ6iznd_wET0Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Support nested overlayfs mounts with xattrs and whiteous
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:56=E2=80=AFPM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> There are cases where you want to use an overlayfs mount as a lowerdir fo=
r
> another overlayfs mount. For example, if the system rootfs is on overlayf=
s due
> to composefs, or to make it volatile (via tmpfs), then you cannot current=
ly store
> a lowerdir on the rootfs, because the inner overlayfs will eat all the wh=
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
> Note that this series breaks the overlay/026 test which validates that
> writing overlay.* xattrs is not supported, but it now is. I'm not sure
> if we should fix this test to not fail, or if we should make this an
> opt-in mount feature.

Please fix the test as we discussed:
1. relax the requirement that getxattr trusted.overlay should fail
2. set expectations for setxattr depending on result of getxattr

This way we will not lose much test coverage for old kernels.
This test fix can be posted to fstests ahead of time as preparation
for your patch set.

Given that this version has dropped the controversial bits
and that the whiteout implementation is the one that was
proposed by Miklos, I don't see any problem with it now.
I can queue it up for 6.7 and if Miklos has any objections
or comments, we have enough time to address them.

Thanks,
Amir.

>
> Changes since v3:
>  * Dropped the handling of whiteout xattrs across layers.
>  * Copy-up escaped overlayfs xattrs.
>  * Minor code cleanups.
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
> Alexander Larsson (5):
>   ovl: Move xattr support to new xattrs.c file
>   ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
>   ovl: Support escaped overlay.* xattrs
>   ovl: Add an alternative type of whiteout
>   ovl: Add documentation on nesting of overlayfs mounts
>
>  Documentation/filesystems/overlayfs.rst |  23 ++
>  fs/overlayfs/Makefile                   |   2 +-
>  fs/overlayfs/dir.c                      |   4 +-
>  fs/overlayfs/inode.c                    | 124 -----------
>  fs/overlayfs/namei.c                    |  15 +-
>  fs/overlayfs/overlayfs.h                |  42 +++-
>  fs/overlayfs/readdir.c                  |  27 ++-
>  fs/overlayfs/super.c                    |  67 +-----
>  fs/overlayfs/util.c                     |  40 ++++
>  fs/overlayfs/xattrs.c                   | 273 ++++++++++++++++++++++++
>  10 files changed, 404 insertions(+), 213 deletions(-)
>  create mode 100644 fs/overlayfs/xattrs.c
>
> --
> 2.41.0
>
