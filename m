Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8FDEB64D8
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Jun 2023 18:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjFVSIC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjFVSIB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Jun 2023 14:08:01 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784701FED
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jun 2023 11:08:00 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id 71dfb90a1353d-4714e9f070bso2566607e0c.0
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jun 2023 11:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687457279; x=1690049279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3SpfpkSm7QX57pHLgtZxuZphS9HDEHPUEgYTbSXYgQ=;
        b=d5tmVTlteVE2uhaktLMQmpndNI2gK0uso6qgDv42ujCy+BQT+UtREZrIYCSaSuYOSO
         S1Aqs9fac0LxjuDr2lOlTouGuXEjBPQgfuXCxqgN540x0EatZ1MDlKkxTqHxPFE7r0JH
         lwfrQt3aBRRT3eL9cUwleoXTV6IJqE/XEXHNFL79GVUrqSY34T8EH1Ei60AC7Bpk0wgV
         9i2h1/BEw32MhwyfSxPJcW8paUU4+aLRE7DCTXR7bdXJd3+WGHG/85TXSb9aZ7/9s2RL
         bTCT+z65g+IP+wylXSNu6snWq8y1UmkhplyFcWd2uo29i8dHfNkSxAC4nlQh1eEeBpKu
         6v1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687457279; x=1690049279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3SpfpkSm7QX57pHLgtZxuZphS9HDEHPUEgYTbSXYgQ=;
        b=HKa5v5KNehefuF9odx8bxkfuYohbuBODM7+2QoWPigumoOmqez9YJkLfPNJXGvVy2q
         RhmwODlaQbQvlMmKSt62l/xTTRwAZVcWz3Q67mSXsdjDuVhPAN+7/V6GoOj2nTzDl4SH
         dww+YYciDnQg7GD+UQe8Bw42Sw+yBak26/hImgB8bD8JFLGCWeA26TbeX2OwoXooJBYL
         sPpFJli/K9d+tdbvDA1Z7ghmaSxH+e1TccdM2zIdxrsv2/WF2S3uBggaNsTAcp/GAi/B
         442NlcdvoIk8AB7nUT/P41U1otIELar3Rk6E72AlnMbGuwa+RMiEgPNcgbAaRntUJBoE
         na5w==
X-Gm-Message-State: AC+VfDyHvifCQEsZznV1yFtDN7hbXTJg1WGHKc3vp9gq1s0l+4O66wGW
        xvWY7+ONR6qp6R7lab1S4GH6cnO3m6TtkI/mLqc=
X-Google-Smtp-Source: ACHHUZ7LQdaD7aw1S/p6MsQNbpDdLaPb6gLNjkAD1zXHfXVpL8vbux5IDPa+jjnd4BDp7kGFKLEALXSI2y8hdMLlLeU=
X-Received: by 2002:a67:e3a6:0:b0:439:31ec:8602 with SMTP id
 j6-20020a67e3a6000000b0043931ec8602mr8276623vsm.27.1687457279262; Thu, 22 Jun
 2023 11:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
 <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
 <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com>
 <CAL7ro1FY6OmhypFGDjinOkkjyJzymntVje4nRA558dKY+KsgzQ@mail.gmail.com>
 <CAOQ4uxjuhzxgTxmRXxczJLDrMzKKr-jzS3R8ESwkw4XQ+UyAfQ@mail.gmail.com> <20230622161209.GA1191@sol.localdomain>
In-Reply-To: <20230622161209.GA1191@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 22 Jun 2023 21:07:48 +0300
Message-ID: <CAOQ4uxi+zRZRkZi_QQF22ygmJORXBfWw_mOTVe-jjvAaDWNhog@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Larsson <alexl@redhat.com>, tytso@mit.edu,
        miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 22, 2023 at 7:12=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Hi Amir,
>
> On Thu, Jun 22, 2023 at 12:36:59PM +0300, Amir Goldstein wrote:
> > > > What do I need to do in order to enable verity on ext4 besides
> > > > enabling FS_VERITY in the kernel?
> > > >
> > > > I'm getting these on verity tests on ext4 in the default 4k config.
> > > > _require_scratch_verity() doesn't mention any requirement other
> > > > that 4K blocks and extent format files.
> > > >
> > > > Thanks,
> > > > Amir.
> > > >
> > > > BEGIN TEST 4k (10 tests): Ext4 4k block Wed Jun 14 06:04:25 UTC 202=
3
> > > > DEVICE: /dev/vdb
> > > > EXT_MKFS_OPTIONS: -b 4096
> > > > EXT_MOUNT_OPTIONS: -o block_validity
> > > > FSTYP         -- ext4
> > > > PLATFORM      -- Linux/x86_64 kvm-xfstests
> > > > 6.4.0-rc2-xfstests-00026-g35774ba7f07c #1596 SMP PREEMPT_DYNAMIC Tu=
e
> > > > Jun 13 18:16:59 IDT 2023
> > > > MKFS_OPTIONS  -- -F -q -b 4096 /dev/vdc
> > > > MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> > > >
> > > > generic/572        [06:04:42] [06:04:47] [not run]
> > > > generic/572 -- ext4 verity isn't usable by default with these mkfs =
options
> > > > ...
> > >
> > > You need to "tune2fs -O verity" (or pass -O verity to mkfs.ext4).
> > >
> >
> > That was indeed missing in my setup, but it did not fix the problem.
> >
> > Turned out that I had a very old version of fsverity installed in my
> > kvm-xfstest test VM, where there is no --block-size option to
> > fsverity enable would always fail.
>
> That would do it.  So the tests were in fact skipping themselves as expec=
ted;
> just the skip message was not clear.
>

Right.

> >
> > Eric,
> >
> > You may consider adding a check for minimal version of
> > fsverity or check for support of --block-size option to make
> > this error reason more clear for testers.
>
> I'm thinking it wouldn't be worth bothering, as the --block-size option w=
as in
> the first actual release of fsverity-utils (v1.0).  You must have pulled =
down a
> work-in-progress version of fsverity-utils back in 2018 or early 2019, we=
ll
> before the kernel support for fsverity was upstreamed, and then never upd=
ated
> it.  I expect this issue affects very few people.
>

Agree.

> > Ted,
> >
> > FYI, FSVERITY_GIT in fstests-bld/config points to an out of date URL
>
> It was already updated several months ago.  Please run 'git pull'.
>

I thought I did. My bad.
Sorry for the noise.

> >
> > How come there is no ext4/cfg/verity in fstests-bld?
>
> xfstests has a verity test *group*, which contains the tests that were wr=
itten
> specifically to test verity.
>
> An xfstests-bld test config is something that applies to all tests.  Feat=
ures
> like "encrypt" have an xfstests-bld test config since there is a way to
> enable/use those features in all tests.  In the case of encrypt that mean=
s
> mounting the filesystem with "-o test_dummy_encryption".
>
> In the case of verity, there is no way to enable/use verity in all tests.=
  (It
> would be possible to always enable "-O verity" on the filesystem, but tha=
t does
> nothing to make verity actually be used/tested.)  Hence, it doesn't have =
an
> xfstests-bld test config.
>

Got it.

In case of overlayfs over ext4 (i.e. -c ext4:overlay/small) it is needed
to format ext4 in the beginning with -O verity because overlayfs
tests do not currently have support for formatting the base fs differently
per test.

This is the patch I intend to post.
Shout it you disagree:

commit 28d65d957c25eab85eb80b06724b215770a734a1
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu Jun 22 11:30:06 2023 +0300

    test-appliance: enable verity for testing overlay over ext4

    Add -O verity for ext4 formatted for overlay tests, so that overlay
    verity feature could be tested.

    Signed-off-by: Amir Goldstein <amir73il@gmail.com>

diff --git a/test-appliance/files/root/fs/overlay/config
b/test-appliance/files/root/fs/overlay/config
index 7c50b19..f252a70 100644
--- a/test-appliance/files/root/fs/overlay/config
+++ b/test-appliance/files/root/fs/overlay/config
@@ -55,7 +55,7 @@ function __mkfs()

        case "$BASE_FSTYPE" in
            ext4)
-               /sbin/mke2fs -F -q -t ext4 "$dev"
+               /sbin/mke2fs -F -q -t ext4 -O verity "$dev"
                ;;
            xfs)
                mkfs.xfs -f -m rmapbt=3D1,reflink=3D1 "$dev"


> > Are you guys not testing fsverity with fstests-bld?
>
> We are.  The documented way to test fsverity is to use kvm-xfstests:
> https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#tests
>
> > Should we just add fsverity config or add verity to ext4/cfg/encrypt
> > instead to avoid growing the test matrix?
> >
> > I can send patches for fstests-bld fixing the above if you like.
>
> As per the above, I don't think there is anything to fix.
>

Right.
Expect for the patch above which is needed for running Alex's
-g overlay/verity test

Thanks,
Amir.
