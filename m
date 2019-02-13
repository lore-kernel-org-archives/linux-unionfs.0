Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729612AbfBMIFq (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Feb 2019 03:05:46 -0500
From: Fabian Vogt <fvogt@suse.de>
Subject: Re: [RFC PATCH 0/5] Fix overlayfs on EVM
Date: Wed, 13 Feb 2019 09:05:44 +0100
Message-ID: <4472439.nvz8ndpTJa@linux-e202.suse.de>
In-Reply-To: <1550011897.12743.310.camel@linux.ibm.com>
References: <20190211165323.9369-1-iforster@suse.com> <CAOQ4uxgSZv7t5HznAhsWrzv3e3VwQ7sbZrjgjfRsviq-wsr7EA@mail.gmail.com> <1550011897.12743.310.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-unionfs-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-integrity <linux-integrity@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

Am Dienstag, 12. Februar 2019, 23:51:37 CET schrieb Mimi Zohar:
> 
> > > > If my assumptions so far are correct, then the effort for making
> > > > IMA/EVM work with overlayfs should focus around finding the
> > > > places where overlayfs uses lower level vfs interface (often
> > > > vfs_xxx helpers) and make sure that the IMA hooks are place
> > > > in those lower vfs interfaces, just like vfs_create() patch does
> > > > and like vfs_tmpfile() patch did before it.
> > >
> > > So basically turning on NOIMA for overlayfs while ensuring that integrity
> > > checks and operations still perform as expected?
> > 
> > Yes.
> > As far as IMA is concerned, Overlayfs is like a filesystem user from kernel.
> > Very similar to knfsd in that respect.
> 
> Fabian, if you're thinking of disabling IMA-appraisal on overlay filesystems, 
> have you tried defining an appraise policy rule based on the overlayfs
> magic number (eg. dont_appraise fsmagic=0x794c7630)?

Yes, that was one of the first approaches we tested - basically switching from
a) to b) using configuration. It didn't work: Then IMA was completely
circumvented and neither were hashes updated for changed files nor were they
checked on access. That was a few months ago though, so it might have changed.

Cheers,
Fabian

> Mimi
