Return-Path: <SRS0=taqF=7L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF313C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 14:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E2A2072D
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 14:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UU1+JVfh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgE2OQc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 10:16:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60940 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726593AbgE2OQb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 10:16:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590761789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nj2rRJ73ydPziIlK2XMY6Pvz/RpU9WQBmVdUQ0PjhQQ=;
        b=UU1+JVfhJELhEWpQ0Bbdvhayyx4uCVWPA/iDs9QBvYh7YRp6FUz4ujw36Wr8IMseDqB6lP
        prHe7h64h4rDyB9FpUuTQAenuO0ZWb1EQ2ezwt7AAlXx6FGpD1WlsH7emoPF9YgAhGLVOF
        qVXnIuImLXgINRzOFRVHLCMNkNeqWbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-wRRk4MrTOLGGCGsers4tcw-1; Fri, 29 May 2020 10:16:25 -0400
X-MC-Unique: wRRk4MrTOLGGCGsers4tcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ACEA835B41;
        Fri, 29 May 2020 14:16:24 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-93.rdu2.redhat.com [10.10.115.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0880F5D9EF;
        Fri, 29 May 2020 14:16:24 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4573322066B; Fri, 29 May 2020 10:16:23 -0400 (EDT)
Date:   Fri, 29 May 2020 10:16:23 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
Message-ID: <20200529141623.GA196987@redhat.com>
References: <20200527041711.60219-1-yangerkun@huawei.com>
 <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com>
 <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
 <20200528173512.GA167257@redhat.com>
 <CAOQ4uxhnsc8AHfeQJ-eHFEjyONRF5bXBvRd-D29Nao4Bz8EM0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhnsc8AHfeQJ-eHFEjyONRF5bXBvRd-D29Nao4Bz8EM0g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 29, 2020 at 12:07:45AM +0300, Amir Goldstein wrote:

[..]
> > +       /* Found a metacopy dentry but did not find corresponding data dentry */
> > +       if (d.metacopy) {
> > +               err = -EIO;
> > +               goto out_put;
> > +       }
> >
> > +       if (lowermetacopy || uppermetacopy) {
> >                 err = -EPERM;
> >                 if (!ofs->config.metacopy) {
> >                         pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",
> 
> Move that test up to where setting metacopy = true for lower layers
> similar to "refusing to follow redirect" and make it:
>        if (uppermetacopy || d.metacopy) {
> 
> Then you got rid of lowermetacopy.

Agreed. Will change. 

> 
> > @@ -1023,7 +1020,7 @@ struct dentry *ovl_lookup(struct inode *
> >          *
> >          * Always lookup index of non-dir non-metacopy and non-upper.
> >          */
> > -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> > +       if (ctr && (!upperdentry || (!d.is_dir && !uppermetacopy)))
> >                 origin = stack[0].dentry;
> >
> 
> I think this should be:
> 
>           * Always lookup index of non-dir and non-upper.
>           */
>           if (!origin && ctr && (!upperdentry || !d.is_dir))
>                  origin = stack[0].dentry;
> 
> uppermetacopy is guaranteed to either have origin already set or
> exit with an an error for ovl_verify_origin().

Only if index is enabled and upper had origin xattr.

(!d.is_dir && ofs->config.index && origin_path)

So if index is disabled or uppermetacopy did not have "origin" xattr,
we will not have origin set by the time we come out of the loop.

I see for non-metacopy regular files, if upper did not have origin
xattr, that means origin_path will by NULL. That means ctr will be
0 and that means we will not set "origin" for non-metacopy regular
files in such case. So question is, should we set "origin" for
metacopy upper files in such a case.

We did not have origin xattr, but we looked up lower layers for
upper metacopy. In theory, stack[0].dentry is origin for upper
metacopy files. Should we use it? Current logic does not and that's
why this additiona check (!d.is_dir && !uppermetacopy).

> 
> HOWEVER, if we set origin to lower, which turns out to be a lower
> metacopy, we then skip this layer to the next one, but origin remains
> set on the skipped layer dentry, which we had already dput().
> Ay ay ay!

We only skip the intermediate metacopy entries in lower. So top most
lower metacopy will still be retained. For example, if there are 3
lower layers where top two are metacopy and one data, then we will
only skip middle one. And middle one should not be origin for upper.

                /*
                 * Do not store intermediate metacopy dentries in chain,
                 * except top most lower metacopy dentry
                 */
                if (d.metacopy && ctr) {
                        dput(this);
                        continue;
                }

For the first lower, ctr will be 0 and we will always store it in 
stack. So if it is metacopy dentry, it will still be stored at
stack[0]. 

Do you still see the problem?

> 
> I think it would be best to move the check
>                  * Do not store intermediate metacopy dentries in chain,
> to right after ovl_lookup_layer(), before the ovl_fix_origin() and
> ovl_verify_origin() checks.

Thanks
Vivek

