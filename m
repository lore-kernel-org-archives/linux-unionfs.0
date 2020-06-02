Return-Path: <SRS0=S/H/=7P=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AADC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 15:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C49720674
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 15:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4q9hBfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFBP6F (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 11:58:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48921 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726112AbgFBP6F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jun 2020 11:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591113483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZJnTM112WqNC7quy4l/xSdTlc9par4zX+nxZb4g2dVY=;
        b=X4q9hBfMzbZfXjNxkZAjgEZ0t2BAZgvDxtQb3eSP44vqG2+v+rci6Gp+HfSuPfofb3t/M7
        Sl84W2ckuzyZF91vAkX026rcVrrlJjKlhnN/6ZThN8ANRfJb+1qMgdJzQYbeejeZBJoT2h
        owoge4uW6zXAvEx/72haV00k91+WOpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-rh0eImRWOl6g9oguV4Lkgw-1; Tue, 02 Jun 2020 11:58:01 -0400
X-MC-Unique: rh0eImRWOl6g9oguV4Lkgw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CD3ABFC5;
        Tue,  2 Jun 2020 15:57:59 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-130.rdu2.redhat.com [10.10.116.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65C2D11CA58;
        Tue,  2 Jun 2020 15:57:59 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id D039E22063B; Tue,  2 Jun 2020 11:57:58 -0400 (EDT)
Date:   Tue, 2 Jun 2020 11:57:58 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
Message-ID: <20200602155758.GB3311@redhat.com>
References: <20200527041711.60219-1-yangerkun@huawei.com>
 <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com>
 <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
 <20200528173512.GA167257@redhat.com>
 <CAOQ4uxhnsc8AHfeQJ-eHFEjyONRF5bXBvRd-D29Nao4Bz8EM0g@mail.gmail.com>
 <20200529141623.GA196987@redhat.com>
 <CAOQ4uxhie2s+yvF1jpPnh6-+a-r8kz589Y5znAX_jmeWqo+SCQ@mail.gmail.com>
 <20200529190058.GB196987@redhat.com>
 <CAOQ4uxhkgx_1s0BrjNtDU+uHrVunG9FnQGUGr+DpoKsx2iaUBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhkgx_1s0BrjNtDU+uHrVunG9FnQGUGr+DpoKsx2iaUBA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 30, 2020 at 02:35:14PM +0300, Amir Goldstein wrote:
> On Fri, May 29, 2020 at 10:01 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, May 29, 2020 at 06:46:43PM +0300, Amir Goldstein wrote:
> > > > > > @@ -1023,7 +1020,7 @@ struct dentry *ovl_lookup(struct inode *
> > > > > >          *
> > > > > >          * Always lookup index of non-dir non-metacopy and non-upper.
> > > > > >          */
> > > > > > -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> > > > > > +       if (ctr && (!upperdentry || (!d.is_dir && !uppermetacopy)))
> > > > > >                 origin = stack[0].dentry;
> > > > > >
> > > > >
> > > > > I think this should be:
> > > > >
> > > > >           * Always lookup index of non-dir and non-upper.
> > > > >           */
> > > > >           if (!origin && ctr && (!upperdentry || !d.is_dir))
> > > > >                  origin = stack[0].dentry;
> > > > >
> > > > > uppermetacopy is guaranteed to either have origin already set or
> > > > > exit with an an error for ovl_verify_origin().
> > > >
> > > > Only if index is enabled and upper had origin xattr.
> > > >
> > > > (!d.is_dir && ofs->config.index && origin_path)
> > > >
> > > > So if index is disabled or uppermetacopy did not have "origin" xattr,
> > > > we will not have origin set by the time we come out of the loop.
> > > >
> > >
> > > True. But if index is disabled, setting origin is moot. origin is only
> > > ever used here to lookup the index.
> >
> > Well, while looking up for index, we are checking for presence of
> > index dir (and not checking whether index is currently enabled or
> > not). So if somebody mounts overlayfs with index=on and later remounts
> > with index=off, we can still start looking up the index even if it
> > is not enabled. Is it intentional? If not, to simplify it, should
> > we lookup index only if it is enabled.
> >
> >         if (origin && ofs->config.index &&
> >             (!d.is_dir || ovl_index_all(dentry->d_sb))) {
> >                 index = ovl_lookup_index(ofs, upperdentry, origin, true);
> >
> 
> What do you mean by remount? actual -o remount cannot
> change any overlay config variables.
> For umount/mount,  ofs->indexdir doesn't mean that there is an
> index dir, it means that index dir is in use because index is enabled.
> See:
> 
>         if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
> ...
>                 err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
> ...
>         if (!ofs->indexdir) {
>                 ofs->config.index = false;

I mean umount/mount. Got it so ovl_indexdir() will be true only if
index is enabled (and not just because index dir is present).

> 
> Most of the code checks for ofs->indexdir.
> The test for ofs->config.index is also correct, but inconsistent, although
> I see that we also use ofs->config.index in other places in ovl_lookup().

It will be nice if we had a single check to determine if index is
enabled or not. (instead of having instances of both ofs->config.index
as well as ovl_indexdir()).

> 
> >
> > >
> > > About "origin" xattr. If it is not set in upper that lower fs probably does
> > > not have file handle support. In that case, index cannot be enabled
> > > anyway.
> >
> > What about the case of multiple lower layers. IIUC, we will only
> > ensure that top most lower layer has file handle support and not
> > worry about rest of the layers. This will break the case of setting
> > origin for !upperdentry. This will lookup index and fail if lower
> > layer does not support file handle.
> >
> > So may be while enabling index, we should make sure all lower
> > layers support file handles otherwise fail?
> >
> 
> Enabling index requires that all layers support file handles:
> 
>                 pr_warn("fs on '%s' does not support file handles,
> falling back to index=off,nfs_export=off.\n",
>                         name);
>         }

Got it. So we will make sure all lower layers support file handles.

Thanks
Vivek

