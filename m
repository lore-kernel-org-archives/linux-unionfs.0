Return-Path: <James.Bottomley@hansenpartnership.com>
Message-ID: <1575216006.4080.3.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/1] fs: rethread notify_change to take a path instead
 of a dentry
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 01 Dec 2019 08:00:06 -0800
In-Reply-To: <CAOQ4uxggMt77HHD4GOk4Rth8KAVz17f5CcZdgAfiMpTuQLz3PA@mail.gmail.com>
References: <1575148763.5563.28.camel@HansenPartnership.com>
	 <1575148868.5563.30.camel@HansenPartnership.com>
	 <CAOQ4uxggMt77HHD4GOk4Rth8KAVz17f5CcZdgAfiMpTuQLz3PA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, 2019-12-01 at 09:04 +0200, Amir Goldstein wrote:
> Hi James!
> 
> On Sat, Nov 30, 2019 at 11:21 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > In order to prepare for implementing shiftfs as a property changing
> > bind mount, the path (which contains the vfsmount) must be threaded
> > through everywhere we are going to do either a permission check or
> > an
> 
> I am curious how bind/shift mount is expected to handle
> inode_permission().

I should be posting the initial patch soon, so you can see.  However
the principle is pretty simple: at the top of the API you have to
install a fsuid/fsgid shifted override credential if the vfsmount is
marked for shifting.  To make that determination you need the path at
all those points, hence this patch.  However, anywhere in the stack
after this, you can make the determination either by the vfsmount flag
or by recognizing the shifted credential.  The latter is how I do this
in inode_permission

> Otherwise, I am fine with the change, short of some style comments
> below...

OK, will fix for v2.

James
