From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 2/2] ovl: allow distributed fs as lower layer
Date: Tue, 09 Jun 2015 07:54:37 -0500
Message-ID: <87sia1rqia.fsf@x220.int.ebiederm.org>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
	<1433424586-7771-3-git-send-email-miklos@szeredi.hu>
	<20150605000715.GP7232@ZenIV.linux.org.uk>
	<20150605150939.GA2174@tucsk> <877frgwcsf.fsf@x220.int.ebiederm.org>
	<CAJfpegtM4KnKA+isDTDpakJcaYJT5nhN=pQUJx8Hs58SsondJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:39251 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbbFIM7u (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Jun 2015 08:59:50 -0400
In-Reply-To: <CAJfpegtM4KnKA+isDTDpakJcaYJT5nhN=pQUJx8Hs58SsondJA@mail.gmail.com>
	(Miklos Szeredi's message of "Tue, 9 Jun 2015 14:44:09 +0200")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, sa <sa-dev@rainbow.by>, "Roth, Andre" <andre.roth@roche.com>

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Sun, Jun 7, 2015 at 3:02 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> A nasty corner case to be aware of (and I think this is part of what Al
>> was warning about).  /proc/sys/net is different depending upon which
>> current->nsproxy->net_ns.
>
> Ah,  I'm beginning to grasp what's going on there: mulitple dentries
> with the same name but belonging to different namespaces,
> ->d_compare() being used to select the right one.  Is that it?

Yes.  The whole sysctl_is_seen magic.

I am not proud of it, and I keep thinking I should create
/proc/<pid>/sys/...  making /proc/sys a symlink to /proc/<pid>/sys/

so that case could go away.  Although at this point tomoyo or apparmor
probably has rules that would make that impossible (despite no
applications actually caring). *sigh*

> Overlayfs checks for d_compare() on the root of the lower and upper
> trees, but here it only set on a subdirectory of proc, not on every
> dentry.  So overlayfs should be careful and check for
> DCACHE_OP_COMPARE | DCACHE_OP_HASH and reject going down such a
> dentry.

That sound about right.

Eric
