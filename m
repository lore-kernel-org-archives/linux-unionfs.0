Return-Path: <SRS0=I2E7=5B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29E2C0044D
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 18:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9709B20409
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 18:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfTIGXtb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbgCPSWG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 14:22:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:36152 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732341AbgCPSWG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Mar 2020 14:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584382924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TTcDsK38PxLqXZs56dVcHoUHxE9Gbzps6dWiiy9+2t0=;
        b=BfTIGXtbE2JD862rEmS4T9x0g6M904wHGC5wAYFteeWRilOSfMWSu960qLodj0tSuNch6d
        hSZMVv3x4wnq2DO5+Ki0HSxWg87T0wp59zQzGCaVmiFHv7zmZxDjJQnDgKMuGatBDaFEaw
        M9WhIRwZrhd8UoY5crwmSIlshkEaT7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-yxWnqwuLPfmBjML7xvoYAw-1; Mon, 16 Mar 2020 14:15:07 -0400
X-MC-Unique: yxWnqwuLPfmBjML7xvoYAw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 653C1153919;
        Mon, 16 Mar 2020 17:54:54 +0000 (UTC)
Received: from horse.redhat.com (ovpn-121-211.rdu2.redhat.com [10.10.121.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43FDF5D9E2;
        Mon, 16 Mar 2020 17:54:54 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 9FDDC2234E4; Mon, 16 Mar 2020 13:54:53 -0400 (EDT)
Date:   Mon, 16 Mar 2020 13:54:53 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ovl: alllow remote upper
Message-ID: <20200316175453.GB4013@redhat.com>
References: <20200131115004.17410-1-mszeredi@redhat.com>
 <20200131115004.17410-5-mszeredi@redhat.com>
 <20200204145951.GC11631@redhat.com>
 <CAJfpegtq4A-m9vOPwUftiotC_Xv6w-dnhCi9=E0t-b1ZPJXPGw@mail.gmail.com>
 <CAOQ4uxj_pVp9-EN2Gmq9j6G3xozzpK_zQiRO-brx6PZ9VpgD0Q@mail.gmail.com>
 <CAOQ4uxjFYO28r+0pY+pKxK-dDJcQF2nf2EivnOUBgrgkYTFjPQ@mail.gmail.com>
 <CAOQ4uxhZ8a2ObfB9sUtrc=95mM70qurLtXkaNyHOXYxGEKvxFw@mail.gmail.com>
 <CAOQ4uxhkd5FkN5ynpQxQ0m1MR9MgzTBbvzjkoHfSRA2umb-JTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhkd5FkN5ynpQxQ0m1MR9MgzTBbvzjkoHfSRA2umb-JTA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Mar 14, 2020 at 03:16:28PM +0200, Amir Goldstein wrote:
> On Thu, Feb 20, 2020 at 10:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Thu, Feb 20, 2020 at 9:52 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Feb 4, 2020 at 7:02 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Tue, Feb 4, 2020 at 6:17 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > >
> > > > > On Tue, Feb 4, 2020 at 3:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Jan 31, 2020 at 12:50:04PM +0100, Miklos Szeredi wrote:
> > > > > > > No reason to prevent upper layer being a remote filesystem.  Do the
> > > > > > > revalidation in that case, just as we already do for lower layers.
> > > > > > >
> > > > > > > This lets virtiofs be used as upper layer, which appears to be a real use
> > > > > > > case.
> > > > > >
> > > > > > Hi Miklos,
> > > > > >
> > > > > > I have couple of very basic questions.
> > > > > >
> > > > > > - So with this change, we will allow NFS to be upper layer also?
> > > > >
> > > > > I haven't tested, but I think it will fail on the d_type test.
> > > >
> > > > But we do not fail mount on no d_type support...
> > > > Besides, I though you were going to add the RENAME_WHITEOUT
> > > > test to avert untested network fs as upper.
> > > >
> > >
> > > Pushed strict remote upper check to:
> > > https://github.com/amir73il/linux/commits/ovl-strict-upper
> > >
> 
> Vivek,
> 
> Could you please make sure that the code in ovl-strict-upper branch
> works as expected for virtio as upper fs?

Hi Amir,

Right now it fails becuase virtiofs doesn't seem to support tmpfile yet.

overlayfs: upper fs does not support tmpfile
overlayfs: upper fs missing required features.

Will have to check what's required to support it.

I also wanted to run either overlay xfstests or unionmount-testsuite. But
none of these seem to give me enough flexibility where I can specify 
that overlayfs needs to be mounted on top of virtiofs.

I feel that atleast for unionmount-testsuite, there should be an
option where we can simply give a target directory and tests run
on that directory and user mounts that directory as needed.

> I have rebased it on latest overlayfs-next merge into current master.
> 
> I would very much prefer that the code merged to v5.7-rc1 will be more
> restrictive than the current overlayfs-next.

In general I agree that if we want to not support some configuration
with remote upper, this is the time to introduce that restriction
otherwise we will later run into backward compatibility issue.

Having said that, tmpfile support for upper sounds like a nice to
have feature. Not sure why to make it mandatory.

Vivek

