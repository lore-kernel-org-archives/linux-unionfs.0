Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E02DC77B7D
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 May 2023 21:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjENVZy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 May 2023 17:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjENVZy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 May 2023 17:25:54 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBCC10EA
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 14:25:51 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id a1e0cc1a2514c-77d53b41462so3233609241.1
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 14:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684099551; x=1686691551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFCxEBuR0nNvpA2o5eygso5Yh8HZ58ESPYkuhjzHOw0=;
        b=qKRYYp7/s/bO5N5VWEyrOTjFlFHQPH6f/oG72FjiRovyeWTsMcUbCo/ieQvHQFLYsc
         0vIyvM1ahB3LhJOJ8U037y96ev43wrfD/Q0TI/nLTMavhw2BeHt1Ybrk8SQg8+0symu2
         8QSKyFFyNIVCVHlim3qg+2vk8ytDT1ghItW1Y0Z231X+M0awxbwa9EE1bqAUIvMSi/p6
         DQasSLVT8Ln2f+k+/vAkEZxGtjpBySa4B3dhhvykwgEDfI77zS/lBp81uizWxvWgsgG2
         fuXATSa9LFLxw95CkOaNG6iI01qlMzjWk2oNYNd3v+RZkN5zulwaHQdjIcd9iA+othIc
         RMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684099551; x=1686691551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFCxEBuR0nNvpA2o5eygso5Yh8HZ58ESPYkuhjzHOw0=;
        b=TxVRZzZd4PjJafR4u4hhom0PPz+EBFVmtN5BPQyMlb1qwcL0z6gplYx4rT9kHMrHuJ
         dhONZ8SEugu5UZEKdmHQBxgBQsNuwiUGDS/9lAmFCDlQFoAwZTWNuke0j4vRbni0AKxp
         lINSmw5+WAOwS2lRB2rsvA4BWzFK48zs1YuCPqzGPwYCQOKzuCgnxQWpHZzAqbT4fmvn
         vprrXpwdKl/xUpNmMG0RMhVm8VyR/xxYa12E/RaiN/oNSt3U6m9Nqha/ZKVwAchkEyBY
         8lDmXc2r9JSEqV3aPNvNc9fR4nNwIwqOVICwUvnsi9ABsFp5zOu3lwVwpEtsY8JXVKOm
         Q7EA==
X-Gm-Message-State: AC+VfDx4k1VqM0kVKNj1V+5siiqVbRx+d4XaLr2nYLwiYyW/Bm7KlKoA
        oZg9acBvtZmY6l5X75nQAgRikoJV6RItePwICy4=
X-Google-Smtp-Source: ACHHUZ6VVM58T9UJaFzHhIZ2czklHdt88jg1zk7+IJbgdjDYee/qKNg+Vy+CSzQF0yz9lVM0Y54RJX+NEakFtsyUpwc=
X-Received: by 2002:a67:f65a:0:b0:434:8bf5:2a9f with SMTP id
 u26-20020a67f65a000000b004348bf52a9fmr10583670vso.3.1684099550641; Sun, 14
 May 2023 14:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <20230514190903.GC9528@sol.localdomain>
In-Reply-To: <20230514190903.GC9528@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 May 2023 00:25:39 +0300
Message-ID: <CAOQ4uxj73Tu1XKSte-csHKH4pUN_84Px42MdZ4rVt9hUdjHJ2g@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] ovl: Add support for fs-verity checking of lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 10:09=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> Hi Alexander,
>
> On Wed, May 03, 2023 at 10:51:33AM +0200, Alexander Larsson wrote:
> > This patchset adds support for using fs-verity to validate lowerdata
> > files by specifying an overlay.verity xattr on the metacopy
> > files.
> >
> > This is primarily motivated by the Composefs usecase, where there will
> > be a read-only EROFS layer that contains redirect into a base data
> > layer which has fs-verity enabled on all files. However, it is also
> > useful in general if you want to ensure that the lowerdata files
> > matches the expected content over time.
> >
> > This patch series is based on the lazy lowerdata patch series by Amir[1=
].
> >
> > I have also added some tests for this feature to xfstests[2].
> >
> > I'm also CC:ing the fsverity list and maintainers because there is one
> > (tiny) fsverity change, and there may be interest in this usecase.
> >
> > Changes since v1:
> >  * Rebased on v2 lazy lowerdata series
> >  * Dropped the "validate" mount option variant. We now only support
> >    "off", "on" and "require", where "off" is the default.
> >  * We now store the digest algorithm used in the overlay.verity xattr.
> >  * Dropped ability to configure default verity options, as this could
> >    cause problems moving layers between machines.
> >  * We now properly resolve dependent mount options by automatically
> >    enabling metacopy and redirect_dir if verity is on, or failing
> >    if the specified options conflict.
> >  * Streamlined and fixed the handling of creds in ovl_ensure_verity_loa=
ded().
> >  * Renamed new helpers from ovl_entry_path_ to ovl_e_path_
> >
> > [1] https://lore.kernel.org/linux-unionfs/20230427130539.2798797-1-amir=
73il@gmail.com/T/#m3968bf64a31946e77bdba8e3d07688a34cf79982
> > [2] https://github.com/alexlarsson/xfstests/commits/verity-tests
> >
> > Alexander Larsson (6):
> >   fsverity: Export fsverity_get_digest
> >   ovl: Break out ovl_e_path_real() from ovl_i_path_real()
> >   ovl: Break out ovl_e_path_lowerdata() from ovl_path_lowerdata()
> >   ovl: Add framework for verity support
> >   ovl: Validate verity xattr when resolving lowerdata
> >   ovl: Handle verity during copy-up
> >
> >  Documentation/filesystems/overlayfs.rst |  27 ++++
> >  fs/overlayfs/copy_up.c                  |  31 +++++
> >  fs/overlayfs/namei.c                    |  42 +++++-
> >  fs/overlayfs/overlayfs.h                |  12 ++
> >  fs/overlayfs/ovl_entry.h                |   3 +
> >  fs/overlayfs/super.c                    |  74 ++++++++++-
> >  fs/overlayfs/util.c                     | 165 ++++++++++++++++++++++--
> >  fs/verity/measure.c                     |   1 +
> >  8 files changed, 343 insertions(+), 12 deletions(-)
>
> Thanks for presenting this topic at LSFMM!
>
> I'm not an expert in overlayfs, but I've been working through this patchs=
et.
>
> One thing that seems to be missing, and has been tripping me up while rev=
iewing
> this patchset, is that the overlayfs documentation
> (Documentation/filesystems/overlayfs.rst) is not properly up to date with=
 the
> use case that is intended here.
>
> For example, the overlayfs documentation says "An overlay filesystem comb=
ines
> two filesystems - an 'upper' filesystem and a 'lower' filesystem.".
>
> Apparently, that is out of date.  I think a correct statement would be: A=
n
> overlay filesystem combines an optional upper directory with one or more =
lower
> directories.
>
> And as I understand it, the use case here actually involves two lower
> directories and no upper directory.
>
> There is also the "metacopy" feature, which the documentation describes i=
n the
> section "Metadata only copy up".  The documentation makes it sound like a=
n
> overlayfs internal optimization.
>
> However, when this patchset introduces the fsverity support, it talks abo=
ut
> "metacopy files".  As I understand it, the user is expected to create a
> read-only filesystem that contains these "metacopy files".  It doesn't se=
em to
> be documented what these are, exactly, and how to create them.  I assume =
that
> these are part of the implementation of "Metadata only copy up", but ther=
e seems
> to be a gap where the documentation goes from describing the behavior of
> "metadata only copy up", to expecting users of overlayfs to know what a
> "metacopy file" is and how to create them.
>

What may confuse you is that Alexander has a tool mkfs.composefs
that creates hand crafted overlayfs, but it is not up to overlayfs.rst to
document this tool.

This patch set and documentation of the feature are standalone to
overlayfs and they affect and explain standard user workloads.

A "metacopy file" is one that has metadata changes in upper layer
but the data is still read from the lower layer.

The classic example, for which metacopy feature was developed is
chwon -R on a mounted overlay without having to copy up the data.

I agree that it would be good to clarify this term before using it.

With mount options metacopy=3Don,verity=3Don, once a file's metadata
was copied up, and its owner changed for the sake of the story, the
lower data file cannot be replaced with another file with different data
or without fsverity, while overlayfs is offline.

> I think that it would be easier to understand and review this feature if =
the
> documentation was gotten up to date.
>

Those are all valid comments, but I don't think it would be fair to
require Alexander to fix the out of date documentation of overlayfs.

IMO, the documentation of verity feature should be judged for its
own clarity (and I myself find it pretty clear) assuming that the reader
is familiar with overlayfs and metacopy, but I will surely not object if
Alexander wants to help improve overlayfs.rst.

Thanks,
Amir.
