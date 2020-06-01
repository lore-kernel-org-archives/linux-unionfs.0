Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C817CC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2C672074B
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVlHT7ti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgFAOEx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 10:04:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23779 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726075AbgFAOEx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 10:04:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591020291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=StF/NWIOhWeM4QPHpG+MGMc6yeYvxUAyCgOdMmaYie8=;
        b=UVlHT7tiiwCrPB1jIlowgsKqoMPwCgocTB2fCctm4yteWbngC2Oe74P2y22YYk6Z+1Lub/
        eFCsWGC6gbMQGfVW45cPBY5q3sphd6ZmjjF8TlSm3dwJOatTC++7VY4+58ZgTQ3lt3Yvi9
        XDpMJNdhdT7M2B1pX/qAWcMhFaPr7oI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-YfwDeQ1tNgqwwEdPV2zR8g-1; Mon, 01 Jun 2020 10:04:49 -0400
X-MC-Unique: YfwDeQ1tNgqwwEdPV2zR8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C9C31009440;
        Mon,  1 Jun 2020 14:04:48 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 983B910016E8;
        Mon,  1 Jun 2020 14:04:47 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E9C29220244; Mon,  1 Jun 2020 10:04:46 -0400 (EDT)
Date:   Mon, 1 Jun 2020 10:04:46 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] overlayfs: Simplify setting of origin for index
 lookup
Message-ID: <20200601140446.GA3219@redhat.com>
References: <20200529212952.214175-1-vgoyal@redhat.com>
 <20200529212952.214175-2-vgoyal@redhat.com>
 <CAOQ4uxj=MoKfo32tz8zmxf13gheDt+y1DZ3-oznY9YX=DhWiFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj=MoKfo32tz8zmxf13gheDt+y1DZ3-oznY9YX=DhWiFg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 30, 2020 at 01:37:37PM +0300, Amir Goldstein wrote:
> On Sat, May 30, 2020 at 12:30 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > overlayfs can keep index of copied up files and directories and it
> > seems to serve two primary puroposes. For regular files, it avoids
> > breaking lower hardlinks over copy up. For directories it seems to
> > be used for various error checks.
> >
> > During ovl_lookup(), we lookup for index using lower dentry in many
> > a cases. That lower dentry is called "origin" and following is a summary
> > of current logic.
> >
> > If there is no upperdentry, always lookup for index using lower dentry.
> > For regular files it helps avoiding breaking hard links over copyup
> > and for directories it seems to be just error checks.
> >
> > If there is an upperdentry, then there are 3 possible cases.
> >
> > - For directories, lower dentry is found using two ways. One is regular
> >   path based lookup in lower layers and second is using ORIGIN xattr
> >   on upper dentry. First verify that path based lookup lower dentry
> >   matches the one pointed by upper ORIGIN xattr. If yes, use this
> >   verified origin for index lookup.
> >
> > - For regular files (non-metacopy), there is no path based lookup in
> >   lower layers as lookup stops once we find upper dentry. So there
> >   is no origin verification. If there is ORIGIN xattr present on upper,
> >   use that to lookup index otherwise don't.
> >
> > - For regular metacopy files, again lower dentry is found using
> >   path based lookup as well as ORIGIN xattr on upper. Path based lookup
> >   is continued in this case to find lower data dentry for metacopy
> >   upper. So like directories we only use verified origin. If ORIGIN
> >   xattr is not present (Either because lower did not support file
> >   handles or because this is hardlink copied up with index=off), then
> >   don't use path lookup based lower dentry as origin. This is same
> >   as regular non-metacopy file case.
> >
> 
> Very good summary.
> You may add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> But see one improvement below.
> Also, please make sure to run unionmount setups:
> 
> ./run --ov=10 --verify
> ./run --ov=10 --meta --verify
> 
> --verify will enable index and check st_dev;st_ino are not broken
> on copy up. --ov=10 will cause lower hardlink copy up, because
> after hardlink is creates by some test, upper is rotated to mid layer
> and next modifying operation will trigger the hardlink copy up.

Hi Amir,

I ran above configurations and it passes with the patches.

Thanks for these suggestions. I used to run only "./run --ov" so far.
It will be nice to have some documentation about --meta, --verify in README.

> 
> > Suggested-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/namei.c | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 0db23baf98e7..5d80d8cc0063 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -1005,25 +1005,30 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                 }
> >                 stack = origin_path;
> >                 ctr = 1;
> > +               origin = origin_path->dentry;
> >                 origin_path = NULL;
> >         }
> >
> [...]
> > -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> > +       if (!origin && ctr && !upperdentry)
> >                 origin = stack[0].dentry;
> >
> 
> No need to understand the long story to verify this change is correct.
> This is true simply because the conditions to set stack = origin_path are:
> 
>        if (!metacopy && !d.is_dir && upperdentry && !ctr && origin_path)
> 
> And after getting there and setting ctr = 1, the complex conditions to
> setting origin are met for certain:
> 
>         if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> 
> Therefore, it is logically equivalent (and makes much more sense)
> to assign origin near stack = origin_path.
> 
> Further, thanks to Vivek's explanation, it is now clear to me that after
> setting origin above, all that is left to do here is:
> 
>          /* Always lookup index of non-upper */
>         if (!upperdentry)
>                 origin = stack[0].dentry;

This looks better. What about the case of non existing dentry with ctr=0.
In that case we will set origin to NULL. It still works but it probably
will be nice if we do.

	/* Always lookup index of non-upper */
	if (!upperdentry && ctr)
                 origin = stack[0].dentry;

Just making it explicit that we try to use lower as origin only if
some lower dentry was found.

Thanks
Vivek

