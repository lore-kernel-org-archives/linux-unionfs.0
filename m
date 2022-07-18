Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACAEC433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 10:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiGRKbu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbiGRKbt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 06:31:49 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F80A1D300
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 03:31:47 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m16so14591691edb.11
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 03:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MqsgmudFUTM/vtDuIe2QaQKJlIBj/+EUqYo8B8GUpLw=;
        b=QjRNRxJkpgPUfiDF9V/yyF6+te/ukyNFnvFSR+xeuCxO4yOT1FQfRtv0NcBf1as61E
         bGSgBEfaK70yFJqBKOliJikOkFexQli2wJadkju7HJhYjKMD+dr4/ymvPPPzVxk4ub7u
         eyt0hTe6vOGmsyibgHDqXX/K16RNKqIXVW3ZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MqsgmudFUTM/vtDuIe2QaQKJlIBj/+EUqYo8B8GUpLw=;
        b=ZPlsyhqkr7sa0U6lM2+pMPDL8cBWp9svA6sctRCU1BoIvCEonKLpeyLhG2IW3plrhA
         Xi2yA/RfTR2SurfLUo1jnsRRqqI9YIUifJP8jPUHE5e5OLbNsj4qPcPZ9sD3innZZauo
         cs1h46+k+29OoMOU43pScnAkkqjyw6sB32b9DaMn7SUnikLsbOhBP5fjlYjt4w5Idxoh
         bgZWZ+xv3OAT1THEpnQRP02TjNXHxXveQWqB5k4s1Jrs1X1oUcOsnlg4PjbOZX0bVJ5v
         yMnfsq5uG2zq/T5BSqJEShhVmNnEdOEdaaRIv3jrf21uzSS1R0PjDSpbI+xJ5ZAdHM/F
         kdCg==
X-Gm-Message-State: AJIora/4NY2NtEtn1BfwpPTDVuKjfir861SHZ4O3UmPMtzxDyWF6g2Lt
        u3DxrXqYHKcaIg/D+G7gRfg715e2Wr2v77XqXebKRw==
X-Google-Smtp-Source: AGRyM1uhZ6oxoe2rLR1BkIbwECjxU3GbWolLiReCf2sDeUtSiffOfrLxr+2ZAdfUb9K5i/+m3+l6b8hykFpAszw7F/Q=
X-Received: by 2002:a05:6402:5205:b0:43a:b520:c7de with SMTP id
 s5-20020a056402520500b0043ab520c7demr36393790edd.22.1658140306156; Mon, 18
 Jul 2022 03:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com> <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com>
In-Reply-To: <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 18 Jul 2022 12:31:35 +0200
Message-ID: <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Handle ENOSYS when fileattr support is missing in
 lower/upper fs
To:     =?UTF-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 18 Jul 2022 at 12:10, Christian Kohlsch=C3=BCtter
<christian@kohlschutter.com> wrote:
>
> > Am 18.07.2022 um 11:14 schrieb Miklos Szeredi <miklos@szeredi.hu>:
> >
> > On Mon, 4 Jul 2022 at 20:36, Christian Kohlsch=C3=BCtter
> > <christian@kohlschutter.com> wrote:
> >>
> >> overlayfs may fail to complete updates when a filesystem lacks
> >> fileattr/xattr syscall support and responds with an ENOSYS error code,
> >> resulting in an unexpected "Function not implemented" error.
> >
> > Issue seems to be with fuse: nothing should be returning ENOSYS to
> > userspace except the syscall lookup code itself.  ENOSYS means that
> > the syscall does not exist.
> >
> > Fuse uses ENOSYS in the protocol to indicate that the filesystem does
> > not support that operation, but that's not the value that the
> > filesystem should be returning to userspace.
> >
> > The getxattr/setxattr implementations already translate ENOSYS to
> > EOPNOTSUPP, but ioctl doesn't.
> >
> > The attached patch (untested) should do this.   Can you please give it =
a try?
> >
> > Thanks,
> > Miklos
> > <fuse-ioctl-translate-enosys.patch>
>
> Yes, that change basically has the same effect for the demo use case,.
>
> However: it will change (and potentially) break assumptions in user space=
. We should never break user space.
>
> Example: lsattr /test/lower
> Currently, fuse returns ENOSYS, e.g.
> > lsattr: reading ./lost+found: Function not implemented
> With your change, it would return ENOTTY
> > lsattr: reading ./lost+found: Not a tty

No, it would return success.

> I also tried the setup (without patches) on a very old 4.4.176 system, an=
d everything works fine. ovl introduced the regression, so it should also b=
e fixed there.
> It may affect other filing systems as well (I see some other fs also retu=
rn ENOSYS on occasion).
>
> It's safe to say that adding the ENOSYS to the ovl code is probably the b=
est move. Besides, you already have a workaround for ntfs-3g there as well.

Flawed arguments.  The change in overlayfs just made the preexisting
bug in fuse visible.  The bug should still be fixed in fuse.

Thanks,
Miklos
