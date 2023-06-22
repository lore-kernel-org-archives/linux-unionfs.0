Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3302EEB64DB
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Jun 2023 09:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjFVJ4V (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 05:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjFVJ4F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Jun 2023 05:56:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42714231
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jun 2023 02:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687427522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uL8oas9uqV108enWPIe/aDdg6lw9SDmBe4NAf87K1VM=;
        b=ZdsDLzqPQe9JfnQ/YSLdC79ZbzmKylky7EBPzb2SVykx6FttcxFRC9EiRwq0pMRVdfaheP
        Wo5iKxsBtjqTIo0Kgscu6EYBnUdkp6Fv17DlRG4ITdgoJQ2MiWghAPvQdogv4kWZNedbiD
        mqN6umZtHeL3hZhGNwoxez2YdLX1axw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-XBS68zW1MM6ywQe-wr1gdw-1; Thu, 22 Jun 2023 05:52:00 -0400
X-MC-Unique: XBS68zW1MM6ywQe-wr1gdw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-341de9586d4so58777585ab.2
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jun 2023 02:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687427520; x=1690019520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uL8oas9uqV108enWPIe/aDdg6lw9SDmBe4NAf87K1VM=;
        b=AzUsCeE3DXNnjROCox+SlqI+MQ/rcQOaK/ZxFULHbVc1ZoDjc3rc0IoP/3KW4yxVr9
         H46ODEBAmdnETU8KOAhe8JSKH4YzH3X21P5Nb6Q+mV9bViqS0Sa2r4SJ2vyQf3tblZaD
         N8Sy1OJ3giP7nskrrCGKa1gvXAhLTx0dWIbZWd6akODm01/JrvIrpI0nOn3U41L9hF3n
         wvJ6xoKj5CcEOC4RPToOFY6tHZENs40SLB6KQUGZULkiu3cUocvkYs/sl4SH3aLahWwX
         3s3zZpjB9mkLEsRGWPiV3JM8zxKplGv126/0L2Khxb4HumjySwRoOZkeo1O7+2v3fc8K
         keIg==
X-Gm-Message-State: AC+VfDxDfiQVUI4F2uXFTteEZovmmx9LnT4ix9/Cjk/14JMH6xODvRrU
        r4s6iiI00mJcc4Suw11ZD6m0Wv+6mggThYNZ/6CJs2rUiBEzDr+2u4p06P0kexb9JbmmxTyAC16
        h5ER4qp6RRXkWQ1Z2YzpTGKwfElCow6QQVURvPmAJmA==
X-Received: by 2002:a92:c60a:0:b0:340:8186:e377 with SMTP id p10-20020a92c60a000000b003408186e377mr17817676ilm.25.1687427519853;
        Thu, 22 Jun 2023 02:51:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6WjznqxXr6nJx3QISfnC3H7b+Djs2cDv6PhKuepbthdNsxb4FnR6K0R1WcsB3N0VMSgyIT9qsEcjQMwQtkhDE=
X-Received: by 2002:a92:c60a:0:b0:340:8186:e377 with SMTP id
 p10-20020a92c60a000000b003408186e377mr17817669ilm.25.1687427519595; Thu, 22
 Jun 2023 02:51:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
 <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
 <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com>
 <CAL7ro1FY6OmhypFGDjinOkkjyJzymntVje4nRA558dKY+KsgzQ@mail.gmail.com> <CAOQ4uxjuhzxgTxmRXxczJLDrMzKKr-jzS3R8ESwkw4XQ+UyAfQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjuhzxgTxmRXxczJLDrMzKKr-jzS3R8ESwkw4XQ+UyAfQ@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 22 Jun 2023 09:51:48 +0000
Message-ID: <CAL7ro1GYEdMvjn+e8Y8CmMC-s_5NZOXjsj=iv7s5NbnpTZz+Cg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     ebiggers@kernel.org, tytso@mit.edu, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 22, 2023 at 11:37=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Wed, Jun 14, 2023 at 10:17=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com> wrote:
> >
> > On Wed, Jun 14, 2023 at 8:14=E2=80=AFAM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Mon, Jun 12, 2023 at 5:54=E2=80=AFPM Alexander Larsson <alexl@redh=
at.com> wrote:
> > > >
> > > > On Mon, Jun 12, 2023 at 1:09=E2=80=AFPM Alexander Larsson <alexl@re=
dhat.com> wrote:
> > > > >
> > > > > On Mon, Jun 12, 2023 at 12:54=E2=80=AFPM Amir Goldstein <amir73il=
@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jun 12, 2023 at 1:27=E2=80=AFPM Alexander Larsson <alex=
l@redhat.com> wrote:
> > > > > > >
> > > > > > > This patchset adds support for using fs-verity to validate lo=
werdata
> > > > > > > files by specifying an overlay.verity xattr on the metacopy
> > > > > > > files.
> > > > > > >
> > > > > > > This is primarily motivated by the Composefs usecase, where t=
here will
> > > > > > > be a read-only EROFS layer that contains redirect into a base=
 data
> > > > > > > layer which has fs-verity enabled on all files. However, it i=
s also
> > > > > > > useful in general if you want to ensure that the lowerdata fi=
les
> > > > > > > matches the expected content over time.
> > > > > > >
> > > > > > > I have also added some tests for this feature to xfstests[1].
> > > > > >
> > > > > > I can't remember if there is a good reason why your test does
> > > > > > not include verify in a data-only layer.
> > > > > >
> > > > > > I think this test coverage needs to be added.
> > > > >
> > > > > Yeah. I'll add that.
> > > >
> > > > Updated the git branch with some lowerdata tests.
> > > >
> > >
> > > What do I need to do in order to enable verity on ext4 besides
> > > enabling FS_VERITY in the kernel?
> > >
> > > I'm getting these on verity tests on ext4 in the default 4k config.
> > > _require_scratch_verity() doesn't mention any requirement other
> > > that 4K blocks and extent format files.
> > >
> > > Thanks,
> > > Amir.
> > >
> > > BEGIN TEST 4k (10 tests): Ext4 4k block Wed Jun 14 06:04:25 UTC 2023
> > > DEVICE: /dev/vdb
> > > EXT_MKFS_OPTIONS: -b 4096
> > > EXT_MOUNT_OPTIONS: -o block_validity
> > > FSTYP         -- ext4
> > > PLATFORM      -- Linux/x86_64 kvm-xfstests
> > > 6.4.0-rc2-xfstests-00026-g35774ba7f07c #1596 SMP PREEMPT_DYNAMIC Tue
> > > Jun 13 18:16:59 IDT 2023
> > > MKFS_OPTIONS  -- -F -q -b 4096 /dev/vdc
> > > MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> > >
> > > generic/572        [06:04:42] [06:04:47] [not run]
> > > generic/572 -- ext4 verity isn't usable by default with these mkfs op=
tions
> > > ...
> >
> > You need to "tune2fs -O verity" (or pass -O verity to mkfs.ext4).
> >
>
> That was indeed missing in my setup, but it did not fix the problem.
>
> Turned out that I had a very old version of fsverity installed in my
> kvm-xfstest test VM, where there is no --block-size option to
> fsverity enable would always fail.
>
> Eric,
>
> You may consider adding a check for minimal version of
> fsverity or check for support of --block-size option to make
> this error reason more clear for testers.
>
> Ted,
>
> FYI, FSVERITY_GIT in fstests-bld/config points to an out of date URL
>
> How come there is no ext4/cfg/verity in fstests-bld?
> Are you guys not testing fsverity with fstests-bld?
> Should we just add fsverity config or add verity to ext4/cfg/encrypt
> instead to avoid growing the test matrix?
>
> I can send patches for fstests-bld fixing the above if you like.
>
> Alex,
>
> Verified that your verity-tests2 work as expected with v5 patches.

To be honest I have not validated that my changes to the shared verity
code still works with the non-overlayfs tests. If you have a setup for
it it would be great if you could try the regular ext4 w/ fs-veriy
tests on top of the verity-test2 branch.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

