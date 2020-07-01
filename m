Return-Path: <SRS0=Dknc=AM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F764C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 20:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A2420760
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 20:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ds44X01k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgGAUAX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 16:00:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53371 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726746AbgGAUAX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Jul 2020 16:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593633622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HaSN7maDvb8jdI1GXsKImUWrsQGf15aVjwQvBsCKuGA=;
        b=Ds44X01k8OeM1NsSnMcFSYXxOKn5Pk5jC2mBHUnntuSmChsrzG1yuISyJ3dRHCv45jlVW9
        ojdhM2ZRIaJkUEUaUwipPVZr021MQ2i6472a54I9MTGjJ0r8/nEmy32twonOlW1ZbJpDgW
        wet1CqsI0/ZUbvYKToVtGX7RrUPdX6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-ICSGCVrLNP6dWj_L_m9qNA-1; Wed, 01 Jul 2020 16:00:17 -0400
X-MC-Unique: ICSGCVrLNP6dWj_L_m9qNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A482E835B47;
        Wed,  1 Jul 2020 20:00:16 +0000 (UTC)
Received: from horse.redhat.com (ovpn-120-30.rdu2.redhat.com [10.10.120.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9558973FC3;
        Wed,  1 Jul 2020 20:00:13 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C83E5220A35; Wed,  1 Jul 2020 16:00:12 -0400 (EDT)
Date:   Wed, 1 Jul 2020 16:00:12 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, pmatilai@redhat.com
Subject: Re: [RFC PATCH v2] overlayfs: Provide mount options sync=off/fs to
 skip sync
Message-ID: <20200701200012.GE369085@redhat.com>
References: <20200701175716.GA384828@redhat.com>
 <CAOQ4uxisFOkQF8eq5ysZYtdfd_Z26r5MHsdr+ozwz4ry+WuUEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxisFOkQF8eq5ysZYtdfd_Z26r5MHsdr+ozwz4ry+WuUEA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 01, 2020 at 10:08:28PM +0300, Amir Goldstein wrote:
[..]
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 6918b98faeb6..970319ca1623 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -858,11 +858,15 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
> >         struct ovl_dir_file *od = file->private_data;
> >         struct dentry *dentry = file->f_path.dentry;
> >         struct file *realfile = od->realfile;
> > +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
> >
> >         /* Nothing to sync for lower */
> >         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
> >                 return 0;
> >
> > +       if (ofs->config.nosync || ofs->config.syncfs)
> > +               return 0;
> > +
> 
> Generally looks good, but those test conditions are quite weird IMO.
> I would go for either enum or flags, but not up to me to decide.
> But at the very least use inline helpers ovl_should_fsync(),
> ovl_should_syncfs(), because if we want to add new sync modes or
> whatever going over all those conditions and
> changing them would be sub-optimal.

Ok, I will add inline helpers.

I am not sure, what will I gain by switching to using enums or flags.
It will be just different style to keep same information.

Thanks
Vivek

