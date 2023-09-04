Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1FBC71153
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 15:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbjIDPEH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 11:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjIDPEG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 11:04:06 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B201A5
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 08:04:03 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-3a76d882052so1141867b6e.0
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693839842; x=1694444642; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59rHnvCwkGvp+C2ioyaihcU5hO+0rqS+8uBHQjvgafw=;
        b=VtroQWkJlNOcsbASEoxAmzBUVHQ7LO4EbAyVwBbN15sg7uJy8BLthhTiaqCRF5C8Qo
         wyh1uc2bWcluQ4Ehrb8jIWhR4/hNoJcGBvs+NWiUuYv2lLq7OYFi+0Anm4EuKuS76Nwx
         LqJgcKjp4yl1H0RRuX71O2tS2OE7DnIo8qDd1lTjTDuVI/3iQXUQwmLTDNJ6ow+MK09q
         EjL0zti850Xx7SxOR3c6KOf1X6s0JOgQhIj9YGdR5kx5+qTDWn3w8QGWuVxygxwrtetI
         Xzp6Uov3T31HbQDOQiI4uHOM8oGu6FEFf1hrMXNGII8Hp63FfNP/RyzTB651X94/urYs
         we6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693839842; x=1694444642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=59rHnvCwkGvp+C2ioyaihcU5hO+0rqS+8uBHQjvgafw=;
        b=BrpaML+x2DqJe8p5jFw60MmlE+ufPCuUcI+3l5/7CQmJHmO49qDv3CH1X6QCsUJZEb
         VdsF66NP52XyU4ePk50/LiSU3gAOGpUeBIYqxE8A/nhGxtblrZl7f7RWcq4V4q3bHTTG
         BVe4WtTCaOFv1mtvw5L3E8yogfF7nnyZz8Y3AO4lgdgHPEt/SFBkKptRN/R3bVRJFQff
         x+BbpHNB5H9HLcRARHaJhHY7NZVBNFvdh0fs2bCeaGb8yEl8QMxdHDQL6L28FP2vZTW8
         CiDrs1NoYtIepun8/mfsM3oGH2MYmg/ymF1MB0/KnVkkrBj1gc/YQkQmphM9+BF7x9RG
         OCDw==
X-Gm-Message-State: AOJu0YzLsqzNY1r1bhHTMQGQl919AfTX1SHDZ1ou4Y/AHYatj7pxzQWG
        HF+97hBa+nR4zbP0pzRBwrpCvN4/cPpxHjx18ns=
X-Google-Smtp-Source: AGHT+IHqUCRs3MHBsV+mLJMPdjl/bJGr0ZNTQpWUEzJXOLu68iIzpjURUi9Qr5IyYNJtZ6Y27DL07UqMlhC0TPZF3KQ=
X-Received: by 2002:a05:6808:d52:b0:3a7:49f1:1d7d with SMTP id
 w18-20020a0568080d5200b003a749f11d7dmr12241921oik.41.1693839842498; Mon, 04
 Sep 2023 08:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
 <CAOQ4uxj_gM1BBCUE6p=TfVketOZohLPZs3fbw0BLacQFKEsuGg@mail.gmail.com>
 <9a89150e-cd84-c541-8088-41c2dfe863ac@linux.alibaba.com> <fe799167-249b-8fe2-a6c8-b222ac9acaf0@linux.alibaba.com>
 <CAOQ4uxgAoxgjQV2R0CJr-9UpyMTwdbGMYKb+qApco1YjBzE2HA@mail.gmail.com> <6a43ee5c-cc25-ff9f-1198-7c2b445d3775@linux.alibaba.com>
In-Reply-To: <6a43ee5c-cc25-ff9f-1198-7c2b445d3775@linux.alibaba.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Sep 2023 18:03:51 +0300
Message-ID: <CAOQ4uxgiBNcD-vBi3OLF5Nc8gHYS-Hm1=yA4+At=nRUk18A9ng@mail.gmail.com>
Subject: Re: [potential issue, question] whiteout shows up in merged directory
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     Jingbo Xu <jefflexu@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Xiang Gao <xiang@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>, kmxz <kxzkxz7139@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 4, 2023 at 5:38=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
> Hi Amir,
>
> On 2023/9/4 22:07, Amir Goldstein wrote:
> > On Mon, Sep 4, 2023 at 4:27=E2=80=AFPM Gao Xiang <hsiangkao@linux.aliba=
ba.com> wrote:
> >>
> >>
> >>
> >> On 2023/9/4 20:49, Jingbo Xu wrote:
> >>
> >> ...
> >>
> >>>
> >>> Thanks for the reply and it's really helpful to me.
> >>>
> >>> I can understand in the normal use case, whiteout can not appear in
> >>> non-merged directory without origin xattr, except it's hand crafted.
> >>>
> >>> But indeed we suffer from this issue in the tarfs for erofs-utils we =
are
> >>> developing. As described previously, in tarfs mode erofs-utils can
> >>> convert each tar layer into one separate erofs image, and then merge
> >>> these erofs images into one merged erofs image in a overlayfs-like mo=
del.
> >>>
> >>> Suppose:
> >>>
> >>> layer 0 + layer 1   +        layer 2         -->  merged
> >>>          /foo/bar   /foo/bar (whiteout)
> >>>
> >>>
> >>> To speed the merging process, we may merge the two top-most layers
> >>> (layer 1 and layer 2) first, and then make layer0 merged into the fin=
al
> >>> merged image as:
> >>>
> >>>
> >>>
> >>>              layer 1   +        layer 2         -->  merged-intermedi=
ate
> >>>          /foo/bar   /foo/bar (whiteout)
> >>>
> >>> layer0 + merged-intermediate                -->  merged
> >>
> >>
> >> I could add some more background to this, assuming layer 0 is a
> >> baseos layer (e.g. almost all images use this layer); and layer 1 +
> >> layer 2 belongs to some specific workload images;
> >>
> >> since layer 1 + layer 2 are always used together, so we could merge
> >> layer 1 + layer 2 as a new merged layer to avoid extra overhead of
> >> too many overlay layer dirs (but to simplify, here we just illustrate
> >> layer 1 and layer 2, there could be layer 3, 4, ...), but layer 1 +
> >> layer 2 has no relationship with layer 0 in principle (in principle,
> >> merge tool doesn't need to know if layer 0 or any underlay layer
> >> exists).
> >>
> >> So if we merge layer 1 + layer 2 here first, and use layer0 together
> >> with the merged layer, it could generate such whiteout cases
> >> described before.
> >>
> > ...
> >>>
> >>> Then there comes the problem: when merging layer1 and layer2, I need =
to
> >>> keep the whiteout in the intermediate merged image though the target =
of
> >>> the whiteout has showed up in underlying layer (/foo/bar in layer 1),
> >>> because I have no idea if "/foo/bar" exits in the following further
> >>> underlying layer (layer 0).  Reusing this logic, the whiteout is kept
> >>> there in the final merged image after merging layer0 and
> >>> merged-intermediate.
> >>>
> >>> Then if "/foo" is not a merged directory, the "/foo/bar" whiteout wil=
l
> >>> be exposed in the overlayfs unexpectedly.
> >>>
> >>> Currently we work around this in erofs-utils side.  Apart from settin=
g
> >>> origin xattr on the parent directory of the whiteout, I'm not sure if
> >>> the above use case is reasonable enough to fix this in the kernel sid=
e.
> >>>
> >> Anyway, we could work around this in the merge tool, but I'm not
> >> sure if it's a design constaint of overlayfs.
> >>
> >
> > Let me put it this way:
> > If there was an official offline tool to merge overlayfs layers
> > I would expect that tool to mark the offline merged directories
> > with an empty "trusted.overlayfs.origin", to be able to distinguish
> > them from pure non-merge directories.
> >
> > I do not consider dealing with this in erofs-utils side a workaround
> > I consider it crafting layers in expected overlayfs format.
>
> Thanks for the hints.
>
> Ok, marking impure makes sense as long as it's properly described.
>
> Just tried to describe the background since the question I think
> is not quite erofs-utils specific, btw, if there could be some
> reference official offline tool, that would be great!
>

There is this tool from kmxz that supports offline merge:
https://github.com/kmxz/overlayfs-tools
but it is not in any way "official".

I have contributed redirect and metacopy support in 2020
and there hasn't been much traffic since.
This tool does not deal with origin and impure xattrs.

Thanks,
Amir.
