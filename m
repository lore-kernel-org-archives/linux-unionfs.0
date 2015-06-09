From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/2] ovl: allow distributed fs as lower layer
Date: Tue, 9 Jun 2015 14:44:09 +0200
Message-ID: <CAJfpegtM4KnKA+isDTDpakJcaYJT5nhN=pQUJx8Hs58SsondJA@mail.gmail.com>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
	<1433424586-7771-3-git-send-email-miklos@szeredi.hu>
	<20150605000715.GP7232@ZenIV.linux.org.uk>
	<20150605150939.GA2174@tucsk>
	<877frgwcsf.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36661 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbbFIMoL (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Jun 2015 08:44:11 -0400
Received: by qkx62 with SMTP id 62so8382210qkx.3
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jun 2015 05:44:10 -0700 (PDT)
In-Reply-To: <877frgwcsf.fsf@x220.int.ebiederm.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, sa <sa-dev@rainbow.by>, "Roth, Andre" <andre.roth@roche.com>

On Sun, Jun 7, 2015 at 3:02 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> A nasty corner case to be aware of (and I think this is part of what Al
> was warning about).  /proc/sys/net is different depending upon which
> current->nsproxy->net_ns.

Ah,  I'm beginning to grasp what's going on there: mulitple dentries
with the same name but belonging to different namespaces,
->d_compare() being used to select the right one.  Is that it?

Overlayfs checks for d_compare() on the root of the lower and upper
trees, but here it only set on a subdirectory of proc, not on every
dentry.  So overlayfs should be careful and check for
DCACHE_OP_COMPARE | DCACHE_OP_HASH and reject going down such a
dentry.


Thanks,
Miklos
