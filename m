Return-Path: <SRS0=LI0E=CL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3013C43461
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 13:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A570D207D3
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Sep 2020 13:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aw1W30Ic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgIBN3j (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 09:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbgIBN3h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 2 Sep 2020 09:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599053365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AwPofCxUQ5lVm12Mh9rPt3eB3DoggA5s7vKMEhKywuU=;
        b=aw1W30Ic1dRpMwmdS69X17xSG9CZ+b8z8kQgHxk2lojKiMixgthfFoqO9EYSdTC25PqXEx
        0puoZSq0/yP9PRFGeSwVlTnTUPimdpsVO5Nw5QoNjNxwU8mUxB81XwEU13AfZipZVKy/uW
        62cmCpNBRzT/l6EJVhlKfKmiZ3QcCwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-WqwGMbHDPz6XqZtjNab2xA-1; Wed, 02 Sep 2020 09:29:23 -0400
X-MC-Unique: WqwGMbHDPz6XqZtjNab2xA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9A251BE;
        Wed,  2 Sep 2020 13:29:22 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-152.rdu2.redhat.com [10.10.114.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 536285C1C4;
        Wed,  2 Sep 2020 13:29:22 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C5501223642; Wed,  2 Sep 2020 09:29:21 -0400 (EDT)
Date:   Wed, 2 Sep 2020 09:29:21 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Mauro Condarelli <mc5686@mclink.it>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: Frequent errors with OverlayFS on root
Message-ID: <20200902132921.GA1263242@redhat.com>
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it>
 <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 02, 2020 at 06:34:12AM +0300, Amir Goldstein wrote:
> On Wed, Sep 2, 2020 at 2:37 AM Mauro Condarelli <mc5686@mclink.it> wrote:
> >
> > Thanks Amir,
> > comments inline below
> >
> > Regards
> > Mauro
> >
> > On 9/1/20 8:43 PM, Amir Goldstein wrote:
> >
> > On Tue, Sep 1, 2020 at 9:01 PM Mauro Condarelli <mc5686@mclink.it> wrote:
> >
> > Hi,
> > most likely this is not the right place to ask, please redirect me as needed.
> >
> > I'm trying to use OverlayFS to add (limited) write capability to a ReadOnly
> > rootfs (SquashFS)
> >
> > Essentially (actual script is more complex, of course) boot-sequence includes:
> >
> > # /dev/mmcblk0p5: ext4 (upper+work+nwwroot+newroot/oldroot)
> > # /dev/mmcblk0p6: SquashFS mounted on /
> > mount /dev/mmcblk0p5 /overlay
> > mount -t overlay overlay -o lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work  /overlay/newroot
> > cd /overlay/newroot
> > pivot_root . oldroot
> > mount --move oldroot/dev /dev
> > mount --move oldroot/proc /proc
> >
> > This works as expected, but, too often for comfort, some file
> > (and sometime also directories) become unavailable due to error:
> >
> > overlayfs: invalid origin (ssh/sshd_config, ftype=8000, origin ftype=4000).
> >
> > File name changes, of course, but rest is fairly constant.
> >
> > This always happens when some file is written.
> > Error persists reboots.
> > Only way I found to "cure" the system is to go on "upper" and delete the file
> > thus going back to "lower" version (in this case I should delete "/oldroot/overlay/upper/etc/ssh/sshd_config")
> >
> > This is a self-built kernel (Linux vocore 5.7.0 #2 PREEMPT Mon Aug 3 09:19:06 CEST 2020 mips GNU/Linux)
> > on a custom target based on a SoC (MT7628).
> >
> > I am available to do any required test, but I have no idea about where to start.
> >
> > Any hint (or redirect) would be greatly appreciated.
> >
> > This is probably your problem:
> > https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
> >
> > It surely looks like it is.
> > I tried to follow the thread, but I'm unsure i grokked it .
> >
> > I am using OverlayFS (ext4 over a SquashFS) on rootfs in order to
> > be able to update the whole system (changing SquashFS) while
> > retaining customization (essentially tweaks in /etc/, host certificates
> > and similar stuff) in an embedded target.
> >
> > To complicate matters I also have a dual system for fallback in case
> > of faulty upgrade; this means I can switch from:
> >   lower=part6, upper=part5, update will go into part7
> > to
> >   lower=part7, upper=part5, update will go into part6
> >
> > I don't need nfs at all, so exporting OverlayFS is not an issue,
> > but it's unclear to me if this "lower swapping" is
> > actually supported as I see:
> >
> > > > /me is again wondering what's the use case of modifying lower layer
> > > > with an existing upper. Is it fair to say, no don't recreate/modify
> > > > lower layers and use with existing upper.
> > > >
> > >
> > > It's fine by me to document that this is not supported.
> >
> > ... which is scary.
> > Note I do *not* need to modify lower on-the-fly, when I
> > swap systems, that will happen at reboot.
> 
> Don't be scared :-)
> Your reaction is a good answer to Vivek's question above -
> No, it is not fair to say don't re-create lower and use existing upper

This seems like a wrong use case to me. So in above example, say
following happens.

- Mount overlay
- modify sshd_config (it gets copied up).
- Lower squahsfs gets updated and /etc/sshd/sshd_config gets updated.
- Mount overlay and user now sees old copied up sshd_config. (If it
  works).

Conceptually it is not making much sense to me. What's the point of
upgrading lower because after mounting overlay you might still see
old file. And to make it worse, behavior is underministic beacuse
if file has not been copied up, you will see new file.

To me, this sounds like a volatile overlay use case. Any changes to
overlay should be thrown away when lower sqashfs is updated and a
fresh upper should be set.

Thanks
Vivek

