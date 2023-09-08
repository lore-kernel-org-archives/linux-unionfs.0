Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7181EE57E1
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Sep 2023 07:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242527AbjIHHsD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 03:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242313AbjIHHsB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2023 03:48:01 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A4F1FC9
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Sep 2023 00:47:55 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id a1e0cc1a2514c-7a2785e34b6so667321241.1
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2023 00:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694159275; x=1694764075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3/i2pQQJd3+4L/Za1KJFuS+1DfpBuLmiWRbyZA6IQg=;
        b=pn/SKmw/IFTt/cQ/7Smgo+IUlsdtCp6BFIxCj0lci4GWiwUJwwJdADMjka0DxS4FXM
         2fcUBZulZInhQRwQJi0W0t0fPj4/HwMj/9GERcQpg4oiYLd+KV44OTUIRn+kVQh/juW7
         dJ+LMAoehVLKxpwCJKO2jutUw14KuePU+IPoDiN/7sTbLzidgJE35zwDZw5HnvMhY8Na
         fD+MIht58z1YoKbJczbYCQl4Wm5AgXnzjWOqKJBdSyxdpt7HZuvdSJ11dIb9TwVIwX0d
         Mr7SspYbifGldq3vpK/94LQlTdsC5rYQb9RsB8jf3DULb248BsxhOlsETXRN1o8L9FNw
         ktuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694159275; x=1694764075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3/i2pQQJd3+4L/Za1KJFuS+1DfpBuLmiWRbyZA6IQg=;
        b=OeLuO1+FavhE0E/OjxmSWccaJmwRiXBELwlkYH1YlOniN6NA76VUCGHJZFQXDCLoPi
         HAKu+TRoBQpTs5eu6Og2rqO6Q8oO7TbFngDXnUtQ3TeX3EwAkQjFAveDhH4dwxODDeX5
         tWQVCPA/zzU5/S+gGO7HT5Bj00NvNvBaMBIeYGbII7B8wxKSIpo4izeIuYMHLycmHyrK
         VrL5toK3RQGZ8wR3+gzhgksuRJqZTOvx0vHqbcTN161eBgwsUODCqr4hrIgAQiCvwzS0
         SQKDY+PGzkVmDenJ8Ivu2Sv6l1qoi+abL+W1Rxrpo7FvGD5Gf011e2bJdchNTIZ8J58x
         7Srw==
X-Gm-Message-State: AOJu0YzqIV1FSu9nHKcJkLP8u84IVuwKfOdZVMfkB8kLe+PaxCjGCc2v
        zGm+1X1kaU0/czmnGpmrEbqBvDS+t2srPoF13VA=
X-Google-Smtp-Source: AGHT+IF/6z90+NNVY+UMuYlpVIf3mc9dLd3xyH2Uxb8D1Pi4ul0XJgXutFKhc467YeMkTCEpQqjcJyRJ1vhPIms6aMY=
X-Received: by 2002:a67:f8c8:0:b0:44d:4385:1627 with SMTP id
 c8-20020a67f8c8000000b0044d43851627mr1724752vsp.14.1694159274946; Fri, 08 Sep
 2023 00:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com> <CAOQ4uxgsH2B68O91-Rx8_EXNkwUe26M1P3EKRDnS-0u=GepVZA@mail.gmail.com>
 <CAL7ro1Fm72xndy1C0zZbScPtgjGXucZ3rip0cO4VutSu0Jy4-A@mail.gmail.com>
In-Reply-To: <CAL7ro1Fm72xndy1C0zZbScPtgjGXucZ3rip0cO4VutSu0Jy4-A@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 8 Sep 2023 10:47:43 +0300
Message-ID: <CAOQ4uxigSZAGFh8jPfCupiHk0DN-4t65yYKaF3MmGdO+O7yMkA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Support nested overlayfs mounts
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 8, 2023 at 10:08=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
>
>
> On Thu, Sep 7, 2023 at 3:22=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>>
>> On Thu, Sep 7, 2023 at 11:44=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com> wrote:
>> >
>> > There are cases where you want to use an overlayfs mount as a lowerdir=
 for
>> > another overlayfs mount. For example, if the system rootfs is on overl=
ayfs due
>> > to composefs, or to make it volatile (via tmpfs), then you cannot curr=
ently store
>> > a lowerdir on the rootfs, becasue the inner overlayfs will eat all the=
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
>>
>> This test look good. Left minor comments in github.
>> Missing test for the perplexing "escaped xwhiteouts across layers" use c=
ase.
>
>
> It's kinda hidden, but the creation of $middir/mid actually does test thi=
s.
> The whiteouts xattr is set on $lowerdir/mid, and this is shadowed by the =
$middir/mid, so
> if that change is removed from the tree, then the "ls" in do_test_xwhiteo=
ut" breaks due to the readdir not seeing the xwhiteouts on the mid dir when=
 $lowerdir and $middir are merged.
>
> We could perhaps point it out more clearly though.
>
>> > Note that this series breaks the overlay/026 test which validates that
>> > writing overlay.* xattrs is not supported, but it now is. I'm not sure
>> > if we should fix this test to not fail, or if we should make this an
>> > opt-in mount feature.
>>
>> I think we don't need an opt-in mount option, but would like to know
>> what Miklos thinks?
>>
>> We can fix the test this way:
>>
>> setfattr trusted.overlayfsrz
>> verify success
>> getfattr trusted.overlayfsrz
>> verify success AND that xattr was not escaped
>>
>> setfattr trusted.overlay.fsz
>> verify failure OR that xattr was escaped
>> getfattr trusted.overlay.fsz
>> verify failure OR that xattr was escaped
>
>
> Yes, it's fixable in a new xfstest. My question is more about how much we=
 care about older xfstest versions showing a regression.

Don't worry about that - it happens quite often when tests are encoding
expectations that is not a SPEC and we change behavior.

Yes it can be a nuisance to testers, but testers should update to
recent xfstests
or at least check what changed in recent xfstests when they see a regressio=
n.

If there is an actual application that breaks because of the behavior chang=
e
it is a different story, but I doubt there is.

Thanks,
Amir.
