Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5F0CCF9E9
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 Sep 2023 00:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbjIFAUF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 20:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjIFAUE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Sep 2023 20:20:04 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78589C2
        for <linux-unionfs@vger.kernel.org>; Tue,  5 Sep 2023 17:20:00 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-6516a8e2167so18803726d6.2
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Sep 2023 17:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693959599; x=1694564399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gUanDTBJLT6YkNoFBDuHA2hli46RjA2kLxjH0vZLVM=;
        b=i8gkzbfrvD3IvNRDHBa5/BQL3R6dNoOWShzVJI9U1SEGXMjpyrzR7jbVoioUc14Ez8
         7tBoEFzDEkYVaGNsK93B/qwPrjoj/81Mu9k40LXGa3K2YPCYjTv/WXw0V/ASiCfNn8sG
         ZA2/IVztWwDpgVwKqNe2qMbxf3pIch9V6/3/poR5ZWVgnn615uEosi8ZbvN8Qtq7nb0B
         dZ4si/jA9GN4bGD4cHM93hRHWOSOpwULtYYAp7Bz+ShUehKu7YRT+r7oad9zHy52DGSo
         CBZG9kTp91kJJvqrH6Y4EqMuviSVLncspGwMWAxwMlj3kBkvk+eIz1NevCeex6yiiPOo
         Xt8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693959599; x=1694564399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8gUanDTBJLT6YkNoFBDuHA2hli46RjA2kLxjH0vZLVM=;
        b=mDjizeO2I+7bH+dKC+fwlSIuWpFg1txTTUotOq6daFII6c8ujMezIzLl2s14n/xwMN
         AjhdwsD5CjOWOxx7ooslFEkCeDpU6P/7uHzPaIU+VvFwmXQnf/sJJ+MabkwZ0AroVL80
         XlIWGWcz8311oYmWvBNWLsqPiibYLsOShS7/4BturlBUIkv8W5ILq9srXfoUgOEVeSex
         NOcjUxJRVKzgKvhFNPUM1KW1SuujlxutoyI/S20ptHY67/NS2bebK+QEcT1mxbMDZExc
         gP4tykgCvu0jBqYB/0ArzHWsHLAt6JFAuCHCmedcesxQNJDFpO3nVSj1E//CjrR8uoQc
         vZhw==
X-Gm-Message-State: AOJu0YzqBgOs6JIN+JQmZep5GgRk6FMnE0vm0jRgYjKk3dAaUMIfbn2J
        RwLXhSxK1HjdBxstPJla0iPtCaOkXknGFkem4nNAGgerbgePicwH+j6MYQ==
X-Google-Smtp-Source: AGHT+IEBh36v6jbAggOwiDPAHzZQXAobH39IlLticbeHyBO1pdWWV4blGHBjc8kT8NX7jfk06K2RZMb+9758tnhP3gs=
X-Received: by 2002:a05:6214:8e9:b0:64f:802b:7e07 with SMTP id
 dr9-20020a05621408e900b0064f802b7e07mr15238620qvb.55.1693959599439; Tue, 05
 Sep 2023 17:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230904132441.2680355-1-amir73il@gmail.com> <CAJfpegtNgHnacX4CaPU8cyZcK=WPWHF_yK6CcGH1MFNYpT3UqQ@mail.gmail.com>
 <CAKd=y5EWW0WBeG-pEhOFnooonOnqdAs1RUHPTsq7h3M9uDJMxg@mail.gmail.com> <CAOQ4uxgkHCCT8prDpKPf2rgXSEwgF6yj8AeTE1qrY9V=2CaEYw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgkHCCT8prDpKPf2rgXSEwgF6yj8AeTE1qrY9V=2CaEYw@mail.gmail.com>
From:   Ruiwen Zhao <ruiwen@google.com>
Date:   Tue, 5 Sep 2023 17:19:48 -0700
Message-ID: <CAKd=y5Hm8c7cPmHq0hoWojTSiKEgrbRzB5wgV4wkaQ_M0VR0NQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix failed copyup of fileattr on a symlink
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 4, 2023 at 11:57=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Sep 4, 2023 at 9:40=E2=80=AFPM Ruiwen Zhao <ruiwen@google.com> wr=
ote:
> >
> > On Mon, Sep 4, 2023 at 6:44=E2=80=AFAM Miklos Szeredi <miklos@szeredi.h=
u> wrote:
> > >
> > > On Mon, 4 Sept 2023 at 15:24, Amir Goldstein <amir73il@gmail.com> wro=
te:
> > > >
> > > > Some local filesystems support setting persistent fileattr flags
> > > > (e.g. FS_NOATIME_FL) on directories and regular files via ioctl.
> > > > Some of those persistent fileattr flags are reflected to vfs as
> > > > in-memory inode flags (e.g. S_NOATIME).
> > > >
> > > > Overlayfs uses the in-memory inode flags (e.g. S_NOATIME) on a lowe=
r file
> > > > as an indication that a the lower file may have persistent inode fi=
leattr
> > > > flags (e.g. FS_NOATIME_FL) that need to be copied to upper file.
> > > >
> > > > However, in some cases, the S_NOATIME in-memory flag could be a fal=
se
> > > > indication for persistent FS_NOATIME_FL fileattr. For example, with=
 NFS
> > > > and FUSE lower fs, as was the case in the two bug reports, the S_NO=
ATIME
> > > > flag is set unconditionally for all inodes.
> > > >
> > > > Users cannot set persistent fileattr flags on symlinks and special =
files,
> > > > but in some local fs, such as ext4/btrfs/tmpfs, the FS_NOATIME_FL f=
ileattr
> > > > flag are inheritted to symlinks and special files from parent direc=
tory.
> > > >
> > > > In both cases described above, when lower symlink has the S_NOATIME=
 flag,
> > > > overlayfs will try to copy the symlink's fileattrs and fail with er=
ror
> > > > ENOXIO, because it could not open the symlink for the ioctl securit=
y hook.
> > > >
> > > > To solve this failure, do not attempt to copyup fileattrs for anyth=
ing
> > > > other than directories and regular files.
> > > >
> > > > Reported-by: Ruiwen Zhao <ruiwen@google.com>
> > > > Link: https://lore.kernel.org/r/CAKd=3Dy5Hpg7J2gxrFT02F94o=3DFM9QvG=
p=3DkcH1Grctx8HzFYvpiA@mail.gmail.com/
> > > > Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> > > > Cc: <stable@vger.kernel.org> # v5.15
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Hi Miklos,
> > > >
> > > > Do you agree with this solution?
> > >
> > > It's good enough.   Linux might add API's in the future that allow
> > > querying and setting fileattr on symlinks, but we can deal with that
> > > later.
> > >
> > > Thanks,
> > > Miklos
> >
> > Thanks Amir for sending the fix! The fix looks good but I am not sure
> > how to LGTM it. (Still new to the kernel review process)
> >
> > I believe the fix will be merged to the master branch first. Can we
> > backport it to 5.15, considering this is a regression and 5.15 is an
> > LTS version?
> >
>
> The commit, when it gets merged will include:
>
>     Reported-by: Ruiwen Zhao <ruiwen@google.com>
>     Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217850
>     Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
>     Cc: <stable@vger.kernel.org> # v5.15
>
> So it should be automatically picked for stable bots
> and by bugzilla I suppose.
>
> Please let me know if you tested my patch and I will change to
> Reported-and-tested-by:
>
> Thanks,
> Amir.

Thanks! I tested this patch with the same repro step mentioned before
and can confirm it fixed the issue. Also checked dmesg and can confirm
there is no error. I think we can merge the fix.

ruiwen@instance-1:/tmp # mv merged/home/ruiwen/foolink
merged/home/ruiwen/foolink2
ruiwen@instance-1:/tmp # ls -l merged/home/ruiwen/ -l
total 0
-rw-r--r-- 1 root root 0 Sep  6 00:07 foo
lrwxrwxrwx 1 root root 3 Sep  6 00:07 foolink2 -> foo



Thanks,
Ruiwen
