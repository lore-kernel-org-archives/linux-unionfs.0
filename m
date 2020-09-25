Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B04C4363D
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 17:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C64221EC
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 17:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHQc34dV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgIYRtj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 13:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgIYRtj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 13:49:39 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9B2C0613CE;
        Fri, 25 Sep 2020 10:49:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r25so3783054ioj.0;
        Fri, 25 Sep 2020 10:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Us4LjEbuSKpAUvGs1rVM1OWyulrtnSpOCw9dCioAks=;
        b=EHQc34dV5WNeECq/FBm317/Y/cJbliBg/MZdEcsBzpogYnReCbNVz+P3SNFAp1oDAZ
         3AsKXQOKYLu315ZVRJ9LAE0q/QsovUH+ud0ZFlWRPrkooW+BbsJ00xcNHiq4LA+A7cvE
         HJ4igp7T7vOd9ttu3/lrb3rLrXac12odByrnaDA3ZEcLnHJsFbzy+wueMZny4SuQ211D
         xtO1vsYFsonjoABS57oH1yUVNZvABWqmo004nDuWQQJJVPgiHgzMMs1Jc94WHYoEr0aO
         WJotH5//a8hiY0moJEDddYkTzZI7Jy6cKM1jmXM2flfOQidfppZ0fgtSW5C5DNVOameK
         3jJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Us4LjEbuSKpAUvGs1rVM1OWyulrtnSpOCw9dCioAks=;
        b=UrsnNtGevH2AehJ/1EMtMMeAei8RfhJH9HlWEUulzHQh6EyS3VSgY/vUGSdqdBKrdD
         TOt3gn3ybFlgKgckeJq3/Q8K+U+/E4e4dqrzBDmwDV/+ZNxAtH5qFDqNCnoNyuhjxECF
         WVFvjSSu8tVAnPSYswWsWjCe6STbljpd74Qt7wVWk4SYO/SzQOC6uzCgevhknJigF9uZ
         mDRw0tl2yDYXAXILERTcBS40ZHtuZCBfXTAEacWYz71ku42n/TDNPJ82r5v+1SivVt+o
         2dxnc4NHy6M9jc3UDbaxhE+8mCm+M8Rx+9WXftmxECLxYNF22Twn6DdOsAI9fmecF7j8
         85RA==
X-Gm-Message-State: AOAM532bpB93vwkMOMYguFyEkl8QcbpxYeFJxCWzP2MfxUgnDt+3Wdw6
        S+T8k5U5enZN2nPNoFvQ558PbQVocFI1uN4YeDX1nbhinHA=
X-Google-Smtp-Source: ABdhPJxmEosvtNHZ4tNHa2M5HHY8g8Mr46Or5U3B6wDLIl5SaDmvM0xheXzCtsPFeBbpyOqfm96qfKJyXDl68iHN1IM=
X-Received: by 2002:a05:6638:2185:: with SMTP id s5mr198104jaj.120.1601056178034;
 Fri, 25 Sep 2020 10:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com>
 <CAOQ4uxitZDVjbvBnb95UHWD6CzaBeoJ8deqR6nbmgRRJ3P2=UA@mail.gmail.com>
 <5F686A74.4040002@cn.fujitsu.com> <CAOQ4uxhfUbFhecA9ShKUxyjS=LsMoyztXwWUJw-ZXm+Z0eJ6DQ@mail.gmail.com>
 <5F69B2A4.2050407@cn.fujitsu.com> <CAOQ4uxg-4xOSVxkLZrH_zrd9054z+SH_+YdcPnT3PVNYogJ3gw@mail.gmail.com>
 <5F6E08C8.8050305@cn.fujitsu.com>
In-Reply-To: <5F6E08C8.8050305@cn.fujitsu.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 25 Sep 2020 20:49:26 +0300
Message-ID: <CAOQ4uxh1-Sr2tYqY8iudFZdtvUrf3udAdU15kqWOPjD+7k2wzA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Support FS_IOC_[SG]ETFLAGS and FS_IOC_FS[SG]ETXATTR
 ioctls on directories
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 25, 2020 at 6:13 PM Xiao Yang <yangx.jy@cn.fujitsu.com> wrote:
>
> On 2020/9/22 20:01, Amir Goldstein wrote:
> > On Tue, Sep 22, 2020 at 11:15 AM Xiao Yang<yangx.jy@cn.fujitsu.com>  wr=
ote:
> >> On 2020/9/21 17:09, Amir Goldstein wrote:
> >>> On Mon, Sep 21, 2020 at 11:55 AM Xiao Yang<yangx.jy@cn.fujitsu.com>  =
 wrote:
> >>>> On 2020/9/21 16:17, Amir Goldstein wrote:
> >>>>> On Mon, Sep 21, 2020 at 10:41 AM Xiao Yang<yangx.jy@cn.fujitsu.com>=
    wrote:
> >>>>>> Factor out ovl_ioctl() and ovl_compat_ioctl() and take use of them=
 for
> >>>>>> directories.
> >>>>>>
> >>>>>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
> >>>>>> ---
> >>>>> This change is buggy. I had already posted it and self NACKed mysel=
f [1].
> >>>>>
> >>>>> You can find an hopefully non-buggy version of it on my ovl-shutdow=
n [2] branch.
> >>>>>
> >>>>> As long as you are changing ovl_ioctl(), please also take the secon=
d
> >>>>> commit on that
> >>>>> branch to replace the open coded capability check with the
> >>>>> vfs_ioc_setflags_prepare()
> >>>>> generic helper.
> >>>> Hi Amir,
> >>>>
> >>>> Thanks a lot for your quick reply. :-)
> >>>> I will try to read and understand the metioned patches on your
> >>>> ovl-shutdown branch.
> >>> Please also verify my claim in the patch commit message, that the
> >>> the test result of xfstest generic/079 changes from "notrun" to "succ=
ess".
> >> Hi Amir,
> >>
> >> With your patches, I have confirmed that generic/079 actually changed =
from
> >> "notrun" to "success".  Besides, one minor issue:
> >> Could we avoid the following compiler warning?
> >> -------------------------------------------------
> >> fs/overlayfs/readdir.c: In function =E2=80=98ovl_dir_real_file=E2=80=
=99:
> >> fs/overlayfs/readdir.c:883:37: warning: passing argument 1 of
> >> =E2=80=98ovl_dir_open_realfile=E2=80=99 discards =E2=80=98const=E2=80=
=99 qualifier from pointer target
> >> type [-Wdiscarded-qualifiers]
> >>     883 |    realfile =3D ovl_dir_open_realfile(file,&upperpath);
> >>         |                                     ^~~~
> >> fs/overlayfs/readdir.c:842:56: note: expected =E2=80=98struct file *=
=E2=80=99 but
> >> argument is of type =E2=80=98const struct file *=E2=80=99
> >>     842 | static struct file *ovl_dir_open_realfile(struct file *file,
> >>         |                                           ~~~~~~~~~~~~~^~~~
> >> -------------------------------------------------
> >>
> > Shouldn't be a problem to change ovl_dir_open_realfile()
> > to take a const struct file * argument I think.
> Hi Amir,
>
> Other than the compiler warning I tested your patches on our
> enviroment and didn't find any issue, so add:
> Reviewed-by: Xiao Yang <yangx.jy@.cn.fujisu.com>
>
> Thank you for sharing these patches again. :-)

Please post the fixed patches rebased on top of
git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-ne=
xt.

Please leave my signed-off-by and add your own as well.

Thanks,
Amir.
