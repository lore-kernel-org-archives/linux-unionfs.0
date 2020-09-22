Return-Path: <SRS0=2bMn=C7=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5901AC2D0E2
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Sep 2020 12:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113BD23A34
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Sep 2020 12:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rsVGjE0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIVMBl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 08:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgIVMBl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Sep 2020 08:01:41 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70102C061755;
        Tue, 22 Sep 2020 05:01:41 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id j2so19185382ioj.7;
        Tue, 22 Sep 2020 05:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=thN+8j8fzPRcGR/K/n7KMucCVe+4w8v81WWL2C+eee0=;
        b=rsVGjE0tEzc5C/NTe5WIIU72p4hdYywYNOgni3vtzPRQVLbk+RW/if18Zhh1ZxPVCq
         KHDE2+VSLf6g/3p7UM+TOI/zn9HAarDkIxArHAPgEG72GXXb8bH3VccJU/xsgBzNW+ho
         iGn6dofDLi55L9/lwXZ2iCtwWCvdHyd9QNdnxkApXiNsZJCWCJqfYwg4jTzozlJjDuaj
         8krGRhvd61FhCCygJ9Q2C7+8dE9gMUxRYLee9SfdGcjlBRYLCM8sjqaq7A81pWitEJQI
         AvAu3xpMX+J00vusiA1NmFezjBzGx0Uzwpar8+b/MGPa0w6SAJsUlY96Bl1VxbKxk1Ol
         m9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=thN+8j8fzPRcGR/K/n7KMucCVe+4w8v81WWL2C+eee0=;
        b=VuI/f/HWJWpt9JzM6B1N73pVdZ59GTwBtX/x2cuElRSeiLIUk3fsO6i4PgEiTjnyF4
         pw2KmXKpbwYunxBkd7UwtPo0t58BeXXUFfz4/jvecIRhdCU6CZmRVF7lXjzBF0mkio7S
         ZXEl9qb7U2zNdkr/z423jykrrFmz/QYNxN7P95ezxqdzqYGSUCDoz0ByBlTdJ/857TFc
         pUq958/Xnl974uu5tapjrbG4EVnEB/tDhmySmb109Y6tKJzq0Q+Aj295yUctbjoYhubC
         5eF7IL8IaC/Dm+0zQrEMZ8P9NSWSdFWlZl69AMflu1lciAphj9ANUgg2SqXL7tZr/ZDm
         I3gg==
X-Gm-Message-State: AOAM533hixYiDrDYuLeufsKWM3rL3PBhOFfXZ6RPw2HBsR9cI2JmiSQl
        aTepatHkhkYK94HzmIiFkwpYFgS96CUX4VJdxfQwFmY7KDg=
X-Google-Smtp-Source: ABdhPJxwUIF+YBi31uZ7a6gaPPe6crkKq4vWE9W+i/9tHvfgdpesx7B2CaG/91tyK2pMIn+I7/k6wHyjVN88jzMlSKs=
X-Received: by 2002:a05:6638:4:: with SMTP id z4mr3639214jao.123.1600776100669;
 Tue, 22 Sep 2020 05:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com>
 <CAOQ4uxitZDVjbvBnb95UHWD6CzaBeoJ8deqR6nbmgRRJ3P2=UA@mail.gmail.com>
 <5F686A74.4040002@cn.fujitsu.com> <CAOQ4uxhfUbFhecA9ShKUxyjS=LsMoyztXwWUJw-ZXm+Z0eJ6DQ@mail.gmail.com>
 <5F69B2A4.2050407@cn.fujitsu.com>
In-Reply-To: <5F69B2A4.2050407@cn.fujitsu.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 22 Sep 2020 15:01:29 +0300
Message-ID: <CAOQ4uxg-4xOSVxkLZrH_zrd9054z+SH_+YdcPnT3PVNYogJ3gw@mail.gmail.com>
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

On Tue, Sep 22, 2020 at 11:15 AM Xiao Yang <yangx.jy@cn.fujitsu.com> wrote:
>
> On 2020/9/21 17:09, Amir Goldstein wrote:
> > On Mon, Sep 21, 2020 at 11:55 AM Xiao Yang<yangx.jy@cn.fujitsu.com>  wr=
ote:
> >> On 2020/9/21 16:17, Amir Goldstein wrote:
> >>> On Mon, Sep 21, 2020 at 10:41 AM Xiao Yang<yangx.jy@cn.fujitsu.com>  =
 wrote:
> >>>> Factor out ovl_ioctl() and ovl_compat_ioctl() and take use of them f=
or
> >>>> directories.
> >>>>
> >>>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
> >>>> ---
> >>> This change is buggy. I had already posted it and self NACKed myself =
[1].
> >>>
> >>> You can find an hopefully non-buggy version of it on my ovl-shutdown =
[2] branch.
> >>>
> >>> As long as you are changing ovl_ioctl(), please also take the second
> >>> commit on that
> >>> branch to replace the open coded capability check with the
> >>> vfs_ioc_setflags_prepare()
> >>> generic helper.
> >> Hi Amir,
> >>
> >> Thanks a lot for your quick reply. :-)
> >> I will try to read and understand the metioned patches on your
> >> ovl-shutdown branch.
> > Please also verify my claim in the patch commit message, that the
> > the test result of xfstest generic/079 changes from "notrun" to "succes=
s".
> Hi Amir,
>
> With your patches, I have confirmed that generic/079 actually changed fro=
m
> "notrun" to "success".  Besides, one minor issue:
> Could we avoid the following compiler warning?
> -------------------------------------------------
> fs/overlayfs/readdir.c: In function =E2=80=98ovl_dir_real_file=E2=80=99:
> fs/overlayfs/readdir.c:883:37: warning: passing argument 1 of
> =E2=80=98ovl_dir_open_realfile=E2=80=99 discards =E2=80=98const=E2=80=99 =
qualifier from pointer target
> type [-Wdiscarded-qualifiers]
>    883 |    realfile =3D ovl_dir_open_realfile(file, &upperpath);
>        |                                     ^~~~
> fs/overlayfs/readdir.c:842:56: note: expected =E2=80=98struct file *=E2=
=80=99 but
> argument is of type =E2=80=98const struct file *=E2=80=99
>    842 | static struct file *ovl_dir_open_realfile(struct file *file,
>        |                                           ~~~~~~~~~~~~~^~~~
> -------------------------------------------------
>

Shouldn't be a problem to change ovl_dir_open_realfile()
to take a const struct file * argument I think.

Thanks,
Amir.
