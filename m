Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8548C433ED
	for <linux-unionfs@archiver.kernel.org>; Fri,  7 May 2021 06:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE62613D8
	for <linux-unionfs@archiver.kernel.org>; Fri,  7 May 2021 06:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhEGGLH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 7 May 2021 02:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhEGGLG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 May 2021 02:11:06 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFBBC061574
        for <linux-unionfs@vger.kernel.org>; Thu,  6 May 2021 23:10:06 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id j20so6779024ilo.10
        for <linux-unionfs@vger.kernel.org>; Thu, 06 May 2021 23:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jpzbHgWaI+FwNb6Rivz76+cOiw2IgZEVx8t1ybT/E/k=;
        b=cAUdLULs7PR8XlLzVvxZR0sJHHtf6ZZG4Zz3HVGfPvvTl9OF9eyC7rs93pJrQzzjjk
         VN0W4+zAFk9+XO7nBRCyqnUm0EmiBhvgk3dv/AsVTww1wiOQ5ZrPIg5ZoinKYH89HSiu
         1GB/l5OOt03o11MfzE2NVRtZwVIVS4p4JL3415c55bB6mrHdNp0Bs2ZywJaqJYR2I9oV
         G+/3lA2QP0rFKXMdI02koZWow6nEFb+ybUvbEzyhokoW82rjhagm44m1WIlahZmnhaju
         /cRD9gMf007GMiu3pC2kjGvMzFF+r7LhUjWoUMhFjqEbtBHO3JYNqkIyBJAxI9UPrFoZ
         b9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jpzbHgWaI+FwNb6Rivz76+cOiw2IgZEVx8t1ybT/E/k=;
        b=jwZbqWbRZPB7JOBpfeoKrwIiFxvD2d5mpeKPRosbr0uRRt/NZjhAa87itajkEbO+Ep
         N6aCNkuQB1TVa46hMQjV5W6HZmM8MBV1w2nSeCGBWHqsjuP2vI43CjLgAe5CZ5lLzCSY
         SGUO9qv03Za0pH/b2a7kpUaFXrmP6cw3dbkX/T6jkjf5awRiaDs10bBxKuF+EKxylnI9
         hd0k13JT/EOJ3Bp+VTehwxYeqyXX4CVX0jW3vthZG763T/+eNVqg25NjTXK0Kcc92oDn
         PF5K4r3FO0sOni+8xy1zU7VTsHaup2eTRvx8u7MCgttsojJpVOPXuSPw/CLGe9/s9MIq
         hsdA==
X-Gm-Message-State: AOAM532c5B/pKpBMyh1nkRuB+okSVNYlW8xNF8x8AJ0K4vLOGg+5lJVx
        rXJXWUkPKD6v09ADBKD/asRBkkLwcYLzj6nGl+c=
X-Google-Smtp-Source: ABdhPJxCwaG1ZKS0z9b1bATVuq6Qi4/jeKbGtI70UsID9upjDVnjl6K2gtKg7QKcYhyxDSt2u2fbHGyWraSvTYY0LDs=
X-Received: by 2002:a92:ce47:: with SMTP id a7mr8254100ilr.250.1620367805901;
 Thu, 06 May 2021 23:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210427102826.1189410-1-amir73il@gmail.com> <123ca2cd.45f7.1792236c0e9.Coremail.ouyangxuan10@163.com>
 <CAOQ4uxh7So5F3H_qY+nDXV_u+8A9K8B+275mTb1deedO_9Fg+Q@mail.gmail.com>
 <74a06ca.4928.17941146e4b.Coremail.ouyangxuan10@163.com> <CAOQ4uxhchH1XAHLB8z-s-3CSsAdwCCt9mqT9X4k40t-GvAL5Vw@mail.gmail.com>
 <39ca38d.1ec8.17944f144b3.Coremail.ouyangxuan10@163.com>
In-Reply-To: <39ca38d.1ec8.17944f144b3.Coremail.ouyangxuan10@163.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 7 May 2021 09:09:54 +0300
Message-ID: <CAOQ4uxj2GcLds=4cj4RLb9Eqh3oA=wAnL0B5rYOp2DGDJ+wh=A@mail.gmail.com>
Subject: Re: Re: Re: [PATCH] ovl: relax lookup error on mismatch origin ftype
To:     www <ouyangxuan10@163.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 7, 2021 at 6:51 AM www <ouyangxuan10@163.com> wrote:
>
> Hi Amir=EF=BC=8C
>
>
>
>
> At 2021-05-06 18:25:51, "Amir Goldstein" <amir73il@gmail.com> wrote:
> >On Thu, May 6, 2021 at 12:49 PM www <ouyangxuan10@163.com> wrote:
> >>
> >> Hi Amir,
> >>
> >>
> >>
> >> At 2021-05-01 00:16:28, "Amir Goldstein" <amir73il@gmail.com> wrote:
> >> >On Fri, Apr 30, 2021 at 12:59 PM www <ouyangxuan10@163.com> wrote:
> >> >>
> >> >> Hi Amir,
> >> >>
> >> >>
> >> >> Thank you very much for your help.  I have another question to clar=
ify.
> >> >>
> >> >> >> 3. If we upgrade overlayfs separately, we are not very good at v=
erifying that we have solved this problem, because the recurrence probabili=
ty of this problem is very low. So I want to ask, how can we quickly reprod=
uce this problem?
> >> >>
> >> >> >Re-creating a lower squashfs after files have been copied to upper=
 should
> >> >> >reproduce the problem quite often.
> >> >>
> >> >> Does the re-creating lower squashfs here mean that remount squashfs=
?
> >> >> I've tested dozens of times in the remount way, but I haven't found=
 this problem again?
> >> >> My test steps are:
> >> >> 1). umount lower squashfs;
> >> >> 2). modify the file in upper dir;
> >> >> 3). mount lower squanshfs;
> >> >> 4). restart service(it will re-parse the modified file)  or reboot =
the system and the problem didn't happen.
> >> >>
> >> >
> >> >No. That's not what I mean by re-creating lower fs.
> >> >What I mean is that overlayfs is the file is question is in the squas=
hfs
> >> >image and has been copied up.
> >> >
> >> >I don't know where the squashfs image you are using comes from
> >> >but I am guessing you have replaced it with a new squashfs image.
> >> >In the new squashfs image, files have different inode numbers.
> >> >
> >> >I reckon this behavior is common for OpenWRT where the system
> >> >image is being upgraded.
> >> >
> >> https://github.com/openbmc/openbmc/blob/master/meta-phosphor/recipes-p=
hosphor/initrdscripts/files/obmc-init.sh   (init file)
> >> ...
> >> line 376: mount  /run/image-rofs /run/initramfs/ro -t  squanshfs -o ro=
,loop          (line 358, set copy-base-filesystem-to-ram=3Dy)
> >> ...
> >> line 416: mkdir -p $upper/var/log      --- new add line, not in the fi=
le
> >> line 417: mount -t overlayfs -o lowerdir=3Drun/initramfs/ro,upperdir=
=3Drun/initramfs/rw/cow,workdir=3Drun/initramfs/rw/work  cow  /root
> >>  ...
> >> I would like to ask if the newly added line(line 416)  or "set set cop=
y-base-filesystem-to-ram=3Dy" causes this problem?(This folder is created a=
nd the value is set every time the system starts, but the probability of pr=
oblems is not high)
> >> There are no other changes.
> >>
> >>
> >
> >I don't know.
> >
> >I am not sure what wasn't clear in my answer.
> >
> >The lowerfs image, namely /run/image-rofs in your script can be download=
ed
> >from tftp or from the web. I have no idea what actually happens in your =
setup.
> >
> the /run/image-rofs image is copied form flash.
> line 359:  test ! -e /run/image-rofs && ! cp $rodev /run/image-rofs      =
  -- the $rodev is mtd4
>
>
> >Every time you run this init script this lower fs image may change, whil=
e the
> >upper f2fs rwfs does not change.
> >When that happens, it MAY cause the reported issue.
> >
> the /run/image-rofs is squashfs, readonly, cannot be modified.
> Do you mean that when I upgrade the new firmware, rofs (squashfs) has bee=
n updated (rofs has been modified), is it easy to have this problem?
>

YES!

Thanks,
Amir.
