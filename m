Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC3DC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 17:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6B5206B6
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 17:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZff8z4K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgGFROY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 13:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgGFROY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 13:14:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AD0C061755
        for <linux-unionfs@vger.kernel.org>; Mon,  6 Jul 2020 10:14:23 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id y2so40161848ioy.3
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2020 10:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nkm6QdJhTbp4idx8JKOInaSMiP2xMo6Lla4D4BGVZ+U=;
        b=fZff8z4KMGDJkMknI3/JezYWvFS715ttMlOLD6B/rrknfoP8ZkcYcr6tLODjo/YXWE
         fQnF2pBy292tZ5wFU9JmSaW6TLH5xiNeNs5Eybh5jaVTzs/Acw5qS7Lxm7Qj72D7kpHs
         oTXnhuYTmdWR72h/ZyecJ/O0xBH3D40hp51WrNOIz3kD0XQ1BVFlTQUvqFrPlVfVbIFL
         IrUASxao0BVS7rtkIGibpVHhUZOyxNghPhdlylHH23IqfxJaYQdrt9tYJpWA0tMwBjwe
         +WafYm2jrlsjdWZMKc5yTfKB+RbG0dFR1rebdryR4Por8/RC92bih/vpBmFw4QmFpeto
         SxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nkm6QdJhTbp4idx8JKOInaSMiP2xMo6Lla4D4BGVZ+U=;
        b=CcJVRD+CSdd81+Ppz54ovz2lwiZtUuMjhPGInp15p1oWrMjZBaL11hilZD0hnGW1Ni
         u7vMSpCiKw8B9LZmA3RuBmTd7hcaMy4eHKli6/4mR3oa2BavED3ZQc4wXxbP9YDIwe/m
         68OdY61rWupx8CdXelOjjuDyNMP2g7fbKaJgjWBa2zYU/a0H9Tko7SAAIMmoMAlQAi0Y
         WnXULUR2wB80VQGIjMk6n7yWCh6/Vbqol3PQzQMPL0lb4KhFSSEYRcEP6H6Cc83hyZ7P
         3hP5kayXeD2zC1rsSkVuRNkBBr+U8wIu3Ts3wTgbG99GZUFTQo/B+TKtILVWAKRNa29B
         WTwQ==
X-Gm-Message-State: AOAM532WwodzjvxVe48cgWoKRKGQX22xyT5w94X+tkG/+GYEMP3N+UWT
        Jeqzqp5pPcAtAUxwhZzk5lDDyHO17+Iv0K3n7TPk7A==
X-Google-Smtp-Source: ABdhPJytJ+X8RiJZ0HLWrB8kjaKpbLzjFtk700OoQ3Us2q1ykgERMsqkmWkB7ApwJThh5LpT2j2hHeb+o7bxN07fS5o=
X-Received: by 2002:a05:6602:14d0:: with SMTP id b16mr26166745iow.5.1594055663145;
 Mon, 06 Jul 2020 10:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <106271350.sqX05tTuFB@fgdesktop>
 <CAOQ4uxgGRyrQrLohcENRMakq8tKKdZLVLyTbTN2Ds2KRjW4W0g@mail.gmail.com> <2480538.KX4unNvOOS@fgdesktop>
In-Reply-To: <2480538.KX4unNvOOS@fgdesktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 6 Jul 2020 20:14:11 +0300
Message-ID: <CAOQ4uxjsfSvTEsy7ikRAco=qJbsAoFPUDr8AcbqFmOndVz-8NQ@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Fabian <godi.beat@gmx.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 6, 2020 at 7:10 PM Fabian <godi.beat@gmx.net> wrote:
>
> Hi Amir,
>
> Am Montag, 6. Juli 2020, 17:33:54 CEST schrieb Amir Goldstein:
> > On Mon, Jul 6, 2020 at 6:14 PM Fabian <godi.beat@gmx.net> wrote:
> > > Hi Amir,
> > >
> > > thanks for your mail and the quick reply!
> > >
> > > Am Montag, 6. Juli 2020, 16:29:51 CEST schrieb Amir Goldstein:
> > > > > We are seeing problems using an read-writeable overlayfs (upper) on a
> > > > > readonly squashfs (lower). The squashfs gets an update from time to
> > > > > time
> > > > > while we keep the upper overlayfs.
> > > >
> > > > It gets updated while the overlay is offline (not mounted) correct?
> > >
> > > Yes. We boot into a recovery system outside the rootfs and its overlayfs,
> > > replace the lower squashfs, and then reboot into the new system.
> > >
> > > > > On replaced files we then see -ESTALE ("overlayfs: failed to get inode
> > > > > (-116)") messages if the lower squashfs was created _without_ using
> > > > > the
> > > > > "-no-exports" switch.
> > > > > The -ESTALE comes from ovl_get_inode() which in turn calls
> > > > > ovl_verify_inode() and returns on the line where the upperdentry inode
> > > > > gets compared
> > > > > ( if (upperdentry && ovl_inode_upper(inode) != d_inode(upperdentry))
> > > > > ).
> > > > >
> > > > > A little debugging shows, that the upper files dentry name does not
> > > > > fit to
> > > > > the dentry name of the new lower dentry as it seems to look for the
> > > > > inode
> > > > > on the squashfs "export"-lookup-table which has changed as we replaced
> > > > > the lower fs.
> > > > >
> > > > > Building the lower squashfs with the "-no-exports"-mksquashfs option,
> > > > > so
> > > > > without the export-lookup-table, seems to work, but it might be no
> > > > > longer
> > > > > exportable using nfs (which is ok and we can keep with it).
> > > > >
> > > > > As we didn't find any other information regarding this behaviour or
> > > > > anyone
> > > > > who also had this problem before we just want to know if this is the
> > > > > right way to use the rw overlayfs on a (replaceable) ro squashfs
> > > > > filesystem.
> > > > >
> > > > > Is this a known issue? Is it really needed to disable the export
> > > > > feature
> > > > > when using overlayfs on a squashfs if we later need to replace
> > > > > squashfs
> > > > > during an update? Any hints we can have a look on if this should work
> > > > > and
> > > > > we might have done wrong during squashfs or overlayfs creation?
> > > >
> > > > This sounds like an unintentional outcome of:
> > > > 9df085f3c9a2 ovl: relax requirement for non null uuid of lower fs
> > > >
> > > > Which enabled nfs_export for overlay with lower squashfs.
> > > >
> > > > If you do not need to export overlayfs to NFS, then you can check if the
> > > > attached patch solves your problem.
> > >
> > > With the attached patch i'm now getting to a point where the overlayfs
> > > tries to handle the /run-directory (a symlink). There seems to be a
> > > -ESTALE at ovl_check_origin_fh() after the for-loop where it checks if
> > > origin was not found ( if (!origin) ). Maybe i should debug for more
> > > details here? Please let me know.
> >
> > This is expected. Does it cause any problem?
> >
> > The patch marks the lower squashfs as "bad_uuid", because:
> >         if (!ofs->config.index && uuid_is_null(uuid))
> >                 return false;
> > ...
> >         if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
> >                 bad_uuid = true;
> > ...
> >         ofs->fs[ofs->numfs].bad_uuid = bad_uuid;
> >
> > That's ofs->fs[1].bad_uuid = bad_uuid;
> >
> >
> > Then in ovl_lookup() => ovl_check_origin() => ovl_check_origin_fh()
> > will return ESALE because of:
> >                 if (ofs->layers[i].fsid &&
> >                     ofs->layers[i].fs->bad_uuid)
> >                         continue;
> >
> > And ovl_check_origin() will return 0 to ovl_lookup().
>
> I'm sorry. You are totaly right! RootFS now completely comes up - just missed
> the console start in our latest inittab - so thought something still hangs.
> The ESTALE was printed for me because i debugged the whole ESTALE positions in
> the overlayfs code while studying the first problem. Time to remove my debug
> code...
>
> We will now continue with update tests. If we see something else i will let
> you know.
>
>

OK. please report back when done testing so I can add your tested-by

Thanks,
Amir.
