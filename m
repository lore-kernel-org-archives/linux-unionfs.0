Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEB1C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7B04206DC
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 14:36:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLskIDHY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgFEOgX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 10:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbgFEOgX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 10:36:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CDDC08C5C2;
        Fri,  5 Jun 2020 07:36:22 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i1so8566988ils.11;
        Fri, 05 Jun 2020 07:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G47QOkSTVB2CGEq5akOxztUYpsM22GVc9ePPZnENcKc=;
        b=BLskIDHY2ruxJU0og2RF41WI0MQACkSXznyQYM+1bdsZv1Tv3Suy4A1MySWx0cKwiF
         5XR8NRdtrYRBHC7vpRstOPhEGcOdJvwmLS8iMUmrPpaDHkWEfofNY/Pq3Z2TFRt9G8HQ
         AUImRgPxTXtBzAvz0jqMPM5y/WssxkQ6RGJUNUTe+8queNoylPZEIDGIu7RbTHRZEhvP
         m/o0X0ygUL/8YlHbdjylIDkIvBGRVfFLTMgk5dPzXw+vbzTq8Y5zTyy6Mnhb9EMBbckZ
         z9d1fNe/zZc+rSs7se5uq/pFC4Bwm9VQOQR1gv53alvfSkbxad9+PGKw4XBvJ/NcjTpS
         ZPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G47QOkSTVB2CGEq5akOxztUYpsM22GVc9ePPZnENcKc=;
        b=INSCLCtn9PZwbmG4EuXp7eQNeogg7/p+mIUnxbINWUb79s+43Hx/a1/Pk1D5wo7S0h
         0IvJOGvOuaq+iCao7I709B9/xodrVMBusUtIT3Idl8j+TYRINyhZIzLEiw93gPx3kRsu
         fjJUCHjccaNgaWEfNW96KoORSEMcYP0ynHzOb4umOoSlFqIvB/PHoUZBEoIN99YAmShU
         trZPGzQJEUHP/X/ZcQyPKYa9RQmXOHj/Shqnh2DLDoJbrNsglG0ScvCKDEB6DU2Ak1eb
         kGzpt4W7dPSIi1wf2Xj4PUmpjtumgDCFNwGUHNTzaJpY+h1WVdLqCgsNHxkCZkB6sy6D
         ozjg==
X-Gm-Message-State: AOAM533Y/DMy2rZgVJmICo5amM57cs4X8OD4WvpX3clZEUc1pc7Ba857
        V0yzpQ+QUI/Gl1IbEzd19sz97pH9AS4kkq6ei0A=
X-Google-Smtp-Source: ABdhPJzNEtJLSMQRGEb/v33D9Vzn+3nTik8ixUG5AuW+pwqcm1qph0+wTNG+g1u3EFaTwutkebbqL2sLzrApUP529lI=
X-Received: by 2002:a92:c9ce:: with SMTP id k14mr8670482ilq.250.1591367782093;
 Fri, 05 Jun 2020 07:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
 <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
 <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
 <CAOQ4uxisdLt-0eT1R=V1ihagMoNfjiTrUdcdF2yDgD4O94Zjcw@mail.gmail.com>
 <fb79be2c-4fc8-5a9d-9b07-e0464fca9c3f@virtuozzo.com> <CAOQ4uxhhNx0VxJB=eLoPX+wt15tH3-KLjGuQem4h_R=0nfkAiA@mail.gmail.com>
 <20200605154438.408e5dc5522170c50463bbec@virtuozzo.com>
In-Reply-To: <20200605154438.408e5dc5522170c50463bbec@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Jun 2020 17:36:10 +0300
Message-ID: <CAOQ4uxhkaGJf=duHO-k7UxTKJmGjFpQnfnn8-tRdG2cQZaLq3A@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrey Vagin <avagin@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > While at it, you copy pasted the text:
> >           For more information, see Documentation/filesystems/overlayfs=
.txt
> > but there is no more information to be found.
>
> As far as I know documentation patches must be send to another mailing li=
st.
> Of course I have plan to add information to overlayfs documentation about=
 new feature.
>

Please send documentation patch together with the series
to this list. its fine to wait with that until the concept is approved thou=
gh.


> > > > And if this works for you, you don't have to export the layers ovl_=
fh in
> > > > /proc/mounts, you can export them in numerous other ways.
> > > > One way from the top of my head, getxattr on overlay root dir.
> > > > "trusted.overlay" xattr is anyway a reserved prefix, so "trusted.ov=
erlay.layers"
> > > > for example could work.
> > >
> > > Thanks xattr might be a good option, but still don't forget about (a)
> > > and (b), users like to know all information about mount from
> > > /proc/pid/mountinfo.
> > >
> >
> > Let's stick to your use cases requirements. If you have other use cases
> > for this functionality lay them out explicitly.
>
> Requirements is very simple, at "dump stage" we need to save all overlayf=
s mount options
> sufficient to fully reconstruct overlayfs mount state on "restore stage".=
 We already
> have proof of concept implementation of Docker overlayfs mounts when dock=
er is running in
> OpenVZ container. In this case we fully dump all tree of mounts and all m=
ount namespaces.
> CRIU mounts restore procedure at first reconstruct mount tree in special =
separate subtrees
> called "yards", then when all mounts is reconstructed we do "pivot_root" =
syscall. And
> with overlayfs it was a problem, because we mounted overlayfs with lowerd=
ir,workdir,upperdir
> paths with mount namespace "yard" path prefix, and after restore in mount=
 options user may see
> that lowerdir,workdir,upperdir paths were changed... It's a problem. Also=
 it makes second C/R
> procedure is impossible, because after first C/R lowerdir,workdir,upperdi=
r paths is invalidated
> after pivot_root.
>
> Example for Docker (after first C/R procedure):
>
> options lowerdir=3D/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/o=
verlay2/l/4BLZ4WH6GZIVKJE5QF62QUUKVZ:/var/lib/docker/overlay2/l/7FYRGAXT35J=
MKTXCHDNCQO3HKT,upperdir=3D/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/do=
cker/overlay2/30aa26fb5e5671fc0126f2fc0e84cc740ce6bf06ca6ad4ac877a3c60f5ace=
af1/diff,workdir=3D/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/ove=
rlay2/30aa26fb5e5671fc0126f2fc0e84cc740ce6bf06ca6ad4ac877a3c60f5aceaf1/work
>

That reminds me.
I've read somewhere that thoses symlinks l/4BLZ4WH6GZIVKJE5QF62QUUKVZ
are meant to shorten the mount option string, because the mount
options are limited by
page size and with many lower layers limitation can reach.

That is one of the reasons that new mount API was created for (i.e. fsconfi=
g()).
I wonder if /proc/mounts also has a similar limitation on options size.
I also wonder why docker doesn't chdir into /var/lib/docker/overlay2/
before mounting overlay and use relative paths, though that would have
been worse for CRIU.

So at least for the docker use case CRIU knows very well where the
underlying filesytem is mounted (/var/lib/docker/overlay2/ or above).
So if you got any API from overlayfs something like:
getxattr("/var/lib/docker/overlay2/XYZ/merged",
"trusted.overlay.layers.0.fh",..)
which reads the ovl_fh encoding of layer 0 (upper) rootdir, CRIU
can verify that uuid matches the filesystem mounted at /var/vol/docker/over=
lay2/
and then call open_by_handle_at() to open fd and resolve it to a path
under /var/vol/docker/overlay2.

I don't know if that provides what CRIU needs, but it would be no more
than a few lines of code in overlayfs:

if (i < ofs->numlayer)
    fh =3D ovl_encode_real_fh(ofs->layers[i].mnt->mnt_root, ...

Thanks,
Amir.
