Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB26CC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 14:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9347206E9
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 14:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BK4xevGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgGHOYB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 10:24:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729467AbgGHOYB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 10:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594218239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FGU/kAqQAW0e8QF1qHz+FbBrB/2yy3DysPhvK5i5zf4=;
        b=BK4xevGmmqRhYWLWF7O1eyAQeGRSz4bkACiHNg+dIYrxg9n3ufUESNd5uzvRrHM9Y/OVyo
        4wNp9NB6yPTlsdQ1Nxd8oLj7sPhYyLujucr3tDWsCRutMtFE2aKXU3XTn93rdz9sGtdTID
        lOX84bHQxgDzenXUyIvjfS63LDD0KiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-ieCwzc8qORaol2av4UM_8Q-1; Wed, 08 Jul 2020 10:23:58 -0400
X-MC-Unique: ieCwzc8qORaol2av4UM_8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01F8188C935;
        Wed,  8 Jul 2020 14:23:55 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-128.rdu2.redhat.com [10.10.115.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CCAB1C950;
        Wed,  8 Jul 2020 14:23:54 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 974E1223B92; Wed,  8 Jul 2020 10:23:53 -0400 (EDT)
Date:   Wed, 8 Jul 2020 10:23:53 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
Message-ID: <20200708142353.GA103536@redhat.com>
References: <106271350.sqX05tTuFB@fgdesktop>
 <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com>
 <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
 <20200707215309.GB48341@redhat.com>
 <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
 <CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com>
 <CAOQ4uxgaVD_DjU5DM+rXzkqpgVLWN-R+kj5ef2SBvvvCDL3d6w@mail.gmail.com>
 <CAJfpegur+DfoGA4e+R2okSmso59Kx0ArnkpJ03o9qM1KH5rLdg@mail.gmail.com>
 <CAOQ4uxiq7hkaew4LoFZkf4R73iH_pU7OHOriycLCnnywtA0O0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiq7hkaew4LoFZkf4R73iH_pU7OHOriycLCnnywtA0O0w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 08, 2020 at 11:50:29AM +0300, Amir Goldstein wrote:
> On Wed, Jul 8, 2020 at 11:37 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, Jul 8, 2020 at 10:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > >
> > > 1) is not problematic IMO and the simple patch I posted may be applied
> > > for fixing the reported issue, but it only solved the special case of null uuid.
> > > The problem still exists with re-creating lower on xfs/ext4, e.g. by
> > > rm -rf and unpacking image tar.
> >
> > How so?  st_ino may be reused but the fh is guaranteed to be unique.
> >
> 
> Doh! You are right. I was talking nonsense.
> The only problem would be with re-creating an xfs/ext4 lower image
> with the same uuid maybe because a basic image is cloned.
> 
> In any case, it's a corner of a corner of a corner.
> I will post the patch to fix null uuid.

It will also be good if we can bring some clarity to the documentation
for future references in section "Sharing and copying layers".

So if IIUC,

- sharing layers should work with all features of overlayfs.

- copying layers works only if index and nfs_export is not enabled. Even
  if index is not enabled, copying layers will change inode number
  reporting behavior (as origin verification will fail). We probably
  say something about this.

- Modifying/recreating lower layer only works when
  metacopy/index/nfs_export are not enabled at any point of time. This
  also will change inode number reporting behavior.

Is that a fair understanding? I am not sure how exactly inode number
reporting will change when lower layers are copied or recreated.

Thanks
Vivek

