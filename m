From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Fwd: overlayfs+selinux error: OPNOTSUPP
Date: Mon, 21 Sep 2015 23:34:04 +0900
Message-ID: <19636.1442846044@jrobl>
References: <20150921074335.GI22582@cyber.com.au>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:40850 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbIUOnT (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 21 Sep 2015 10:43:19 -0400
Received: from mail05-md.ns.itscom.net (mail05-md.ns.itscom.net [175.177.155.115])
	by mfb02-md.ns.itscom.net (Postfix) with ESMTP id 41C8D170E577
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2015 23:34:08 +0900 (JST)
In-Reply-To: <20150921074335.GI22582@cyber.com.au>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Matthew Cengia <mattcen@cyber.com.au>
Cc: linux-unionfs@vger.kernel.org


Matthew Cengia:
> I've posted a message to LKML on Friday, and subsequently, upon
> recommendation, have posted to the SELinux list, but then I stumbled
> upon this list, which seems to have at least semi-relevent discussion on
> SELinux/overlay interactions. I'd really appreciate if you folks could
> have a look at my post (https://lkml.org/lkml/2015/9/17/888) to see if
> it's anything you're able to help with; I'm running out of ideas!
	:::

(from the quoted post)
----------------------------------------------------------------------
aufs doesn't support SELinux, so I had to switch to overlayfs.
So now my target is Debian 8 / Linux 4.1 / systemd / overlayfs / SELinux.
----------------------------------------------------------------------

I know aufs is not your main concern, but would you tell me why do you
think that aufs doesn't support SELinux? If I remember correctly, aufs
can live with SELinux. It might be due to your (or your distribution's)
configuration, especially CONFIG_AUFS_XATTR.


J. R. Okajima
