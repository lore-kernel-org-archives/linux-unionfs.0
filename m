Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACAFC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ECF065141
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhCISum (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 13:50:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230433AbhCISuh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Mar 2021 13:50:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615315836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P5yWlLAM1hQku6lKoweaexBCXU/6ncB8LD7DlrhJfto=;
        b=G4sIvr+rI/utyAZTXwDBt4IFlMDBG0dtTP9Fqhears1mbaFJgSx4gGnRjO60dJpBjkpWLB
        o25hJ+X6Qii8/ejyxoBvlsjt8bhZU7kOXQZSIcx/c0pBVVsy1YlTxDDW0Ao+mIDYIDskyQ
        CvHkKJ2pkVbC8by0O0zT/Da2hqoIcvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-d_tgX6U_OfCWC_-6YnaQIA-1; Tue, 09 Mar 2021 13:50:34 -0500
X-MC-Unique: d_tgX6U_OfCWC_-6YnaQIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5104C801817;
        Tue,  9 Mar 2021 18:50:33 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-126.rdu2.redhat.com [10.10.115.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3E705D6D7;
        Tue,  9 Mar 2021 18:50:32 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6B96D22054F; Tue,  9 Mar 2021 13:50:32 -0500 (EST)
Date:   Tue, 9 Mar 2021 13:50:32 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Kevin Locke <kevin@kevinlocke.name>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: add xino to "changes to underlying fs" docs
Message-ID: <20210309185032.GI77194@redhat.com>
References: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
 <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
 <CAOQ4uxhGSbEPPwZswXHq+k1YF=+ntDfukxnfGsJ3+RaGjgNDnQ@mail.gmail.com>
 <YEa4Jd0VE6w4T7/v@kevinlocke.name>
 <CAOQ4uxjBb_whXA5eNqkwDNj2VSS-F+0uACF7tpqFTrM8fYETQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjBb_whXA5eNqkwDNj2VSS-F+0uACF7tpqFTrM8fYETQg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 09, 2021 at 09:24:22AM +0200, Amir Goldstein wrote:
> On Tue, Mar 9, 2021 at 1:50 AM Kevin Locke <kevin@kevinlocke.name> wrote:
> >
> > Hi Amir,
> >
> > On Mon, 2021-03-08 at 19:41 +0200, Amir Goldstein wrote:
> > > On Mon, Mar 8, 2021 at 5:23 PM Kevin Locke <kevin@kevinlocke.name> wrote:
> > >> Add "xino" to the list of features which cause undefined behavior for
> > >> offline changes to the lower tree in the "Changes to underlying
> > >> filesystems" section of the documentation to make users aware of
> > >> potential issues if the lower tree is modified and xino was enabled.
> > >>
> > >> This omission was noticed by Amir Goldstein, who mentioned that xino is
> > >> one of the "forbidden" features for making offline changes to the lower
> > >> tree and that it wasn't currently documented.
> > >
> > > [...]
> > > When looking again, I actually don't see a reason to include "xino"
> > > in this check at all (not xino=on nor xino=auto):
> > >
> > >  if (!ofs->config.index && !ofs->config.metacopy && !ofs->config.xino &&
> > >      uuid_is_null(uuid))
> > >          return false;
> > >
> > > The reason that "index" and "metacopy" are in this check is because
> > > they *need* to follow the lower inode of a non-dir upper in order to
> > > operate correctly. The same is not true for "xino".
> > >
> > > Moreover, "xino" will happily be enabled also when lower fs does not
> > > support file handles at all. It will operate sub-optimally, but it will live up
> > > to the promise to provide a unified inode namespace and uniform st_dev.
> >
> > Good observation!  I think you are right.  After a bit of testing, I did
> > not notice any issues after making offline changes to lower with xino
> > enabled.
> >
> 
> He, that's not what I meant.
> I wouldn't expect that you *observe* any issues, because the issues
> with following the wrong object are quite rare and you need to make
> changes to lower squashfs to notice them, see:
> https://lore.kernel.org/lkml/20191106234301.283006-1-colin.king@canonical.com/
> 
> But as a matter of fact, I was wrong and I misled you. Sorry.
> 
> I read the code backwards.
> 
> It's not true that we can allow lower modification with "xino=on/auto" -
> quite the opposite - we may need to disallow lower modifications also
> with "xino=off".
> 
> Let me explain.
> The following table documents expected behavior with different
> features and layer setups:
> https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#inode-properties
> 
> As you can see, the matrix is quite complex.
> The problem lies with the documented behavior of "Persistent st_ino of !dir"
> for the case of "Layers not on same fs, xino=off".
> 
> It claims that st_ino will be persistent, but in fact it is only true
> if lower fs
> supports file handles AND has a unique [*] UUID amongst the lower layers.
> The claim that st_ino is persistent for !dir in case of "ino overflow" is also
> incorrect.
> 
> [*] The special case of NULL UUID (e.g. squashfs) was recently changed
>      and depends on whether the opt-in features are enabled...
> 
> In any case, the documented behavior for Persistent st_ino (!dir) is
> incorrect for the case of (e.g.) lower squashfs with -no-exports.
> IWO, in this setup, st_ino of a lower file will change following copy up
> and mount cycle.
> 
> I do not want to add all this story to documentation - the matrix is
> complex enough to follow as it is.
> 
> Seeing that distros are switching to enable xino by default, I was
> contemplating to change the behavior of the code as follows:
> 
> - If user opts-out of xino by mount option (xino=off is *shown*
>   in /proc/mounts) do not follow origin by file handle
> - Let index and metacopy require and auto-enable xino, so e.g.:
>   mount options index=on,xino=off will be a conflict
> - If lower does not support file handles or has NULL UUID and
>   xino is enabled by default, then auto-disable xino and do not
>   follow origin (xino=off will be shown in /proc/mounts)
> - If xino is disabled by default, we DO follow origin as we always
>   did (xino=off is NOT shown in /proc/mounts)
> - Change the documented value for Persistent st_ino (!dir) in case
>   of "xino=off" and in case of "ino overflow" to N
> 
> Pros:
> 1. This makes for simpler and more coherent documentation IMO.
> 2. It doesn't change behavior for legacy layers with all default
>     kernel configs and default mount options.
> 3. It actively averts the reported issues caused by re-formatting
>     lower squashfs with distro kernel configs and default mount options.
> 
> Cons:
> 1. After kernel upgrade, existing setups with lower squashfs that did
>     not opt-in for xino by mount option will lose xino
> 2. Existing setups that opt-out of xino by mount option (because of old
>     32bit applications?) will loose persistent st_ino behavior
> 
> IMO, the Pros out weight the Cons.
> 
> I've suggested adding a way to opt-out of following origin several times,
> but was not able to convince Miklos so far.
> Let's see if this time is any different...
> 
> > > Note that "redirect_dir" is not one of the "forbidden" features.
> >
> > To be clear, are you saying that offline modifications to directories in
> > lower layers which are the redirection target of an upper layer does not
> > cause undefined behavior?  Would it make sense for me to work up a patch
> > which documents the behavior, or is it better to leave as "defined but
> > undocumented"?
> >
> 
> I just mislead you. Sorry for that.
> We should leave "redirect_dir" in the documented list and add "xino"
> just like the patch you posted.
> But I guess if I am going to post a patch to change the xino behavior,
> it would be better to include your change in my patch for context.

This is quite complex to understand. I think I still stick to general
stand that if any overlay feature stores any metadata info about
lower layer in upper layer, then we should not allow changes to
offline layers.  Otherwise there are so many possibilities to analyze
to figure out the effect of a offline change. It is confusing for
developers as well as users. So, IMHO, I will take simpler approach of
no lower layer modifications for all these advanced features otherwise
expect the unexpected. :-)

Thanks
Vivek

