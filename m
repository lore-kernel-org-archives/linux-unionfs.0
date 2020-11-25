Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3954C63798
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A14A20679
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Nov 2020 18:52:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JST/sZkY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732932AbgKYSwu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 13:52:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731511AbgKYSwt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Nov 2020 13:52:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606330368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x6xqo/MYsp7oymmcIhdoPe24C/6u5455ngwCWpIYv6Q=;
        b=JST/sZkYs6wElVjpFpYgFIPK9POecmpR5OFMi1Cb4+6se7m2Tf72m19j4b4HH8khsrDFY+
        fhejtwhomnC3uhkewyGdzFavR5bNQZJEjtGh+pbvZO4p9BKSmlCPLkZTSukwTcOiD1164L
        iHXZwUxr5s+4AesHHqkaSsaCPK2XeiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-v_DT-97cNj6IQEt9BmKoPA-1; Wed, 25 Nov 2020 13:52:45 -0500
X-MC-Unique: v_DT-97cNj6IQEt9BmKoPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16BB8DF8D9;
        Wed, 25 Nov 2020 18:52:33 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-154.rdu2.redhat.com [10.10.114.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA37E60BE5;
        Wed, 25 Nov 2020 18:52:32 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 77BC822054F; Wed, 25 Nov 2020 13:52:32 -0500 (EST)
Date:   Wed, 25 Nov 2020 13:52:32 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1 2/3] overlay: Add the ability to remount volatile
 directories when safe
Message-ID: <20201125185232.GF3095@redhat.com>
References: <20201125104621.18838-1-sargun@sargun.me>
 <20201125104621.18838-3-sargun@sargun.me>
 <20201125181704.GD3095@redhat.com>
 <CAMp4zn_jR28x4P21QaHJV8AzG90ZZO3=K+pDVwNovP1m3hf7pw@mail.gmail.com>
 <20201125184305.GE3095@redhat.com>
 <CAMp4zn-fRa9i=D1N4GTU3bB891vG0qkaALzOOh3mzokNme=YbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMp4zn-fRa9i=D1N4GTU3bB891vG0qkaALzOOh3mzokNme=YbA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Nov 25, 2020 at 10:47:38AM -0800, Sargun Dhillon wrote:
> On Wed, Nov 25, 2020 at 10:43 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Nov 25, 2020 at 10:31:36AM -0800, Sargun Dhillon wrote:
> > > On Wed, Nov 25, 2020 at 10:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > On Wed, Nov 25, 2020 at 02:46:20AM -0800, Sargun Dhillon wrote:
> > > >
> > > > [..]
> > > > > @@ -1125,16 +1183,19 @@ static int ovl_workdir_cleanup_recurse(struct path *path, int level)
> > > > >                       if (p->len == 2 && p->name[1] == '.')
> > > > >                               continue;
> > > > >               } else if (incompat) {
> > > > > -                     pr_err("overlay with incompat feature '%s' cannot be mounted\n",
> > > > > -                             p->name);
> > > > > -                     err = -EINVAL;
> > > > > -                     break;
> > > > > +                     err = ovl_check_incompat(ofs, p, path);
> > > > > +                     if (err < 0)
> > > > > +                             break;
> > > > > +                     /* Skip cleaning this */
> > > > > +                     if (err == 1)
> > > > > +                             continue;
> > > > >               }
> > > >
> > > > Shouldn't we clean volatile/dirty on non-volatile mount. I did a
> > > > volatile mount followed by a non-volatile remount and I still
> > > > see work/incompat/volatile/dirty and "trusted.overlay.volatile" xattr
> > > > on "volatile" dir. I would expect that this will be all cleaned up
> > > > as soon as that upper/work is used for non-volatile mount.
> > > >
> > > >
> > >
> > > Amir pointed out this is incorrect behaviour earlier.
> > > You should be able to go:
> > > non-volatile -> volatile
> > > volatile -> volatile
> > >
> > > But never
> > > volatile -> non-volatile, since our mechanism is not bulletproof.
> >
> > Ok, so one needs to manually remove volatile/dirty to be able to
> > go from volatile to non-volatile.
> >
> > I am wondering what does this change mean in terms of user visible
> > behavior. So far, if somebody tried a remount of volatile overlay, it
> > will fail. After this change, it will most likely succeed. I am
> > hoping nobody relies on remount failure of volatile mount and
> > complain that user visible behavior changed after kernel upgrade.
> >
> > Thanks
> > Vivek
> >
> If I respin this shortly, can we get it in rc6, or do we want to wait
> until 5.11?

I think that trying to squeeze it in this late in cycle is probably
not a good idea. If above is a valid concern, then this feature probably
needs to be an opt-in.

Thanks
Vivek

