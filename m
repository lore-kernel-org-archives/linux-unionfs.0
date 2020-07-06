Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6F4C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 15:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 762FA20708
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 15:34:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/vs9eIt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgGFPeG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbgGFPeG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:34:06 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D635CC061755
        for <linux-unionfs@vger.kernel.org>; Mon,  6 Jul 2020 08:34:05 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k23so39726996iom.10
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2020 08:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fp81/+PRuKv3LLyrzjG7heXwuiPrb0Wy8HeUBHtbK1Y=;
        b=d/vs9eItop3IsRSiWSLYEwtddtzcwwVaJAIfuJ70AvNimNDcI8Tcr3cXuWjFzts4/R
         DFF7Vo6POtuVbXbjd4mIMd7iOaJlKUH09H8yeomFO55pXHmXRpO07lRGDHMY234wtJPH
         54dO6rDwaQaXEFMZufRE6pyT8yZ1RlmdqxU8fSB79vhaB5ph+Oa0zR6aihg+OUiv1kWI
         PCcSUztunTSPNoOOPZtRBCRfn5gXeOgu4GD4vucw0cKG39cqJRibfCzjFpgXqpdC2+kI
         QQe+OGhr53G+zGXvex2xVPlpoDf3+MiInpTY12bP5iGPNFIw4+PCHaIpvNJHK8Z2JkCL
         kWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fp81/+PRuKv3LLyrzjG7heXwuiPrb0Wy8HeUBHtbK1Y=;
        b=srtS3FfIl45jCF2PvW4N7wBzsobtKuJB3uGyEJvLntjbdyvvG3MEpLwQLbz2mhTvxW
         buHyh0j5xnBplERV3hyCExtzc6nCfWw3z9v5tjVxrI9TAFTgPFuVf8ss32yZxaDyrhru
         /zhV8K3wZaI2WFzz6jqEtiZR0RdccbmXbDVC6Ewf5/rN97ZOEQWHulhm8YH7dmyLMBed
         BPXYFBUS48PF7lpY8qZ14JUIFyymLL7CLobvm+IJh4aKUkQ5n6b4Y2oQWVNhu0/N85gk
         MQowrB3A2cZnavf1inPhlp1P6U2JswZCR/etJcJkRRq7pkG8YyFfm06Pf43a7LG60BcB
         jrIA==
X-Gm-Message-State: AOAM531CB7H0AOzYT1CHEascm+URyAjnzr7OZ1KXIV/dWDzx77L5Po6E
        btjyRhm7LYu1JQPDo0Z+zDyKTQV/q+04iycaHro=
X-Google-Smtp-Source: ABdhPJycQjiviYdGry5IdaNKa0eXCDYK+pKo1pmAaEtTCf38srGAJaLHHJHXsgsYGIqNFtD9ZWNUhyD18jdh1pZPB0w=
X-Received: by 2002:a05:6602:1225:: with SMTP id z5mr26162134iot.64.1594049645116;
 Mon, 06 Jul 2020 08:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop>
In-Reply-To: <106271350.sqX05tTuFB@fgdesktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 6 Jul 2020 18:33:54 +0300
Message-ID: <CAOQ4uxgGRyrQrLohcENRMakq8tKKdZLVLyTbTN2Ds2KRjW4W0g@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Fabian <godi.beat@gmx.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 6, 2020 at 6:14 PM Fabian <godi.beat@gmx.net> wrote:
>
> Hi Amir,
>
> thanks for your mail and the quick reply!
>
> Am Montag, 6. Juli 2020, 16:29:51 CEST schrieb Amir Goldstein:
> > > We are seeing problems using an read-writeable overlayfs (upper) on a
> > > readonly squashfs (lower). The squashfs gets an update from time to time
> > > while we keep the upper overlayfs.
> >
> > It gets updated while the overlay is offline (not mounted) correct?
>
> Yes. We boot into a recovery system outside the rootfs and its overlayfs,
> replace the lower squashfs, and then reboot into the new system.
>
> > > On replaced files we then see -ESTALE ("overlayfs: failed to get inode
> > > (-116)") messages if the lower squashfs was created _without_ using the
> > > "-no-exports" switch.
> > > The -ESTALE comes from ovl_get_inode() which in turn calls
> > > ovl_verify_inode() and returns on the line where the upperdentry inode
> > > gets compared
> > > ( if (upperdentry && ovl_inode_upper(inode) != d_inode(upperdentry)) ).
> > >
> > > A little debugging shows, that the upper files dentry name does not fit to
> > > the dentry name of the new lower dentry as it seems to look for the inode
> > > on the squashfs "export"-lookup-table which has changed as we replaced
> > > the lower fs.
> > >
> > > Building the lower squashfs with the "-no-exports"-mksquashfs option, so
> > > without the export-lookup-table, seems to work, but it might be no longer
> > > exportable using nfs (which is ok and we can keep with it).
> > >
> > > As we didn't find any other information regarding this behaviour or anyone
> > > who also had this problem before we just want to know if this is the
> > > right way to use the rw overlayfs on a (replaceable) ro squashfs
> > > filesystem.
> > >
> > > Is this a known issue? Is it really needed to disable the export feature
> > > when using overlayfs on a squashfs if we later need to replace squashfs
> > > during an update? Any hints we can have a look on if this should work and
> > > we might have done wrong during squashfs or overlayfs creation?
> >
> > This sounds like an unintentional outcome of:
> > 9df085f3c9a2 ovl: relax requirement for non null uuid of lower fs
> >
> > Which enabled nfs_export for overlay with lower squashfs.
> >
> > If you do not need to export overlayfs to NFS, then you can check if the
> > attached patch solves your problem.
>
> With the attached patch i'm now getting to a point where the overlayfs tries
> to handle the /run-directory (a symlink). There seems to be a -ESTALE at
> ovl_check_origin_fh() after the for-loop where it checks if origin was not
> found ( if (!origin) ). Maybe i should debug for more details here? Please let
> me know.
>

This is expected. Does it cause any problem?

The patch marks the lower squashfs as "bad_uuid", because:
        if (!ofs->config.index && uuid_is_null(uuid))
                return false;
...
        if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
                bad_uuid = true;
...
        ofs->fs[ofs->numfs].bad_uuid = bad_uuid;

That's ofs->fs[1].bad_uuid = bad_uuid;


Then in ovl_lookup() => ovl_check_origin() => ovl_check_origin_fh()
will return ESALE because of:
                if (ofs->layers[i].fsid &&
                    ofs->layers[i].fs->bad_uuid)
                        continue;

And ovl_check_origin() will return 0 to ovl_lookup().

When problems are you observing?

Maybe I did not understand the problem.

Thanks,
Amir.
