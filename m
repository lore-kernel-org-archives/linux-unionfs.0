Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9705FC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 776E5207D5
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVxsUv4G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgFAPXU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:23:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726125AbgFAPXU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:23:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591024998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C8MlWiH6GkdxXSqFWGUS1ok8sWpewkop1S8j5JiQpKA=;
        b=FVxsUv4GSEX23qHhTfRgJ5JFhekgyLA0udaOGZYZYd09Ntdd2FXkKF94AHXcmoZ/ihOaTc
        XRNC/ZiGL7iySPERahROu9+BArLiR8g7/PBAPW35dNQlmd4YJynIUMA1v6kPugOjTN4VjJ
        poJWO4fsmPObb2ZSOFO0SjKe8cxtk3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-dGwYLVcnNUOVtzVydG4RaQ-1; Mon, 01 Jun 2020 11:23:16 -0400
X-MC-Unique: dGwYLVcnNUOVtzVydG4RaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAFA98A6130;
        Mon,  1 Jun 2020 15:22:53 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C23B47E7F8;
        Mon,  1 Jun 2020 15:22:52 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 62B20220244; Mon,  1 Jun 2020 11:22:52 -0400 (EDT)
Date:   Mon, 1 Jun 2020 11:22:52 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] overlayfs: ovl_lookup(): Use only uppermetacopy state
Message-ID: <20200601152252.GB3219@redhat.com>
References: <20200529212952.214175-1-vgoyal@redhat.com>
 <20200529212952.214175-3-vgoyal@redhat.com>
 <CAOQ4uxi08jyGa_aPBLxWoF1649+6CzZ6iJtiz76cKUvWRnpVvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi08jyGa_aPBLxWoF1649+6CzZ6iJtiz76cKUvWRnpVvA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 30, 2020 at 02:01:28PM +0300, Amir Goldstein wrote:
[..]
> > @@ -982,23 +987,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                 }
> >         }
> >
> > -       if (metacopy) {
> > -               /*
> > -                * Found a metacopy dentry but did not find corresponding
> > -                * data dentry
> > -                */
> > -               if (d.metacopy) {
> > -                       err = -EIO;
> > -                       goto out_put;
> > -               }
> > +       /* Found a metacopy dentry but did not find corresponding data dentry */
> > +       if (d.metacopy) {
> 
> I suggested this change and I think it is correct, but it is correct for a bit
> of a subtle reason.
> It is correct because ovl_lookup_layer() (currently) cannot return NULL
> and set d.metacopy to false.
> So I suggest to be a bit more defensive and write this condition as:
> 
>        if (d.metacopy || (uppermetacopy && !ctr)) {

Ok, will do.

> 
> > +               err = -EIO;
> > +               goto out_put;
> > +       }
> >
> > -               err = -EPERM;
> > -               if (!ofs->config.metacopy) {
> > -                       pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",
> > -                                           dentry);
> > -                       goto out_put;
> > -               }
> > -       } else if (!d.is_dir && upperdentry && !ctr && origin_path) {
> > +       /* For regular non-metacopy upper dentries, there is no lower
> > +        * path based lookup, hence ctr will be zero. dentry found using
> > +        * ORIGIN xattr on upper, install it in stack.
> > +        */
> > +       if (!d.is_dir && upperdentry && !ctr && origin_path) {
> 
> I don't like this comment style for multi line comment and I don't
> like that you detached this if statement from else if.
> I think it made more sense with the else because this is (as you write)
> the non-metacopy case.

Will do in V2.

Thanks
Vivek

