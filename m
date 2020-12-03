Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D32C0007A
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEB1208A9
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbgLCSdV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731615AbgLCSdV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Dec 2020 13:33:21 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A32C061A4E
        for <linux-unionfs@vger.kernel.org>; Thu,  3 Dec 2020 10:32:40 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id c7so3164858edv.6
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Dec 2020 10:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ohoEzfcF7t7OuVR/6T6jBWizgGSQNZlxu+KN4Eb7Bo4=;
        b=iFpZ1iQ84HtGiUOem9kP7Hkp8tvZ+NIb1R/De69mFF3u3F2/wRcF2awN64Jtp5txNW
         3HkWqef8oNH0iaUazjgdovP84zXNjbfmnvsTpH19PeaFbwq6UU4h4G0CHEDoZBTERV28
         igkvAYnsOBQeF9n6H+aDMD8NGUi65n8BuqnLo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ohoEzfcF7t7OuVR/6T6jBWizgGSQNZlxu+KN4Eb7Bo4=;
        b=eGeHCouWhdMvuSVfrkIrHlpzL2fukEf1RvzjQH9lwIsqob/CvM1mVRhYOenHo2+Rrv
         F52rceGJMBV7gUT5aIk3GOCx85LP2hsfzP8n0ZCvI9TmEPWi0zg/tJM7H7T3xDZ5w4LZ
         Nwopkh+egpeme04rCXlFLSMYqss9/AiPWfs2zkAMDxK1eWpdvOCElR3VNbqcdP3NOssG
         9lJ1rJutj2qBodVdmT85uO+uowxBcuB+e4xRm91rjoAuk5iebZ/7BIRLvlZLIedeYCxt
         SvudqaexULik2BNjsKZtoHtqhDzicPbSoPVwNwh1fB3XK9E+V38abz0ZZvH0BBD89AgD
         fpCA==
X-Gm-Message-State: AOAM532xWR+ze3lTMmGPTuQbB9jh4av5p/Uhqo8ej/wcpEcIhV9V/dp7
        zBI2cueJKar4NTXH0NI/kd3GtmNm98jN9bYxXOUppw==
X-Google-Smtp-Source: ABdhPJymIYbriT8qbNZ+9TIRlb/6epKDWS7W+tD7pMSLnGgNAhdP3Bgt/nreV8WnwqqUcfNhUVP6nH7NDXM0eJJgGYw=
X-Received: by 2002:aa7:d906:: with SMTP id a6mr4149283edr.121.1607020359515;
 Thu, 03 Dec 2020 10:32:39 -0800 (PST)
MIME-Version: 1.0
References: <20201130030039.596801-1-sargun@sargun.me> <CAMp4zn-c6gOPTPBqqkPoQi3NVeZ0yW-WfVPFzpDiazj8PeUgBw@mail.gmail.com>
 <CAOQ4uxhU=eWAfTn8DJ7x4NZ2PO9Q9V7Ohpj9aTasXg3KcfFpMA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhU=eWAfTn8DJ7x4NZ2PO9Q9V7Ohpj9aTasXg3KcfFpMA@mail.gmail.com>
From:   Sargun Dhillon <sargun@sargun.me>
Date:   Thu, 3 Dec 2020 10:32:03 -0800
Message-ID: <CAMp4zn9sdpk1A1hYpDjS_774UscYZ1sztCsLdfshs=pXEYf0NQ@mail.gmail.com>
Subject: Re: [PATCH] overlay: Plumb through flush method
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Dec 3, 2020 at 2:32 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Dec 3, 2020 at 12:16 PM Sargun Dhillon <sargun@sargun.me> wrote:
> >
> > On Sun, Nov 29, 2020 at 7:00 PM Sargun Dhillon <sargun@sargun.me> wrote:
> > >
> > > Filesystems can implement their own flush method that release
> > > resources, or manipulate caches. Currently if one of these
> > > filesystems is used with overlayfs, the flush method is not called.
> > >
> > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: linux-unionfs@vger.kernel.org
> > > Cc: Miklos Szeredi <miklos@szeredi.hu>
> > > Cc: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/overlayfs/file.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > > index efccb7c1f9bc..802259f33c28 100644
> > > --- a/fs/overlayfs/file.c
> > > +++ b/fs/overlayfs/file.c
> > > @@ -787,6 +787,16 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> > >                             remap_flags, op);
> > >  }
> > >
> > > +static int ovl_flush(struct file *file, fl_owner_t id)
> > > +{
> > > +       struct file *realfile = file->private_data;
> > > +
> > > +       if (realfile->f_op->flush)
> > > +               return realfile->f_op->flush(realfile, id);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  const struct file_operations ovl_file_operations = {
> > >         .open           = ovl_open,
> > >         .release        = ovl_release,
> > > @@ -798,6 +808,7 @@ const struct file_operations ovl_file_operations = {
> > >         .fallocate      = ovl_fallocate,
> > >         .fadvise        = ovl_fadvise,
> > >         .unlocked_ioctl = ovl_ioctl,
> > > +       .flush          = ovl_flush,
> > >  #ifdef CONFIG_COMPAT
> > >         .compat_ioctl   = ovl_compat_ioctl,
> > >  #endif
> > > --
> > > 2.25.1
> > >
> >
> > Amir, Miklos,
> > Is this acceptable? I discovered this being a problem when we had the discussion
> > of whether the volatile fs should return an error on close on dirty files.
>
> Yes, looks ok.
> Maybe we want to check if the realfile is upper although
> maybe flush can release resources also on read only fs?
>
> >
> > It seems like it would be useful if anyone uses NFS, or CIFS as an upperdir.
>
> They are not supported as upperdir. only FUSE is.
>
> Thanks,
> Amir.

VFS does it on read-only files / mounts, so we should probably do the
same thing.
