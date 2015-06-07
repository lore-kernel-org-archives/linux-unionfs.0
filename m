From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 2/2] ovl: allow distributed fs as lower layer
Date: Sat, 06 Jun 2015 20:02:56 -0500
Message-ID: <877frgwcsf.fsf@x220.int.ebiederm.org>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
	<1433424586-7771-3-git-send-email-miklos@szeredi.hu>
	<20150605000715.GP7232@ZenIV.linux.org.uk>
	<20150605150939.GA2174@tucsk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:56460 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbbFGBIF (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 6 Jun 2015 21:08:05 -0400
In-Reply-To: <20150605150939.GA2174@tucsk> (Miklos Szeredi's message of "Fri,
	5 Jun 2015 17:37:29 +0200")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, sa-dev@rainbow.by, andre.roth@roche.com

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Fri, Jun 05, 2015 at 01:07:15AM +0100, Al Viro wrote:
>
>> Umm...  Cosmetical point is that this
>> 
>> > +static bool ovl_remote(struct dentry *root)
>> > +{
>> > +	const struct dentry_operations *dop = root->d_op;
>> > +
>> > +	return dop && (dop->d_revalidate || dop->d_weak_revalidate);
>> > +}
>> 
>> is better done as
>> 	root->d_flags & (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)
>
> Okay.
>
>> 
>> More interesting question is whether anything in the system relies on
>> existing behaviour that follows ->d_revalidate() returning 0.
>
> Hmm, d_invalidate() almost always follows ->d_revalidate().  Almost, becuase RCU
> lookup can get aborted at that point.  We can easily stick d_invalidate() in
> there for the non-RCU case.
>
> Regular lookup also almost always follows ->d_revalidate().  Except if
> allocation of new dentry fails.  So relying on this would be buggy (which is not
> to say nobody does it).
>
>>  Have you tried to mount e.g. procfs as underlying layer and torture it for a
>> while?
>
> I did try now.  Nothing bad happened during the test (parallel stat(1) of the
> whole overlayed proc tree).
>
> My laptop froze while trying to write this mail.  But it's 8 years old and when
> the fan starts to make noises and the weather is hot, it does this sometimes.  I
> don't think that has anything to do with overlayfs, but will do more
> testing...

A nasty corner case to be aware of (and I think this is part of what Al
was warning about).  /proc/sys/net is different depending upon which
current->nsproxy->net_ns.

Eric
