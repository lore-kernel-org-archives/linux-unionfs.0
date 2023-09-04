Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65219C71153
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 14:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjIDOIS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 10:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353101AbjIDOIL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 10:08:11 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D73E5B
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 07:07:55 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3a8614fe8c4so1053052b6e.1
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 07:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693836475; x=1694441275; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3g7zS4JHnyuJkHXUhuhXYmgn8ZD7xJfgljltSboPc/4=;
        b=bKRl/Fam9srTsZsSpN+VsudnZOvSrZYrkTwGmcLKv47Hk539wMTxKezEuM+jmIT6as
         1IAZbiU2KeN1y3siNT9i7JNJhzIc+zSEFpvgPqzCFfP0Ivybcz7Y+pVOPbOdpmu1LMhu
         5rd+5tmn4WAQ/crfNS7jiTE6/e5LFc5vukcDMFgZSLX1TurttTsGDcehOokpqaZit0RM
         ltFkCTo7LOLIKAC1ivCnZzPWsa2dlgcLwa4p3aCXHlDJ9aHbJU0NYoEL3oOGSOjClESz
         XB9j+KALSc6xIZAKEQ0T5kbPpDzsGl+5tgnDjdSb/yOZZQ604T2eOGD5Ci6A8AXT0Vbs
         SH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693836475; x=1694441275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3g7zS4JHnyuJkHXUhuhXYmgn8ZD7xJfgljltSboPc/4=;
        b=UjhXlAe299QyRKeNS/FzCqGywlD8fv6yznVMwZOpdHSWgHIVBckRmrV2I5FqxFYzfN
         Ufs3mvovN+6sztznlFn9K2o7M7B+IjfmdxXZWarJU6jgD0MmoCfGpJC7A+HoJjVdzAxd
         cQf3uJM0qM9DqANw3O7fZvHfxko91eWjWryfnoKM+SDNsxmIpdcejRVbcqUgzymMjEJs
         Z415ybPeJmkES8vJcfDk3h55Lw868aSFfjTVjS3y329sDRc6hQHrVG8PO7x5DT390wYh
         HX35O+tQlUtJhyXaqp1MrVdxPvYeOCtlRl5peaA7Jn1oBJUowgGVY2Gwbf7b3rgjazHU
         5UxQ==
X-Gm-Message-State: AOJu0YziL/o5M2GUNXERJ0z2mmLcmTjGvSV2JTx2ru6/IBHJQzSPhJDN
        Y7UJjC6QX6Jcupb7KTPtGEGH3UHock4ENoAH+QU=
X-Google-Smtp-Source: AGHT+IFePkF4qnThdtW8IZ295dvVpLJqVBUTNclSxq88NrUh8Wgm/oxlEgY8L1jRpk9nlXlSA8Cx0tj8JQz4MUQCakE=
X-Received: by 2002:a05:6808:13d2:b0:3a8:4e27:3af3 with SMTP id
 d18-20020a05680813d200b003a84e273af3mr13313729oiw.48.1693836474697; Mon, 04
 Sep 2023 07:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
 <CAOQ4uxj_gM1BBCUE6p=TfVketOZohLPZs3fbw0BLacQFKEsuGg@mail.gmail.com>
 <9a89150e-cd84-c541-8088-41c2dfe863ac@linux.alibaba.com> <fe799167-249b-8fe2-a6c8-b222ac9acaf0@linux.alibaba.com>
In-Reply-To: <fe799167-249b-8fe2-a6c8-b222ac9acaf0@linux.alibaba.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Sep 2023 17:07:43 +0300
Message-ID: <CAOQ4uxgAoxgjQV2R0CJr-9UpyMTwdbGMYKb+qApco1YjBzE2HA@mail.gmail.com>
Subject: Re: [potential issue, question] whiteout shows up in merged directory
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     Jingbo Xu <jefflexu@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Xiang Gao <xiang@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 4, 2023 at 4:27=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
>
>
> On 2023/9/4 20:49, Jingbo Xu wrote:
>
> ...
>
> >
> > Thanks for the reply and it's really helpful to me.
> >
> > I can understand in the normal use case, whiteout can not appear in
> > non-merged directory without origin xattr, except it's hand crafted.
> >
> > But indeed we suffer from this issue in the tarfs for erofs-utils we ar=
e
> > developing. As described previously, in tarfs mode erofs-utils can
> > convert each tar layer into one separate erofs image, and then merge
> > these erofs images into one merged erofs image in a overlayfs-like mode=
l.
> >
> > Suppose:
> >
> > layer 0 + layer 1   +        layer 2         -->  merged
> >         /foo/bar   /foo/bar (whiteout)
> >
> >
> > To speed the merging process, we may merge the two top-most layers
> > (layer 1 and layer 2) first, and then make layer0 merged into the final
> > merged image as:
> >
> >
> >
> >             layer 1   +        layer 2         -->  merged-intermediate
> >         /foo/bar   /foo/bar (whiteout)
> >
> > layer0 + merged-intermediate                -->  merged
>
>
> I could add some more background to this, assuming layer 0 is a
> baseos layer (e.g. almost all images use this layer); and layer 1 +
> layer 2 belongs to some specific workload images;
>
> since layer 1 + layer 2 are always used together, so we could merge
> layer 1 + layer 2 as a new merged layer to avoid extra overhead of
> too many overlay layer dirs (but to simplify, here we just illustrate
> layer 1 and layer 2, there could be layer 3, 4, ...), but layer 1 +
> layer 2 has no relationship with layer 0 in principle (in principle,
> merge tool doesn't need to know if layer 0 or any underlay layer
> exists).
>
> So if we merge layer 1 + layer 2 here first, and use layer0 together
> with the merged layer, it could generate such whiteout cases
> described before.
>
...
> >
> > Then there comes the problem: when merging layer1 and layer2, I need to
> > keep the whiteout in the intermediate merged image though the target of
> > the whiteout has showed up in underlying layer (/foo/bar in layer 1),
> > because I have no idea if "/foo/bar" exits in the following further
> > underlying layer (layer 0).  Reusing this logic, the whiteout is kept
> > there in the final merged image after merging layer0 and
> > merged-intermediate.
> >
> > Then if "/foo" is not a merged directory, the "/foo/bar" whiteout will
> > be exposed in the overlayfs unexpectedly.
> >
> > Currently we work around this in erofs-utils side.  Apart from setting
> > origin xattr on the parent directory of the whiteout, I'm not sure if
> > the above use case is reasonable enough to fix this in the kernel side.
> >
> Anyway, we could work around this in the merge tool, but I'm not
> sure if it's a design constaint of overlayfs.
>

Let me put it this way:
If there was an official offline tool to merge overlayfs layers
I would expect that tool to mark the offline merged directories
with an empty "trusted.overlayfs.origin", to be able to distinguish
them from pure non-merge directories.

I do not consider dealing with this in erofs-utils side a workaround
I consider it crafting layers in expected overlayfs format.

You should know that there are potential costs for marking a directory
as merged directory - ovl_iterate() implementation for merged dirs
that needs to filter out whiteouts is quite different than the
ovl_iterate_real() case -
The entire dirs needs to be read into cache before any response
could be returned. For very large dirs this may matter.

So you may want your tool to be able to clear the unneeded whiteouts
and unneeded origin xattr eventually.

OTOH, ovl_dir_read_impure() with xino enabled on layers
not from the same fs, has quite a similar impact.
Not sure if this configuration is relevant for your use case.

Thanks,
Amir.
