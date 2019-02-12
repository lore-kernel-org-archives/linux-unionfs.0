Return-Path: <zohar@linux.ibm.com>
Subject: Re: [RFC PATCH 0/5] Fix overlayfs on EVM
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 12 Feb 2019 17:51:37 -0500
In-Reply-To: <CAOQ4uxgSZv7t5HznAhsWrzv3e3VwQ7sbZrjgjfRsviq-wsr7EA@mail.gmail.com>
References: <20190211165323.9369-1-iforster@suse.com>
	 <CAOQ4uxhyk7BEmQYf8D6j8FvYJGaxPoa2oJePeF42jbdp__=PSA@mail.gmail.com>
	 <3938260.lArqBy00Sx@linux-e202.suse.de>
	 <CAOQ4uxgSZv7t5HznAhsWrzv3e3VwQ7sbZrjgjfRsviq-wsr7EA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1550011897.12743.310.camel@linux.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>, Fabian Vogt <fvogt@suse.de>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>


> > > If my assumptions so far are correct, then the effort for making
> > > IMA/EVM work with overlayfs should focus around finding the
> > > places where overlayfs uses lower level vfs interface (often
> > > vfs_xxx helpers) and make sure that the IMA hooks are place
> > > in those lower vfs interfaces, just like vfs_create() patch does
> > > and like vfs_tmpfile() patch did before it.
> >
> > So basically turning on NOIMA for overlayfs while ensuring that integrity
> > checks and operations still perform as expected?
> >
> 
> Yes.
> As far as IMA is concerned, Overlayfs is like a filesystem user from kernel.
> Very similar to knfsd in that respect.

Fabian, if you're thinking of disabling IMA-appraisal on overlay filesystems, 
have you tried defining an appraise policy rule based on the overlayfs
magic number (eg. dont_appraise fsmagic=0x794c7630)?

Mimi
