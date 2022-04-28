Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6200CC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 10:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240554AbiD1KeK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 06:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiD1KeJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 06:34:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D60860DAE
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 03:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C693B82C91
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 10:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029AEC385A9;
        Thu, 28 Apr 2022 10:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651141852;
        bh=fECOgTMs/s0z9kXiusP5vXKjO2DAw/wVMq89CLn8FP8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gDlV5343hdlR5K4MNM1cqfFaflF4s0MUWsZOE8MCS1W4HFbhNxMhBhaSdNfHBITjP
         Vx/m4SVoPaf5IVP3pE0aFvcXpPZge7EefPYZ1LVG1vdcXI0VX2nsaPG2e84soGaK4w
         +420jw8Ly1kB/GMD4RF0Ty8IIaTkXrl2gemvvL36MB3O5vp7IM5Udt5gr5w1A05pMF
         0MtFpWJl84Ooxl5P4gfIxgzGrHtm4lVjGWH1BCnaeBYMWikneed29l3EHqysHKLVWU
         qc8r/eOEG25s5Wod2OW0Ex2XlppnmJqbZVVhFxHn7+D02yQILLNm0v6hocVfh7JE0D
         DGn1sUWk7pvjg==
Date:   Thu, 28 Apr 2022 12:30:46 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v5 13/19] ovl: handle idmappings for layer lookup
Message-ID: <20220428103046.kizonrkl7h2f2uvc@wittgenstein>
References: <20220407112157.1775081-1-brauner@kernel.org>
 <20220407112157.1775081-14-brauner@kernel.org>
 <CAJfpegtXfrgb3qQTvqu6mtunhFjC-FwXcRvqMY4h-ZcjWyhUFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegtXfrgb3qQTvqu6mtunhFjC-FwXcRvqMY4h-ZcjWyhUFg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 28, 2022 at 12:10:24PM +0200, Miklos Szeredi wrote:
> On Thu, 7 Apr 2022 at 13:23, Christian Brauner <brauner@kernel.org> wrote:
> >
> > Make the two places where lookup helpers can be called either on lower
> > or upper layers take the mount's idmapping into account. To this end we
> > pass down the mount in struct ovl_lookup_data. It can later also be used
> > to construct struct path for various other helpers. This is needed to
> > support idmapped base layers with overlay.
> >
> > Cc: <linux-unionfs@vger.kernel.org>
> > Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > ---
> > /* v2 */
> > unchanged
> >
> > /* v3 */
> > unchanged
> >
> > /* v4 */
> > - Vivek Goyal <vgoyal@redhat.com>:
> >   - s/ovl_upper_idmap()/ovl_upper_mnt_userns()/g
> >
> > /* v5 */
> > unchanged
> > ---
> >  fs/overlayfs/export.c  |  3 ++-
> >  fs/overlayfs/namei.c   | 14 ++++++++------
> >  fs/overlayfs/readdir.c | 10 +++++-----
> >  3 files changed, 15 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index ebde05c9cf62..5acf353d160b 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -391,7 +391,8 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
> >          * pointer because we hold no lock on the real dentry.
> >          */
> >         take_dentry_name_snapshot(&name, real);
> > -       this = lookup_one_len(name.name.name, connected, name.name.len);
> > +       this = lookup_one(mnt_user_ns(layer->mnt), name.name.name,
> > +                         connected, name.name.len);
> 
> This one is tricky.  It's doing a lookup on overlay, so messing with
> the underlying mnt_userns is definitely wrong.
> 
> Is the mnt_userns needed for permission checking?   Possibly in that
> case the permission checking needs to be skipped altogether, since
> it's doing an fh -> dentry lookup which should succeed regardless of
> caller's caps.

If capabilities are checked then it's always caller's user namespace
that is used (Ofc, exceptions being filesystem-wide operations where
capabilities in the filesystem's userns are needed but that doesn't
apply here.).

Nothing has changed with the introduction of the mnt_userns in the
area of capability checking. IOW, the mnt_userns isn't used for
capability checks as that would be a major permission model change
overall (It might have applications in the future ofc.).

The mnt_userns matters for permission checking only in so far as it is
used to map the k{g,u}ids according to the mount and so is relevant in
only that sense in inode_permission().

If this is doing a lookup on an overlay and the relevant mount isn't
supposed to be idmapped then the simple thing to do is to pass
&init_user_ns.

Could you explain what "lookup on overlay" means here, i.e. what mount
is relevant?
